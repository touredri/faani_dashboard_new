import  'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env{
  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _Env.apiKey;
  @EnviedField(varName: 'APP_ID')
  static const String appId = _Env.appId;
  @EnviedField(varName: 'MESSAGING_SENDER_ID')
  static const String messagingSenderId = _Env.messagingSenderId;
  @EnviedField(varName: 'PROJECT_ID')
  static const String projectId = _Env.projectId;
  @EnviedField(varName: 'AUTH_DOMAIN')
  static const String authDomain = _Env.authDomain;
  @EnviedField(varName: 'STORAGE_BUCKET')
  static const String storageBucket = _Env.storageBucket;
  @EnviedField(varName: 'ADMIN_EMAIL')
  static const String adminEmail = _Env.adminEmail;
  @EnviedField(varName: 'ADMIN_PASSWORD')
  static const String adminPassword = _Env.adminPassword;
}

// run this after config
// flutter pub run build_runner build --delete-conflicting-outputs
