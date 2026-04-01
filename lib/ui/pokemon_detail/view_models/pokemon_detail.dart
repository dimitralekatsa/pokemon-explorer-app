import 'package:flutter/foundation.dart';

import '../../../data/repositories/pokemon_repository.dart';
import '../../../domain/models/pokemon_detail.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class PokemonDetailViewModel extends ChangeNotifier {
  final PokemonRepository _repository;
  final String name;

  PokemonDetail? _pokemon;
  PokemonDetail? get pokemon => _pokemon;

  late final Command0 load;

  PokemonDetailViewModel({
    required PokemonRepository repository,
    required this.name,
  }) : _repository = repository {
    load = Command0(_load);
    load.execute();
  }

  Future<void> _load() async {
    final result = await _repository.getPokemonDetail(name);
    switch (result) {
      case Ok():
        _pokemon = result.value;
        notifyListeners();
      case Error():
        throw result.error;
    }
  }
}
