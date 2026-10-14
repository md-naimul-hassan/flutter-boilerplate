# Adding a new feature

Example: a `todo` feature that lists todos from `GET todos?page=`.

## Checklist

1. `app/constants/api_end_point.dart` — add the endpoint.
2. **domain**
   1. `domain/entities/todo_entity.dart`
   2. `domain/repositories/todo_repository.dart`
   3. `domain/usecases/get_todos.dart`
3. **data**
   1. `data/models/todo_model.dart` (extends the entity)
   2. `data/datasources/todo_remote_data_source.dart` (abstract + `Impl`)
   3. `data/repositories/todo_repository_impl.dart`
4. **presentation**
   1. `presentation/bloc/todo_bloc.dart` + `todo_event.dart` + `todo_state.dart`
   2. `presentation/screens/todo_screen.dart`
   3. `presentation/widgets/…` if needed
5. `app/di.dart` — register data source → repository → use cases → bloc.
6. `app/router.dart` — add the route constant and `GoRoute`.
7. Run `fvm flutter analyze`.

## Templates

### Entity

```dart
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  const TodoEntity({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
```

### Repository contract

```dart
import '../../../../core/error/result.dart';
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<Result<List<TodoEntity>>> getTodos(int page);
}
```

### Use case

```dart
import '../../../../core/error/result.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  const GetTodos(this._repository);

  final TodoRepository _repository;

  Future<Result<List<TodoEntity>>> call(int page) => _repository.getTodos(page);
}
```

### Model

```dart
import '../../domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  const TodoModel({required super.id, required super.title});

  factory TodoModel.fromJson(Map<String, dynamic>? json) {
    return TodoModel(id: json?['_id'] ?? '', title: json?['title'] ?? '');
  }
}
```

### Remote data source

```dart
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos(int page);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  const TodoRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<TodoModel>> getTodos(int page) async {
    final response = await _apiClient.get(ApiEndPoint.todos, query: {'page': page});

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((e) => TodoModel.fromJson(e)).toList();
  }
}
```

### Repository implementation

```dart
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._remoteDataSource);

  final TodoRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<TodoEntity>>> getTodos(int page) async {
    try {
      return Success(await _remoteDataSource.getTodos(page));
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }
}
```

### Bloc

```dart
// todo_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todos.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({required this._getTodos}) : super(const TodoState()) {
    on<TodoStarted>(_onStarted);
  }

  final GetTodos _getTodos;

  Future<void> _onStarted(TodoStarted event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: ApiStatus.loading));

    final result = await _getTodos(1);

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(status: ApiStatus.success, todos: data));
      case Failed(:final failure):
        emit(state.copyWith(status: ApiStatus.failure, message: failure.message));
    }
  }
}

// todo_event.dart
part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoStarted extends TodoEvent {
  const TodoStarted();
}

// todo_state.dart
part of 'todo_bloc.dart';

class TodoState extends Equatable {
  const TodoState({
    this.status = ApiStatus.initial,
    this.todos = const [],
    this.message = '',
  });

  final ApiStatus status;
  final List<TodoEntity> todos;
  final String message;

  TodoState copyWith({ApiStatus? status, List<TodoEntity>? todos, String? message}) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, todos, message];
}
```

### DI

```dart
// Todo
sl.registerLazySingleton<TodoRemoteDataSource>(() => TodoRemoteDataSourceImpl(sl()));
sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));
sl.registerLazySingleton(() => GetTodos(sl()));
sl.registerFactory(() => TodoBloc(getTodos: sl()));
```

### Screen

```dart
BlocProvider(
  create: (_) => sl<TodoBloc>()..add(const TodoStarted()),
  child: BlocBuilder<TodoBloc, TodoState>(
    builder: (context, state) => switch (state.status) {
      ApiStatus.initial || ApiStatus.loading => const CommonLoader(),
      ApiStatus.failure => ErrorScreen(
        onTap: () => context.read<TodoBloc>().add(const TodoStarted()),
      ),
      ApiStatus.success => ListView(/* state.todos */),
    },
  ),
);
```
