# WIP — Feature: Search Articles

## Goal

Implement an **article search** feature using the `/everything` endpoint from NewsAPI.
The user will be able to type a keyword, see results in real time (with debounce), and navigate to the detail of a found article.

This feature exercises **all layers** of Clean Architecture + BLoC.

---

## UX Mockup

```bash
┌──────────────────────────────┐
│  ← Back          Search      │  ← AppBar with title
├──────────────────────────────┤
│  🔍 [___________________]   │  ← Search TextField
├──────────────────────────────┤
│                              │
│  ┌────┐ Article Title 1      │
│  │ img│ Description...       │  ← Same ArticleWidget
│  └────┘ 📅 2026-03-30        │
│  ──────────────────────────  │
│  ┌────┐ Article Title 2      │
│  │ img│ Description...       │
│  └────┘ 📅 2026-03-29        │
│                              │
│  (empty state: "Search for   │
│   articles by keyword")      │
│                              │
│  (error state: retry icon)   │
│                              │
└──────────────────────────────┘
```

Access: 🔍 icon in the `DailyNews` AppBar, next to the bookmark.

---

## Architecture to Implement

### 1. Domain Layer

#### Entity

> Reuse `ArticleEntity` — no new entity needed.

#### Repository (contract)

Add a method to the existing repository:

```dart
// article_repository.dart
Future<DataState<List<ArticleEntity>>> searchArticles(String query);
```

#### Use Case

Create a new use case:

```dart
lib/features/daily_news/domain/usecases/search_article.dart
```

```dart
class SearchArticleUseCase implements Usecase<DataState<List<ArticleEntity>>, String> {
  final ArticleRepository _articleRepository;
  SearchArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call({String? params}) {
    return _articleRepository.searchArticles(params!);
  }
}
```

---

### 2. Data Layer

#### Remote Data Source

Add an endpoint to `NewsApiService`:

```dart
@GET("/everything")
Future<HttpResponse<ArticlesModel>> searchArticles({
  @Query("apiKey") String? apiKey,
  @Query("q") String? query,
  @Query("sortBy") String? sortBy,
});
```

> ⚠️ After modification, remember to regenerate: `dart run build_runner build --delete-conflicting-outputs`

#### Repository Implementation

Implement `searchArticles` in `ArticleRepositoryImpl`:

```dart
@override
Future<DataState<List<ArticleModel>>> searchArticles(String query) async {
  try {
    final httpResponse = await _newsApiService.searchArticles(
      apiKey: newsApiKey,
      query: query,
      sortBy: 'publishedAt',
    );
    if (httpResponse.response.statusCode == HttpStatus.ok) {
      return DataSuccess(httpResponse.data.articles);
    } else {
      return DataFailed(DioException(...));
    }
  } on DioException catch (e) {
    return DataFailed(e);
  }
}
```

---

### 3. Presentation Layer

#### BLoC

Create the directory:

```bash
lib/features/daily_news/presentation/bloc/article/search/
├── search_article_bloc.dart
├── search_article_event.dart
└── search_article_state.dart
```

**Events:**

```dart
abstract class SearchArticleEvent extends Equatable { ... }

class SearchArticles extends SearchArticleEvent {
  final String query;
  const SearchArticles(this.query);
}
```

**States:**

```dart
abstract class SearchArticleState extends Equatable { ... }

class SearchArticleInitial extends SearchArticleState {}    // initial empty state
class SearchArticleLoading extends SearchArticleState {}    // loading
class SearchArticleLoaded extends SearchArticleState {      // results
  final List<ArticleEntity> articles;
}
class SearchArticleError extends SearchArticleState {       // error
  final DioException error;
}
```

**BLoC:**

```dart
class SearchArticleBloc extends Bloc<SearchArticleEvent, SearchArticleState> {
  final SearchArticleUseCase _searchArticleUseCase;

  SearchArticleBloc(this._searchArticleUseCase)
      : super(const SearchArticleInitial()) {
    on<SearchArticles>(
      onSearchArticles,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  void onSearchArticles(SearchArticles event, Emitter<SearchArticleState> emit) async {
    if (event.query.isEmpty) {
      emit(const SearchArticleInitial());
      return;
    }
    emit(const SearchArticleLoading());
    final dataState = await _searchArticleUseCase(params: event.query);
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(SearchArticleLoaded(articles: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(SearchArticleError(dataState.error!));
    } else {
      emit(const SearchArticleInitial());
    }
  }
}
```

> 💡 **Bonus — Debounce:** use `bloc_concurrency` or a custom `EventTransformer` to avoid spamming the API on every keystroke. Example:
>
> ```dart
> EventTransformer<T> debounce<T>(Duration duration) {
>   return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
> }
> ```
>
> Requires `rxdart` in the dependencies.

#### Page

```bash
lib/features/daily_news/presentation/pages/search/search_articles.dart
```

Structure:

- `BlocProvider<SearchArticleBloc>` as wrapper
- `TextField` at the top with `onChanged` dispatching `SearchArticles(query)`
- `BlocBuilder` that displays:
  - `SearchArticleInitial` → message "Search for articles by keyword"
  - `SearchArticleLoading` → `CupertinoActivityIndicator`
  - `SearchArticleLoaded` → `ListView` of `ArticleWidget` (reuse the existing widget)
  - `SearchArticleError` → refresh icon
- Tap on an article → navigate to `/ArticleDetails`

---

### 4. Dependency Injection

In `injection_container.dart`, add:

```dart
// Usecases
sl.registerSingleton<SearchArticleUseCase>(
  SearchArticleUseCase(sl())
);

// BLoCs
sl.registerFactory<SearchArticleBloc>(
  () => SearchArticleBloc(sl())
);
```

---

### 5. Routing

In `app_router.dart`, add:

```dart
case '/SearchArticles':
  return MaterialPageRoute(
    builder: (_) => const SearchArticles(),
  );
```

In `daily_news.dart`, add a 🔍 icon in the AppBar `actions`:

```dart
IconButton(
  icon: const Icon(Icons.search, color: Colors.black),
  onPressed: () => Navigator.pushNamed(context, '/SearchArticles'),
),
```

---

## Checklist

- [ ] `domain/usecases/search_article.dart` — Use case
- [ ] `domain/repository/article_repository.dart` — Add `searchArticles`
- [ ] `data/data_sources/remote/news_api_service.dart` — Add `/everything` endpoint
- [ ] `dart run build_runner build --delete-conflicting-outputs` — Regenerate Retrofit code
- [ ] `data/repository/article_repository_impl.dart` — Implement `searchArticles`
- [ ] `presentation/bloc/article/search/search_article_event.dart`
- [ ] `presentation/bloc/article/search/search_article_state.dart`
- [ ] `presentation/bloc/article/search/search_article_bloc.dart`
- [ ] `presentation/pages/search/search_articles.dart` — Full page
- [ ] `injection_container.dart` — Register use case + BLoC
- [ ] `config/routes/app_router.dart` — Route `/SearchArticles`
- [ ] `presentation/pages/home/daily_news.dart` — Search icon in AppBar
- [ ] `flutter analyze` — 0 errors

## Constraints

- **Do not touch** existing features (daily_news remote, saved articles)
- **Reuse** `ArticleWidget` to display results
- **Reuse** `ArticleEntity` / `ArticleModel` / `ArticlesModel`
- Respect **layer separation**: domain depends on nothing, data implements domain, presentation uses domain via use cases
- The BLoC must **never** directly import `data` classes
