import 'package:encrypt/encrypt.dart';

// Interface para a estratégia de criptografia
abstract class EstrategiaCriptografica {
  String criptografar(String conteudo);
  String descriptografar(String conteudoCriptografado);
}

// Implementação concreta da interface usando AES
class AESCriptografia implements EstrategiaCriptografica {
  late final IV _iv;
  late final Key _chave;

  AESCriptografia(String chave)
      : _iv = IV.fromLength(16),
        _chave = Key.fromUtf8(chave);

  @override
  String criptografar(String conteudo) {
    final encrypter = Encrypter(AES(_chave));
    final encrypted = encrypter.encrypt(conteudo, iv: _iv);
    return "${_iv.base64}:${encrypted.base64}";
  }

  @override
  String descriptografar(String conteudoCriptografado) {
    final partes = conteudoCriptografado.split(":");
    final iv = IV.fromBase64(partes[0]);
    final encrypted = Encrypted.fromBase64(partes[1]);
    final encrypter = Encrypter(AES(_chave));
    return encrypter.decrypt(encrypted, iv: iv);
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
