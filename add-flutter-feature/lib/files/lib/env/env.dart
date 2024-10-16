import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/config/.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  // if obfuscate is true, variable must be final (not const)
  static final String apiKey = _Env.apiKey;
}
