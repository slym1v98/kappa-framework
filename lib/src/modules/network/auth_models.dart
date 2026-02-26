import '../../core/result.dart';

class KappaToken {
  final String accessToken;
  final String refreshToken;

  KappaToken({required this.accessToken, required this.refreshToken});
}

abstract class KappaAuthDelegate {
  Future<Result<KappaToken>> onRefreshToken(String expiredToken);
  Future<void> onUnauthenticated();
}
