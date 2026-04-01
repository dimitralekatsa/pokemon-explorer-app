import 'package:http/http.dart' as http;
import 'package:pokemon_explorer/data/services/poke_api_service.dart';
import 'package:pokemon_explorer/utils/app_exception.dart';

/// Fake service that returns hardcoded data without making real HTTP calls.
class FakePokeApiService extends PokeApiService {
  FakePokeApiService() : super(http.Client());

  bool shouldThrow = false;

  @override
  Future<Map<String, dynamic>> getPokemonByType(String typeName) async {
    if (shouldThrow) throw const NetworkException();
    return {
      'pokemon': List.generate(25, (i) => {
        'pokemon': {
          'name': 'pokemon-$i',
          'url': 'https://pokeapi.co/api/v2/pokemon/${i + 1}/',
        }
      }),
    };
  }

  @override
  Future<Map<String, dynamic>> getPokemonDetail(String name) async {
    if (shouldThrow) throw const NetworkException();
    return {
      'id': 1,
      'name': name,
      'sprites': {
        'other': {
          'official-artwork': {'front_default': 'https://example.com/1.png'},
        }
      },
      'stats': [
        {'base_stat': 45, 'stat': {'name': 'hp'}},
        {'base_stat': 49, 'stat': {'name': 'attack'}},
        {'base_stat': 49, 'stat': {'name': 'defense'}},
      ],
    };
  }
}
