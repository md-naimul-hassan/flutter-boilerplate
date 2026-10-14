# Reference: md-naimul-hassan/todo-app

Source: <https://github.com/md-naimul-hassan/todo-app> (single commit `adf1bd0`, "update",
Sep 2026). Package name `untitled`, Dart SDK `^3.12.1`. Dependencies: `flutter_bloc`,
`get_it`, `equatable`, `dio`, `pretty_dio_logger`. Backend: `https://dummyjson.com`.

## Layout

```text
lib/
├── main.dart                         # initDependency(); MultiBlocProvider(blocs) → TodoScreen
├── app/
│   ├── bloc.dart                     # global List<BlocProvider> blocs
│   ├── dependency.dart               # get_it registrations (getIt)
│   └── const/{api_end_point,app_string}.dart
├── core/
│   ├── error/
│   │   ├── exception.dart            # ServerException, NetworkException, UnknownException, catchException()
│   │   ├── failure.dart              # Failure (Equatable) + Server/Network/Unknown, catchFailure()
│   │   └── result.dart               # sealed Result<T> { Success<T>(data), Failed<T>(failure) }
│   └── network/                      # ApiClient (abstract), DioApiClient, DioConfig, interceptors,
│                                     # ApiResponseModel, ApiResponseHandler, MultipartHelper
└── features/todo/
    ├── data/
    │   ├── datasources/todo_remote_data_source.dart   # abstract + Impl, uses ApiClient
    │   ├── models/todo_model.dart                     # extends TodoEntity; fromJson/toJson/fromEntity/toEntity
    │   └── repositories/todo_repsitory_impl.dart      # implements TodoRepository, returns Result
    ├── domain/
    │   ├── entities/todo_entity.dart                  # Equatable, const ctor, copyWith
    │   ├── repositories/todo_repository.dart          # abstract contract
    │   └── usecauses/{get_todos,add_todo}.dart        # one class per use case with call()
    └── presentation/
        ├── bloc/todo_bloc.dart (+ part todo_event.dart, todo_state.dart)
        └── screens/todo_screen.dart
```

## Patterns we adopted

1. **Three layers per feature** — `data / domain / presentation`, with `domain` free of
   Flutter, Dio and JSON.
2. **Entity ← Model inheritance** — `TodoModel extends TodoEntity` and adds
   `fromJson`/`toJson`. Repositories can return models typed as entities, no mapping
   boilerplate needed.
3. **Abstract data source + `Impl`** — `TodoRemoteDataSource` / `TodoRemoteDataSourceImpl`,
   registered in DI under the abstract type.
4. **Repository contract in domain, implementation in data** — `TodoRepository` /
   `TodoRepositoryImpl`.
5. **One use case per class** exposing `call(...)`, so blocs invoke `_getTodos()` like a function.
6. **`Result<T>` sealed class** — repositories never throw; blocs `switch` on
   `Success(:final data)` / `Failed(:final failure)`.
7. **`Failure` hierarchy (Equatable)** with a `catchFailure(Object)` mapper from exceptions.
8. **Bloc file + `part` event/state files**, events and states extend `Equatable`,
   state is immutable with `copyWith`.
9. **Feature-prefixed file names** — `todo_bloc.dart`, `todo_event.dart`, `todo_state.dart`,
   `todo_remote_data_source.dart`, `todo_repository_impl.dart`, `screens/todo_screen.dart`.
10. **Constructor injection everywhere** and a single DI file registering data source →
    repository → use cases → bloc.

## Quirks and bugs we deliberately did NOT copy

| In the reference | Problem | What we do instead |
| --- | --- | --- |
| Folder `usecauses/`, file `todo_repsitory_impl.dart` | Typos | `usecases/`, `*_repository_impl.dart` |
| `throw catchException(e.toString())` in the data source | Converting to a `String` loses the exception type, so every error becomes `UnknownException` | Data sources throw typed `AppException`s; repositories map the original object with `catchFailure(e)` |
| `addTodo` returns `Future<TodoEntity>` and the repository `rethrow`s | Inconsistent: one method returns `Result`, the other throws | **Every** repository method returns `Future<Result<T>>` |
| `Failure` constructor calls `print` | Side effect in a value object, violates `avoid_print` | Pure `const` failures; logging happens where errors are caught if needed |
| `TodoBloc` dispatches `GetTodosEvent` in its constructor and is a global lazy singleton provided at app root | Hidden side effect at creation; state lives forever | Screens dispatch their initial event; screen-scoped blocs are `registerFactory` |
| Hard-coded values in `_onAddTodo` (`userId: 5, title: "title"`) and unused event fields | Demo code | Events carry the data the handler uses |
| `TodoState.props` omits `isLoading` | Equatable would treat loading/non-loading states as equal and drop emits | `props` lists **every** field |
| Data source checks `statusCode == 200` and silently returns `[]` otherwise | Errors are swallowed | Check `response.isSuccess`, otherwise `throw ApiException(statusCode, message)` |
| Private named constructor params (`required this._getTodos`) | Adopted — project is on Dart `^3.13.5` (private named params need 3.12+). Call sites use the public name: `TodoBloc(getTodos: sl())` | Same |
| `app/bloc.dart` global `MultiBlocProvider` | Every bloc created at startup | Blocs are provided where they are used (screen or flow) |

## What this project already had that the reference lacks

- `go_router` navigation (`lib/app/router.dart`) and `AppNavigator` helper.
- Rich exception hierarchy (`ApiException`, `UnauthorizedException`, …) with status codes.
- `ApiStatus` enum (`initial / loading / success / failure`) instead of a bare `isLoading` flag.
- `LocalStorage` (SharedPreferences), `SocketService` (Socket.IO), `AppSnackbar`, logger,
  shared UI components, `flutter_screenutil` responsive sizing.

These are kept; the reference's *layering* is applied on top of them.
