import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_explorer/data/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/ui/pokemon_list/view_models/pokemon_list.dart';

import '../../fakes/fake_poke_api_service.dart';

void main() {
  late PokemonRepository repository;
  late PokemonListViewModel viewModel;

  setUp(() {
    repository = PokemonRepository(FakePokeApiService());
  });

  /// Waits for the initial load to complete.
  Future<void> waitForLoad() async {
    await Future.delayed(Duration.zero);
  }

  group('initial load', () {
    test('shows first 10 pokemon after load', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      expect(viewModel.displayedPokemon.length, 10);
    });

    test('hasMore is true when list has more than 10 items', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      expect(viewModel.hasMore, true);
    });
  });

  group('loadMore', () {
    test('increases displayed pokemon by 10', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      viewModel.loadMore();

      expect(viewModel.displayedPokemon.length, 20);
    });

    test('hasMore becomes false when all items are shown', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      // Fake service returns 25 items — load more 3 times to show all
      viewModel.loadMore(); // 20
      viewModel.loadMore(); // 25 (all shown)

      expect(viewModel.hasMore, false);
    });
  });

  group('search', () {
    test('filters pokemon by name', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      viewModel.search('pokemon-1');

      // Matches pokemon-1, pokemon-10, pokemon-11 ... pokemon-19
      expect(viewModel.displayedPokemon.every(
        (p) => p.name.contains('pokemon-1'),
      ), true);
    });

    test('resets page size to 10 when searching', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      viewModel.loadMore(); // page size now 20
      viewModel.search('pokemon'); // should reset to 10

      expect(viewModel.displayedPokemon.length, 10);
    });

    test('returns empty list when no match', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      viewModel.search('zzz_no_match');

      expect(viewModel.displayedPokemon.isEmpty, true);
    });

    test('clears search and restores full list', () async {
      viewModel = PokemonListViewModel(repository: repository, type: 'fire');
      await waitForLoad();

      viewModel.search('zzz_no_match');
      viewModel.search(''); // clear search

      expect(viewModel.displayedPokemon.length, 10);
    });
  });

  group('error handling', () {
    test('load command has error when service fails', () async {
      final failingRepository = PokemonRepository(
        FakePokeApiService()..shouldThrow = true,
      );
      viewModel = PokemonListViewModel(
        repository: failingRepository,
        type: 'fire',
      );
      await waitForLoad();

      expect(viewModel.load.hasError, true);
    });
  });
}
