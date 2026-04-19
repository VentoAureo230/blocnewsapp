# WIP2 — Feature: Weather Widget (Cubit)

## Goal

Add a **weather widget** at the top of the DailyNews page that displays the user's current weather.
Uses the free [OpenWeatherMap](https://openweathermap.org/api) API and introduces a **complete new feature** (`weather`) alongside `daily_news`, with its own Clean Architecture.

This feature exercises: creating a **feature from scratch**, a new **remote data source**, new **entities/models**, and integrating a **Cubit** widget into an existing page.

---

## BLoC vs Cubit — Key Differences

| | **BLoC** | **Cubit** |
| --- | --- | --- |
| Input | Events (classes) | Direct method calls |
| Files | 3 files (bloc, event, state) | 2 files (cubit, state) |
| Boilerplate | More — needs event classes + `on<Event>` handlers | Less — just methods that `emit()` |
| Event transforms | Supports `transformer` (debounce, throttle…) | Not built-in (use manually) |
| Traceability | Full event log via `onEvent`/`onTransition` | Only `onChange` |
| Use when | Complex flows, multiple events, event transforms | Simple state management, fewer events |

**Cubit is simpler:** no event classes, no `on<>` registration — you call methods directly and `emit()` new states.

```bash
BLoC:   UI → add(Event) → on<Event>(handler) → emit(State)
Cubit:  UI → cubit.method() → emit(State)
```

---

## UX Mockup

```bash
┌──────────────────────────────┐
│  Daily News        🔖        │  ← Existing AppBar
├──────────────────────────────┤
│  ┌──────────────────────────┐│
│  │ 🌤  22°C    Paris        ││  ← Weather banner
│  │ Partly cloudy            ││
│  └──────────────────────────┘│
│  ──────────────────────────  │
│  ┌────┐ Article Title 1      │
│  │ img│ Description...       │  ← Existing article list
│  └────┘ 📅 2026-03-30        │
│  ...                         │
└──────────────────────────────┘
```

The weather banner is displayed above the article list. If the request fails, the banner is not shown (graceful degradation).

---

## New Feature Structure

```bash
lib/features/weather/
├── data/
│   ├── data_sources/remote/
│   │   └── weather_api_service.dart      ← Retrofit service
│   ├── models/
│   │   └── weather.dart                  ← WeatherModel (extends WeatherEntity)
│   └── repository/
│       └── weather_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── weather.dart                  ← WeatherEntity (Equatable)
│   ├── repository/
│   │   └── weather_repository.dart       ← Abstract contract
│   └── usecases/
│       └── get_weather.dart              ← GetWeatherUseCase
└── presentation/
    ├── cubit/
    │   ├── weather_cubit.dart            ← Cubit (no event file needed!)
    │   └── weather_state.dart
    └── widget/
        └── weather_banner.dart           ← Reusable widget
```

> Notice: **no `weather_event.dart`** — that's the main structural difference with Cubit.

---

## Architecture to Implement

### 1. Domain Layer

- **WeatherEntity** — fields: `cityName`, `temperature` (double), `description`, `icon` — extends `Equatable`
- **WeatherRepository** (abstract contract) — method `Future<DataState<WeatherEntity>> getCurrentWeather(String city)`
- **GetWeatherUseCase** — implements `Usecase<DataState<WeatherEntity>, String>`, calls the repository

> Domain layer is **identical** whether you use BLoC or Cubit — it doesn't know about the presentation pattern.

### 2. Data Layer

- **WeatherModel** — extends `WeatherEntity`, with `fromJson` that parses the OpenWeatherMap response:
  - `map['name']` → cityName
  - `map['main']['temp']` → temperature
  - `map['weather'][0]['description']` → description
  - `map['weather'][0]['icon']` → icon

- **WeatherApiService** (Retrofit):
  - Base URL: `https://api.openweathermap.org/data/2.5`
  - `@GET("/weather")` with `@Query("q")`, `@Query("appid")`, `@Query("units")`
  - Returns `HttpResponse<WeatherModel>`

> ⚠️ After creation, regenerate: `dart run build_runner build --delete-conflicting-outputs`
> 💡 Store the API key in `.env`: `WEATHER_API_KEY=your_key_here`
> Add in `constants.dart`: `final String weatherApiKey = dotenv.env['WEATHER_API_KEY'] ?? '';`

- **WeatherRepositoryImpl** — same pattern as `ArticleRepositoryImpl`: try/catch `DioException`, check `HttpStatus.ok`, return `DataSuccess` or `DataFailed`

> Data layer is also **identical** — Cubit vs BLoC only affects the presentation layer.

### 3. Presentation Layer (Cubit approach)

- **WeatherState** — 3 states: `WeatherLoading`, `WeatherLoaded(weather)`, `WeatherError` (same as BLoC)
- **WeatherCubit** — extends `Cubit<WeatherState>` instead of `Bloc<WeatherEvent, WeatherState>`
  - No event classes needed
  - No `on<Event>` registration
  - Just a `getWeather(String city)` method that calls the use case and `emit()`s the new state directly
  - Initial state: `WeatherLoading()`

- **WeatherBanner** — uses `BlocBuilder<WeatherCubit, WeatherState>` (same `BlocBuilder` widget — it works with both BLoC and Cubit since Cubit is a subset of BLoC)

> 💡 Weather icon: `https://openweathermap.org/img/wn/{icon}@2x.png`

### 4. Dependency Injection

In `injection_container.dart`, register: `WeatherApiService`, `WeatherRepository`, `GetWeatherUseCase` (singletons) and `WeatherCubit` (factory).

### 5. Integration into DailyNews

- Wrap the `Scaffold` in a `BlocProvider<WeatherCubit>` (yes, `BlocProvider` works for Cubits too)
- Instead of `..add(GetWeather('Paris'))`, call `..getWeather('Paris')` directly on creation
- Add `WeatherBanner()` above the article list in a `Column` + `Expanded`

> 💡 **Bonus — Geolocation:** use the `geolocator` package to get the position instead of hardcoding `'Paris'`.

---

## Checklist

- [ ] Create `lib/features/weather/domain/entities/weather.dart`
- [ ] Create `lib/features/weather/domain/repository/weather_repository.dart`
- [ ] Create `lib/features/weather/domain/usecases/get_weather.dart`
- [ ] Create `lib/features/weather/data/models/weather.dart`
- [ ] Create `lib/features/weather/data/data_sources/remote/weather_api_service.dart`
- [ ] `dart run build_runner build --delete-conflicting-outputs`
- [ ] Create `lib/features/weather/data/repository/weather_repository_impl.dart`
- [ ] Create `lib/features/weather/presentation/cubit/weather_state.dart`
- [ ] Create `lib/features/weather/presentation/cubit/weather_cubit.dart`
- [ ] Create `lib/features/weather/presentation/widget/weather_banner.dart`
- [ ] Add `WEATHER_API_KEY` in `.env` and `weatherApiKey` in `constants.dart`
- [ ] Register dependencies in `injection_container.dart`
- [ ] Integrate `WeatherBanner` into `daily_news.dart`
- [ ] `flutter analyze` — 0 errors

## Constraints

- **Isolated feature** — Everything lives in `lib/features/weather/`, independent from `daily_news`
- **Reuse** existing core layers (`DataState`, `Usecase`) and the `Dio` singleton
- **Use Cubit**, not BLoC — no event classes, direct method calls
- The domain **never** depends on the data layer
- The Cubit **never** depends directly on the data layer
- Graceful degradation: if the API call fails, the banner disappears silently
