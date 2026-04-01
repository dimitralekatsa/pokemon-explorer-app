import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/pokemon_repository.dart';
import '../../../ui/core/themes/app_theme.dart';
import '../../../ui/core/ui/error_view.dart';
import '../view_models/pokemon_detail.dart';
import 'stat_row.dart';

class PokemonDetailScreen extends StatefulWidget {
  final String name;
  final String type;

  const PokemonDetailScreen({
    super.key,
    required this.name,
    required this.type,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late final PokemonDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PokemonDetailViewModel(
      repository: context.read<PokemonRepository>(),
      name: widget.name,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = AppTheme.typeColor(widget.type);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: typeColor,
        title: Text(
          widget.name[0].toUpperCase() + widget.name.substring(1),
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([_viewModel, _viewModel.load]),
        builder: (context, _) {
          if (_viewModel.load.isRunning) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.load.hasError) {
            return ErrorView(
              error: _viewModel.load.error!,
              onRetry: _viewModel.load.execute,
            );
          }

          final pokemon = _viewModel.pokemon;
          if (pokemon == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SvgPicture.network(
                  pokemon.svgUrl,
                  height: 180,
                  fit: BoxFit.contain,
                  placeholderBuilder: (_) => const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    pokemon.imageUrl,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                // Text(
                //   pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                //   style: Theme.of(context).textTheme.headlineMedium,
                // ),
                const SizedBox(height: 32),
                StatRow(label: 'HP', value: pokemon.hp, color: typeColor),
                StatRow(label: 'Attack', value: pokemon.attack, color: typeColor),
                StatRow(label: 'Defense', value: pokemon.defense, color: typeColor),
              ],
            ),
          );
        },
      ),
    );
  }
}
