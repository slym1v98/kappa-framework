import '../core/result.dart';
import '../core/failure.dart';

abstract class KappaRepository<Entity, Model> {
  /// Luồng dữ liệu Cache-First: Local -> Remote -> Save -> UI (via Stream)
  Stream<Result<Entity>> watchAndSync({
    required Future<Result<Model>> Function() remoteSource,
    required Stream<Entity?> Function() localSource,
    required Future<void> Function(Model model) saveToLocal,
  }) async* {
    // 1. Phát ra dữ liệu hiện có từ Local DB ngay lập tức
    yield* localSource().map((entity) {
      if (entity != null) return Success(entity);
      return const Error(ServerFailure('Đang tải dữ liệu...', code: 'LOADING'));
    });

    // 2. Chạy ngầm việc lấy dữ liệu từ Remote
    final remoteResult = await remoteSource();

    if (remoteResult is Success<Model>) {
      // 3. Lưu vào Local DB (Isar sẽ tự động phát tín hiệu qua stream ở bước 1)
      await saveToLocal(remoteResult.data);
    } else if (remoteResult is Error<Model>) {
      yield Error(remoteResult.failure);
    }
  }

  /// Tương tự cho danh sách
  Stream<Result<List<Entity>>> watchAndSyncList({
    required Future<Result<List<Model>>> Function() remoteSource,
    required Stream<List<Entity>> Function() localSource,
    required Future<void> Function(List<Model> models) saveToLocal,
  }) async* {
    yield* localSource().map((entities) => Success(entities));

    final remoteResult = await remoteSource();
    if (remoteResult is Success<List<Model>>) {
      await saveToLocal(remoteResult.data);
    } else if (remoteResult is Error<List<Model>>) {
      yield Error(remoteResult.failure);
    }
  }
}
