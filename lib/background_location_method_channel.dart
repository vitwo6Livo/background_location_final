import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'background_location_platform_interface.dart';

/// An implementation of [BackgroundLocationPlatform] that uses method channels.
class MethodChannelBackgroundLocation extends BackgroundLocationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('background_location');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
