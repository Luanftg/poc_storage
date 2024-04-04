import 'package:encrypt/encrypt.dart';

// Interface para a estratégia de criptografia
abstract class EstrategiaCriptografica {
  String criptografar(String conteudo);
  String descriptografar(String conteudoCriptografado);
}

// Implementação concreta da interface usando AES
class AESCriptografia implements EstrategiaCriptografica {
  final Key _chave;
  final IV _iv;
  final Encrypter _encrypter;

  AESCriptografia(String chave)
      : _chave = Key.fromUtf8(chave),
        _iv = IV.fromLength(16),
        _encrypter = Encrypter(AES(Key.fromUtf8(chave)));

  @override
  String criptografar(String conteudo) {
    final encrypted = _encrypter.encrypt(conteudo, iv: _iv);
    return encrypted.base64;
  }

  @override
  String descriptografar(String conteudoCriptografado) {
    final encrypted = Encrypted.fromBase64(conteudoCriptografado);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

// Classe que utiliza a estratégia de criptografia
class Criptografia {
  final EstrategiaCriptografica _estrategia;

  Criptografia(this._estrategia);

  String criptografar(String conteudo) {
    return _estrategia.criptografar(conteudo);
  }

  String descriptografar(String conteudoCriptografado) {
    return _estrategia.descriptografar(conteudoCriptografado);
  }
}
