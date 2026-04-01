# Pokémon Explorer

A Flutter mobile application that allows users to explore Pokemon by type.

## Features

- Select from 10 Pokemon types: Fire, Water, Grass, Electric, Dragon, Psychic, Ghost, Dark, Steel, Fairy
- Search Pokemon within the selected type
- Paginated list — initially shows 10 Pokemon, with a "Load More" option
- Detail view per Pokemon showing name, image, HP, Attack and Defense stats
- Graceful error handling with typed exceptions and retry support
- Empty state for searches with no results


## Architecture

The project follows the [Flutter recommended app architecture](https://docs.flutter.dev/app-architecture/guide), structured around a clear separation of concerns across different layers:

```
lib/
├── config/          # App-wide constants (API URLs, Pokemon types)
├── data/
│   ├── services/    # Stateless HTTP wrappers — talk to PokéAPI, return raw JSON
│   └── repositories/# Transform raw data into domain models, handle caching
├── domain/
│   └── models/      # Pure Dart data classes (PokemonSummary, PokemonDetail)
├── ui/
│   ├── core/        # Shared widgets and app theme
│   └── <feature>/
│       ├── view_models/  # ChangeNotifier ViewModels — one per screen
│       └── widgets/      # Screens and feature-specific widgets
└── utils/           # Command, Result, AppException utilities
```

### Key patterns

**Service / Repository split**
- `PokeApiService` is stateless — it makes HTTP calls and returns raw `Map<String, dynamic>`
- `PokemonRepository` is stateful — it transforms raw data into typed models and caches results per type

**ViewModel / View split**
- ViewModels extend `ChangeNotifier` and own all UI state
- Views are `StatefulWidget` only to manage the ViewModel lifecycle (`initState` / `dispose`)
- UI rebuilds are driven by `ListenableBuilder`, not `setState`

**Command pattern**
- Async operations are wrapped in `Command0` / `Command1<A>` objects
- Commands track their own `isRunning` and `hasError` state, preventing double execution and eliminating boilerplate across ViewModels

**Result\<T\> pattern**
- Repository methods return `Result<T>` (`Ok<T>` or `Error<T>`) instead of throwing
- Makes failure explicit at the type level — the compiler enforces handling both cases

**Typed exceptions**
- `AppException` is a sealed class with three subtypes: `NetworkException`, `ServerException`, `ParseException`
- The `sealed` keyword enables exhaustive switch statements — no silent gaps in error handling


## Pagination

The PokéAPI `/type/{name}` endpoint returns the full roster for a type in a single response (e.g. Fire has 109 Pokemon). The endpoint does not support `limit`/`offset` parameters.

For this reason, pagination is handled client-side: the full list is fetched once, cached in the repository, and revealed progressively in batches of 10 via `PokemonListViewModel`. This also means "Load More" is instant with no additional network calls.


## Packages

| Package | Purpose |
|---|---|
| `http` | HTTP client for PokéAPI calls |
| `provider` | Dependency injection — makes `PokeApiService` and `PokemonRepository` available via `context.read<T>()` |
| `flutter_svg` | Renders dream world SVG sprites on the detail screen |
| `google_fonts` | Kranky font used throughout the app |

---

## Sprites

| Screen | Source |
|---|---|
| Pokemon list | [Home sprites](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/) (PNG) |
| Pokemon detail | [Dream World sprites](https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/) (SVG), falls back to Home sprite if unavailable |


## Running the app

```bash
flutter pub get
flutter run
```

## Building the APK

```bash
flutter build apk --release
```
