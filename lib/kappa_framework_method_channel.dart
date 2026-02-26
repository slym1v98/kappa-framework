import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kappa_framework_platform_interface.dart';

/// An implementation of [KappaFrameworkPlatform] that uses method channels.
class MethodChannelKappaFramework extends KappaFrameworkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kappa_framework');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
