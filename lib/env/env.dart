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
}
