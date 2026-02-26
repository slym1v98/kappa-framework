class KappaValidator {
  static String? Function(String?) required(String message) =>
      (v) => v == null || v.isEmpty ? message : null;

  static String? Function(String?) email(String message) =>
      (v) =>
          v != null && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)
          ? message
          : null;

  static String? Function(String?) minLength(int length, String message) =>
      (v) => v != null && v.length < length ? message : null;

  static String? Function(String?) pattern(RegExp regExp, String message) =>
      (v) => v != null && !regExp.hasMatch(v) ? message : null;
}
