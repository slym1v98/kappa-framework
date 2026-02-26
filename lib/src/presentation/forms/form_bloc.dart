import '../bloc/kappa_bloc.dart';
import '../bloc/kappa_state.dart';

abstract class KappaFormBloc<T> extends KappaBloc<T> {
  KappaFormBloc() : super(const KappaState(status: KappaStatus.initial));

  final Map<String, String> _fields = {};
  final Map<String, String?> _errors = {};

  void updateField(
    String name,
    String value, {
    List<String? Function(String?)>? validators,
  }) {
    _fields[name] = value;

    if (validators != null) {
      _errors[name] = null;
      for (var v in validators) {
        final error = v(value);
        if (error != null) {
          _errors[name] = error;
          break;
        }
      }
    }
    _emitCurrentState();
  }

  String? getFieldValue(String name) => _fields[name];
  String? getFieldError(String name) => _errors[name];

  bool get isValid =>
      _errors.values.every((e) => e == null) && _fields.isNotEmpty;

  void _emitCurrentState() {
    emit(
      KappaState(
        status: isValid ? KappaStatus.success : KappaStatus.error,
        data: state.data,
      ),
    );
  }

  Future<void> submit();
}
