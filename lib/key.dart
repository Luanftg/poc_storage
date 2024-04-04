import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Constants {
  static String get dotEnvCriptoKey => 'CHAVE_CRIPTOGRAFIA';
  static String get criptoKey => dotenv.get(dotEnvCriptoKey);
}
