import 'package:flutter_bloc/flutter_bloc.dart';
import 'kappa_state.dart';

/// Lớp cơ sở cho Logic nghiệp vụ sử dụng Cubit (thuộc flutter_bloc)
/// Giúp việc phát ra các trạng thái (emit) trở nên đơn giản và trực quan.
abstract class KappaBloc<T> extends Cubit<KappaState<T>> {
  KappaBloc(KappaState<dynamic> kappaState)
    : super(const KappaState(status: KappaStatus.initial));

  @override
  void onChange(Change<KappaState<T>> change) {
    super.onChange(change);
    // Có thể thêm logging ở đây nếu KappaEngine.config.enableLogging == true
  }
}
