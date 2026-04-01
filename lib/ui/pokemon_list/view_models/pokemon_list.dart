import 'package:flutter/foundation.dart';

import '../../../data/repositories/pokemon_repository.dart';
import '../../../domain/models/pokemon_summary.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class PokemonListViewModel extends ChangeNotifier {
  final PokemonRepository _repository;
  final String type;

  List<PokemonSummary> _allPokemon = [];
  String _searchQuery = '';
  int _pageSize = 10;

  late final Command0 load;

  PokemonListViewModel({
    required PokemonRepository repository,
    required this.type,
  }) : _repository = repository {
    load = Command0(_load);
    load.execute();
  }

  List<PokemonSummary> get displayedPokemon {
    final filtered = _searchQuery.isEmpty
        ? _allPokemon
        : _allPokemon
            .where((p) => p.name.contains(_searchQuery))
            .toList();
    return filtered.take(_pageSize).toList();
  }

  bool get hasMore {
    final filteredLength = _searchQuery.isEmpty
        ? _allPokemon.length
        : _allPokemon.where((p) => p.name.contains(_searchQuery)).length;
    return _pageSize < filteredLength;
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _pageSize = 10;
    notifyListeners();
  }

  void loadMore() {
    _pageSize += 10;
    notifyListeners();
  }

  Future<void> _load() async {
    final result = await _repository.getPokemonByType(type);
    switch (result) {
      case Ok():
        _allPokemon = result.value;
        notifyListeners();
      case Error():
        throw result.error;
    }
  }
}
