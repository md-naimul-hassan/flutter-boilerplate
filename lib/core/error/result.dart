import 'failures.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;
}
