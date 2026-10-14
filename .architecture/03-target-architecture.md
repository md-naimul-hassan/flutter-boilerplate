# Target architecture

## 1. Top-level layout

```text
lib/
├── main.dart                 # bootstrap: zone guard, LocalStorage.init, DI, socket
├── app/                      # app shell — may import anything
│   ├── app.dart              # MaterialApp.router
│   ├── router.dart           # AppRoutes, appRouter, AppNavigator
│   ├── di.dart               # get_it composition root (sl)
│   ├── enum.dart             # ApiStatus, …
│   ├── theme.dart
│   └── constants/            # ApiEndPoint, AppColors, AppImages, AppIcons, AppString
├── core/                     # shared, feature-agnostic — must NOT import features/
│   ├── component/            # reusable widgets
│   ├── error/                # exceptions.dart, failures.dart, result.dart, error_handler.dart
│   ├── models/               # cross-feature models (UserModel — the logged-in user)
│   ├── network/              # ApiClient, DioApiClient, interceptors, response handling
│   ├── services/socket/      # SocketService
│   ├── storage/              # LocalStorage
│   └── utils/                # snackbar, logger, extensions, validation, helpers
└── features/<feature>/       # one folder per feature (auth groups sub-features)
    ├── domain/
    │   ├── entities/<name>_entity.dart
    │   ├── repositories/<feature>_repository.dart
    │   └── usecases/<verb_noun>.dart
    ├── data/
    │   ├── models/<name>_model.dart
    │   ├── datasources/<feature>_remote_data_source.dart
    │   └── repositories/<feature>_repository_impl.dart
    └── presentation/
        ├── bloc/<name>_bloc.dart  (+ part <name>_event.dart, <name>_state.dart)
        ├── screens/<name>_screen.dart
        └── widgets/<name>.dart
```

A feature only creates the folders it needs. `splash` and `onboarding` are
presentation-only (`presentation/screens/`). A feature with no returned data (e.g.
`change_password`) has no `entities/` or `models/`.

## 2. Dependency rule

```text
presentation ──▶ domain ◀── data
      │                       │
      └──────▶ core ◀─────────┘        app ──▶ everything (composition root)
```

| Layer | May import | Must NOT import |
| --- | --- | --- |
| `domain` | `core/error/result.dart`, `core/error/failures.dart`, `equatable`, its own entities | Flutter, Dio, `data/`, `presentation/`, `LocalStorage`, JSON |
| `data` | its own `domain`, `core/network`, `core/error`, `core/storage`, `core/services`, `core/models`, `app/constants` | `presentation/`, other features' `data/` |
| `presentation` | its own `domain` (entities + use cases), `core/*`, `app/*` | its own or other features' `data/` |
| `core` | `app/constants` | `features/` |

Cross-feature reuse goes through `core/` (e.g. the logged-in `UserModel` lives in
`core/models/` because `LocalStorage`, profile and messaging all need it).

## 3. Naming conventions

| Thing | File | Class |
| --- | --- | --- |
| Entity | `chat_entity.dart` | `ChatEntity` |
| Model | `chat_model.dart` | `ChatModel extends ChatEntity` |
| Remote data source | `message_remote_data_source.dart` | `MessageRemoteDataSource` (abstract) + `MessageRemoteDataSourceImpl` |
| Repository contract | `message_repository.dart` | `MessageRepository` (abstract) |
| Repository impl | `message_repository_impl.dart` | `MessageRepositoryImpl` |
| Use case | `get_chats.dart` | `GetChats` with `call(...)` |
| Bloc | `chat_bloc.dart` + `part` files `chat_event.dart`, `chat_state.dart` | `ChatBloc`, `ChatEvent`, `ChatState` |
| Screen | `screens/chat_list_screen.dart` | `ChatListScreen` |

Folders are always plural: `entities`, `models`, `datasources`, `repositories`,
`usecases`, `screens`, `widgets`. Strings use single quotes; trailing commas required
(see `analysis_options.yaml`).

## 4. Error flow

```text
ApiClient          never throws; returns ApiResponseModel(statusCode, data)
                   (timeout → 408, no connection → 503, bad response → real code)
   │
RemoteDataSource   if (!response.isSuccess) throw ApiException(statusCode, message)
   │               returns models on success
   │
RepositoryImpl     try { … return Success(data); } catch (e) { return Failed(catchFailure(e)); }
   │               also persists side effects (LocalStorage) on success
   │
UseCase            pass-through: returns the repository's Future<Result<T>>
   │
Bloc               switch (result) {
                     case Success(:final data): emit(success…);
                     case Failed(:final failure): emit(failure…, message: failure.message);
                   }
```

`catchFailure(Object error)` (in `core/error/failures.dart`) maps:

| Error | Failure |
| --- | --- |
| `AppException` with status 401 | `UnauthorizedFailure` |
| `AppException` with status 408 or 503, or `InternetException` | `NetworkFailure` |
| any other `AppException` | `ServerFailure(message, statusCode)` |
| anything else | `UnknownFailure` (generic message; real error is logged) |

`Result<T>` lives in `core/error/result.dart`:

```dart
sealed class Result<T> { const Result(); }
class Success<T> extends Result<T> { const Success(this.data); final T data; }
class Failed<T>  extends Result<T> { const Failed(this.failure); final Failure failure; }
```

Methods with nothing to return use `Result<void>` and `return const Success(null);`.

## 5. Dependency injection (`lib/app/di.dart`)

Register bottom-up, grouped per feature:

```dart
// data source
sl.registerLazySingleton<XRemoteDataSource>(() => XRemoteDataSourceImpl(sl()));
// repository
sl.registerLazySingleton<XRepository>(() => XRepositoryImpl(sl()));
// use cases
sl.registerLazySingleton(() => GetX(sl()));
// blocs
sl.registerFactory(() => XBloc(getX: sl()));          // screen-scoped
sl.registerLazySingleton(() => FlowBloc(...));        // shared across a multi-screen flow
```

- **Screen-scoped blocs** (one screen owns them) → `registerFactory`, provided with
  `BlocProvider(create: (_) => sl<XBloc>())` or created in `initState` and closed in `dispose`.
- **Flow blocs** shared across several routes (`SignUpBloc`, `ForgotPasswordBloc`) →
  `registerLazySingleton`, provided with `BlocProvider.value(value: sl<XBloc>())`.
  Never `close()` them from a screen. Earlier screens of the flow stay mounted under
  later ones, so give each screen's action its own status field (`signUpStatus`,
  `verifyStatus`, `resendStatus`, …) and `listenWhen` only on that field — otherwise an
  action on screen 2 can re-trigger navigation on screen 1.
- Screens never construct data sources, repositories or use cases.

## 6. BLoC conventions

- One bloc per file, events/state as `part` files.
- Events and states extend `Equatable` and list **every** field in `props`.
- State is immutable with `copyWith`; status is an `ApiStatus`.
- Handlers call use cases only, and `switch` on `Result`.
- Initial loads are dispatched by the screen (`..add(XStarted())`), not by the bloc constructor.
- Socket subscriptions are started from an event handler and stopped from a close event or `close()`.

## 7. Entities and models

- Entities: `const` constructors, `Equatable`, no JSON. Nested value objects are entities too.
- Models extend their entity, add `fromJson` (null-safe, with defaults) and `toJson`
  when the app sends them back.
- Raw API shapes that do not map 1:1 to an entity (e.g. `MessageModel`) stay data-only
  and are mapped to an entity in the repository.
