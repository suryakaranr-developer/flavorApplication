import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService _instance = RemoteConfigService._();

  factory RemoteConfigService() => _instance;

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 3),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await _remoteConfig.setDefaults({
      "flavor_heading": "Default Heading",
    });

    await _remoteConfig.fetchAndActivate();
  }

  String get heading => _remoteConfig.getString("flavor_heading");
}