import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_explorer/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/utils/result.dart';

import '../../fakes/fake_poke_api_service.dart';

void main() {
  late FakePokeApiService fakeService;
  late PokemonRepository repository;

  setUp(() {
    fakeService = FakePokeApiService();
    repository = PokemonRepository(fakeService);
  });

  group('getPokemonByType', () {
    test('returns Ok with mapped list on success', () async {
      final result = await repository.getPokemonByType('fire');

      expect(result, isA<Ok>());
      final list = (result as Ok).value;
      expect(list.length, 25);
      expect(list.first.name, 'pokemon-0');
      expect(list.first.id, 1);
    });

    test('returns Error when service throws', () async {
      fakeService.shouldThrow = true;

      final result = await repository.getPokemonByType('fire');

      expect(result, isA<Error>());
    });

    test('returns cached result on second call without calling service', () async {
      await repository.getPokemonByType('fire');

      // Make service throw — if cache works, this won't matter
      fakeService.shouldThrow = true;

      final result = await repository.getPokemonByType('fire');

      expect(result, isA<Ok>());
    });

    test('caches per type independently', () async {
      await repository.getPokemonByType('fire');
      final waterResult = await repository.getPokemonByType('water');

      expect(waterResult, isA<Ok>());
    });
  });

  group('getPokemonDetail', () {
    test('returns Ok with correctly mapped detail on success', () async {
      final result = await repository.getPokemonDetail('bulbasaur');

      expect(result, isA<Ok>());
      final detail = (result as Ok).value;
      expect(detail.name, 'bulbasaur');
      expect(detail.hp, 45);
      expect(detail.attack, 49);
      expect(detail.defense, 49);
    });

    test('returns Error when service throws', () async {
      fakeService.shouldThrow = true;

      final result = await repository.getPokemonDetail('bulbasaur');

      expect(result, isA<Error>());
    });
  });
}
