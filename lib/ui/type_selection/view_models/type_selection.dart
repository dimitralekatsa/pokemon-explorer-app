import '../../../config/api_constants.dart';

class TypeSelectionViewModel {
  final List<String> types;

  TypeSelectionViewModel()
      : types = List.of(ApiConstants.pokemonTypes)..shuffle();
}
