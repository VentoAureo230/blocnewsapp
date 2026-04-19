# WIP2 — Feature: Weather Widget

## Goal

Add a **weather widget** at the top of the DailyNews page that displays the user's current weather.
Uses the free [OpenWeatherMap](https://openweathermap.org/api) API and introduces a **complete new feature** (`weather`) alongside `daily_news`, with its own Clean Architecture.

This feature exercises: creating a **feature from scratch**, a new **remote data source**, new **entities/models**, and integrating a BLoC widget into an existing page.

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

```
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
    ├── bloc/
    │   ├── weather_bloc.dart
    │   ├── weather_event.dart
    │   └── weather_state.dart
    └── widget/
        └── weather_banner.dart           ← Reusable widget
```

---

## Architecture to Implement

### 1. Domain Layer

- **WeatherEntity** — fields: `cityName`, `temperature` (double), `description`, `icon` — extends `Equatable`
- **WeatherRepository** (abstract contract) — method `Future<DataState<WeatherEntity>> getCurrentWeather(String city)`
- **GetWeatherUseCase** — implements `Usecase<DataState<WeatherEntity>, String>`, calls the repository

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

### 3. Presentation Layer

- **WeatherEvent** — single event: `GetWeather(String city)`
- **WeatherState** — 3 states: `WeatherLoading`, `WeatherLoaded(weather)`, `WeatherError`
- **WeatherBloc** — dispatch `GetWeather` → calls the use case → emits `Loaded` or `Error`
- **WeatherBanner** — `BlocBuilder`: if `WeatherLoaded`, displays icon + temperature + city + description in a rounded `Container`. Otherwise, `SizedBox.shrink()` (invisible)

> 💡 Weather icon: `https://openweathermap.org/img/wn/{icon}@2x.png`

### 4. Dependency Injection

In `injection_container.dart`, register: `WeatherApiService`, `WeatherRepository`, `GetWeatherUseCase` (singletons) and `WeatherBloc` (factory).

### 5. Integration into DailyNews

- Wrap the `Scaffold` in a `BlocProvider<WeatherBloc>` that dispatches `GetWeather('Paris')` on creation
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
- [ ] Create `lib/features/weather/presentation/bloc/weather_event.dart`
- [ ] Create `lib/features/weather/presentation/bloc/weather_state.dart`
- [ ] Create `lib/features/weather/presentation/bloc/weather_bloc.dart`
- [ ] Create `lib/features/weather/presentation/widget/weather_banner.dart`
- [ ] Add `WEATHER_API_KEY` in `.env` and `weatherApiKey` in `constants.dart`
- [ ] Register dependencies in `injection_container.dart`
- [ ] Integrate `WeatherBanner` into `daily_news.dart`
- [ ] `flutter analyze` — 0 errors

## Constraints

- **Isolated feature** — Everything lives in `lib/features/weather/`, independent from `daily_news`
- **Reuse** existing core layers (`DataState`, `Usecase`) and the `Dio` singleton
- The domain **never** depends on the data layer
- The BLoC **never** depends directly on the data layer
- Graceful degradation: if the API call fails, the banner disappears silently
