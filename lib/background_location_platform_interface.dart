import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'background_location_method_channel.dart';

abstract class BackgroundLocationPlatform extends PlatformInterface {
  /// Constructs a BackgroundLocationPlatform.
  BackgroundLocationPlatform() : super(token: _token);

  static final Object _token = Object();

  static BackgroundLocationPlatform _instance = MethodChannelBackgroundLocation();

  /// The default instance of [BackgroundLocationPlatform] to use.
  ///
  /// Defaults to [MethodChannelBackgroundLocation].
  static BackgroundLocationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BackgroundLocationPlatform] when
  /// they register themselves.
  static set instance(BackgroundLocationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
