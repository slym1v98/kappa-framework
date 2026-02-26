import 'failure.dart';

abstract class Result<T> {
  const Result();

  R fold<R>(R Function(Failure failure) onError, R Function(T data) onSuccess);

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T? get dataOrNull => fold((_) => null, (data) => data);
  Failure? get failureOrNull => fold((failure) => failure, (_) => null);
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R fold<R>(R Function(Failure f) onError, R Function(T d) onSuccess) =>
      onSuccess(data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);

  @override
  R fold<R>(R Function(Failure f) onError, R Function(T d) onSuccess) =>
      onError(failure);
}
