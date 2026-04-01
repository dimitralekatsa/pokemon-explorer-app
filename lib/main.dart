import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'data/repositories/pokemon_repository.dart';
import 'data/services/poke_api_service.dart';

import 'ui/core/themes/app_theme.dart';
import 'ui/type_selection/widgets/type_selection_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => PokeApiService(http.Client())),
        Provider(
          create: (context) => PokemonRepository(
            context.read<PokeApiService>(),
          ),
        ),
      ],
      child: const PokemonExplorerApp(),
    ),
  );
}

class PokemonExplorerApp extends StatelessWidget {
  const PokemonExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Explorer',
      theme: AppTheme.lightTheme,
      home: const TypeSelectionScreen(),
    );
  }
}
