import '../../core/failure.dart';

enum KappaStatus { initial, loading, success, error, empty }

class KappaState<T> {
  final T? data;
  final KappaStatus status;
  final Failure? failure;

  const KappaState({
    this.data,
    this.status = KappaStatus.initial,
    this.failure,
  });

  factory KappaState.loading() => const KappaState(status: KappaStatus.loading);
  factory KappaState.success(T data) =>
      KappaState(data: data, status: KappaStatus.success);
  factory KappaState.error(Failure f) =>
      KappaState(failure: f, status: KappaStatus.error);

  bool get isLoading => status == KappaStatus.loading;
  bool get isSuccess => status == KappaStatus.success;
  bool get isError => status == KappaStatus.error;
}
