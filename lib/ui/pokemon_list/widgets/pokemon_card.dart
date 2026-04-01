import 'package:flutter/material.dart';

import '../../../domain/models/pokemon_summary.dart';

class PokemonCard extends StatelessWidget {
  final PokemonSummary pokemon;
  final VoidCallback onTap;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
