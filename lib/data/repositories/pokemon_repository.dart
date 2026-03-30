import '../../core/constants/api_constants.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_summary.dart';
import '../services/poke_api_service.dart';

class PokemonRepository {
  final PokeApiService _service;
  final Map<String, List<PokemonSummary>> _typeCache = {};

  PokemonRepository(this._service);

  Future<List<PokemonSummary>> getPokemonByType(String typeName) async {
    if (_typeCache.containsKey(typeName)) {
      return _typeCache[typeName]!;
    }

    final json = await _service.getPokemonByType(typeName);
    final typeList = (json['pokemon'] as List).map((entry) {
      final pokemon = entry['pokemon'] as Map<String, dynamic>;
      final url = pokemon['url'] as String;
      final id = int.parse(url.split('/').where((s) => s.isNotEmpty).last);

      return PokemonSummary(
        id: id,
        name: pokemon['name'] as String,
        url: url,
        svgUrl: '${ApiConstants.dreamWorldSvgUrl}/$id.svg',
      );
    }).toList();

    _typeCache[typeName] = typeList;
    
    return typeList;
  }

  Future<PokemonDetail> getPokemonDetail(String name) async {
    final json = await _service.getPokemonDetail(name);

    final stats = json['stats'] as List;
    int statValue(String statName) => stats.firstWhere(
      (s) => s['stat']['name'] == statName,
    )['base_stat'] as int;

    return PokemonDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      svgUrl: '${ApiConstants.dreamWorldSvgUrl}/${json['id']}.svg',
      gifUrl: '${ApiConstants.showdownGifUrl}/${json['id']}.gif',
      hp: statValue('hp'),
      attack: statValue('attack'),
      defense: statValue('defense'),
    );
  }
}
