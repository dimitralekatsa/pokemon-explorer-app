import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/pokemon_repository.dart';
import '../../../ui/core/themes/app_theme.dart';
import '../../../ui/core/ui/empty_view.dart';
import '../../../ui/core/ui/error_view.dart';
import '../../../ui/pokemon_detail/widgets/pokemon_detail_screen.dart';
import '../view_models/pokemon_list.dart';
import 'pokemon_card.dart';

class PokemonListScreen extends StatefulWidget {
  final String type;

  const PokemonListScreen({super.key, required this.type});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late final PokemonListViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = PokemonListViewModel(
      repository: context.read<PokemonRepository>(),
      type: widget.type,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = AppTheme.typeColor(widget.type);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: typeColor,
        title: Text(
          widget.type[0].toUpperCase() + widget.type.substring(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _viewModel.search,
              decoration: InputDecoration(
                hintText: 'Search Pokémon...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
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

                final pokemon = _viewModel.displayedPokemon;

                if (pokemon.isEmpty) {
                  return const EmptyView();
                }

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => PokemonCard(
                            pokemon: pokemon[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PokemonDetailScreen(
                                    name: pokemon[index].name,
                                    type: widget.type,
                                  ),
                                ),
                              );
                            },
                          ),
                          childCount: pokemon.length,
                        ),
                      ),
                    ),
                    if (_viewModel.hasMore)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                          child: ElevatedButton(
                            onPressed: _viewModel.loadMore,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(230, 227, 69, 69),
                              foregroundColor: Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Load More',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
