import 'package:flutter/material.dart';

import '../../../ui/core/themes/app_theme.dart';
import '../view_models/type_selection.dart';
import '../../pokemon_list/widgets/pokemon_list_screen.dart';

class TypeSelectionScreen extends StatefulWidget {
  const TypeSelectionScreen({super.key});

  @override
  State<TypeSelectionScreen> createState() => _TypeSelectionScreenState();
}

class _TypeSelectionScreenState extends State<TypeSelectionScreen> {
  late final TypeSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TypeSelectionViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 217, 228),
      appBar: AppBar(
        backgroundColor: AppTheme.seedColor,
        title: const Text(
          'Pokémon Explorer',
          style: TextStyle(
            color: Color.fromARGB(255, 247, 249, 109),
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: 1.0,
          ),
          itemCount: _viewModel.types.length,
          itemBuilder: (context, index) {
            final type = _viewModel.types[index];
            return _TypeCard(
              type: type,
              color: AppTheme.typeColor(type),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PokemonListScreen(type: type),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String type;
  final Color color;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icons_types/$type.png',
              height: 82,
              width: 82,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6),
            Text(
              type[0].toUpperCase() + type.substring(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
