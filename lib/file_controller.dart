import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:poc_storage/criptografia.dart';
import 'package:poc_storage/external_storage.dart';

class FileController {
  final String criptoKey;
  late final AESCriptografia estrategia = AESCriptografia(criptoKey);
  late final Criptografia criptografia = Criptografia(estrategia);

  FileController({required this.criptoKey});

  Future<String> createFileFromJson({
    required Map<String, dynamic> json,
    String? fileName,
    String? folderName,
    bool useSDCard = true,
    ExtPublicDir type = ExtPublicDir.download,
  }) async {
    try {
      // String textToWrite = jsonEncode(json);
      String textToWrite = jsonEncode(json);
      var bytes;

      String internalFileName = fileName ?? 'registro_Pac.text';
      String internalFolderName = folderName ?? 'EasyPac';

      textToWrite = criptografia.criptografar(textToWrite);

      final String directoryPath = await ExtStorage.createFolderInPublicDir(
        folderName: internalFolderName,
        useSDCard: useSDCard,
        type: type,
      );

      if (directoryPath.isEmpty) {
        throw Exception('Não foi possível criar um diretório público');
      }

      final Directory directory = Directory(directoryPath);

      String filePath = '${directory.path}/$internalFileName';

      File file = File(filePath);
      await file.writeAsString(textToWrite);
      log('Arquivo: $internalFileName\nSalvo em: ${directory.path}');

      return filePath;
    } catch (e) {
      rethrow;
    }
  }
}
