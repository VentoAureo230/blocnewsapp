# blocnewsapp

Learning project for Flutter Bloc pattern with Clean Architecture.

This app gets his Data from NewsAPI.org (REST APIs). Data is locally in the device.

## Structure

Here we use Clean Architecture in the project, so we have three main layers: Core, Features and Config. Each layer has its own responsibility and is independent from the others.

Core layer contains all the core functionalities of the app, such as constants, resources, usecases and util. This layer is independent from the features and can be used in any feature.

Config layer contains all the configuration of the app, such as routes and theme. This layer is independent from the features and can be used in any feature.

Features layer contains all the features of the app, such as `daily news`. Each feature has its own data, domain and presentation layers.

The `data layer` contains all the data sources, models and repository implementations.

The `domain layer` contains all the entities, repository interfaces and usecases.

The `presentation layer` contains all the bloc (state management), pages and widgets.

```bash
.
├── config
│   ├── routes
│   └── theme
├── core
│   ├── constants
│   ├── resources
│   ├── usecases
│   └── util
├── features
│   └── daily_news
│       ├── data
│       │   ├── data_sources
│       │   │   ├── local
│       │   │   └── remote
│       │   ├── models
│       │   └── repository
│       ├── domain
│       │   ├── entities
│       │   ├── repository
│       │   └── usecases
│       └── presentation
│           ├── bloc
│           ├── pages
│           └── widget
└── main.dart
```
