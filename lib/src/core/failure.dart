abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure(this.message, {this.code, this.originalError});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.originalError});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message) : super(code: 'NETWORK_ERROR');
}

class AuthFailure extends Failure {
  const AuthFailure(super.message) : super(code: 'UNAUTHORIZED');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message) : super(code: 'VALIDATION_ERROR');
}
