import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'ANDROID_GEOLOCATION_KEY', obfuscate: true)
  static final androidGeolotaionkey = _Env.androidGeolotaionkey;
}
