// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kappa_framework_method_channel.dart';

abstract class KappaFrameworkPlatform extends PlatformInterface {
  /// Constructs a KappaFrameworkPlatform.
  KappaFrameworkPlatform() : super(token: _token);

  static final Object _token = Object();

  static KappaFrameworkPlatform _instance = MethodChannelKappaFramework();

  /// The default instance of [KappaFrameworkPlatform] to use.
  ///
  /// Defaults to [MethodChannelKappaFramework].
  static KappaFrameworkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KappaFrameworkPlatform] when
  /// they register themselves.
  static set instance(KappaFrameworkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
