import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'ANDROID_GEOLOCATION_KEY', obfuscate: true)
  static final androidGeolotaionkey = _Env.androidGeolotaionkey;
  @EnviedField(varName: 'AWS_ACCESS_KEY_ID', obfuscate: true)
  static final awsAccessKeyId = _Env.awsAccessKeyId;
  @EnviedField(varName: 'AWS_SECRET_KEY_ID', obfuscate: true)
  static final awsSecretKeyId = _Env.awsSecretKeyId;
  @EnviedField(varName: 'AWS_POOL_ID', obfuscate: true)
  static final awsPoolId = _Env.awsPoolId;
  @EnviedField(varName: 'AWS_APP_CLIENT_ID', obfuscate: true)
  static final awsAppClientId = _Env.awsAppClientId;
  @EnviedField(varName: 'AWS_WEB_DOMAIN', obfuscate: true)
  static final awsWebDomain = _Env.awsWebDomain;
  @EnviedField(varName: 'AWS_API_GW', obfuscate: true)
  static final awsApiGw = _Env.awsApiGw;
}
