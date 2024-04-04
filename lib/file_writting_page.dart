import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poc_storage/criptografia.dart';
import 'package:poc_storage/external_storage.dart';
import 'package:poc_storage/key.dart';

class FileWritingPage extends StatefulWidget {
  const FileWritingPage({super.key});

  @override
  State<FileWritingPage> createState() => _FileWritingPageState();
}

class _FileWritingPageState extends State<FileWritingPage> {
  String filePath = '';
  String conteudoDescriptografado = '';
  
  late final AESCriptografia estrategia;
  late final Criptografia criptografia;

  @override
  void initState() {
    estrategia = AESCriptografia(Constants.criptoKey);
    criptografia = Criptografia(estrategia);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Writing Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              filePath,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String result = await _createFile(context);
                filePath = 'Arquivo salvo em: $result';
                setState(() {});
              },
              child: const Text('Write to File - Crypted'),
            ),
            const SizedBox(height: 20),
            (filePath.isNotEmpty)
                ? ElevatedButton(
                    onPressed: () async {
                      final String caminhoArquivo =
                          filePath.replaceAll('Arquivo salvo em: ', '');
                      final conteudoCriptografado =
                          await File(caminhoArquivo).readAsString();
                      conteudoDescriptografado =
                          criptografia.descriptografar(conteudoCriptografado);
                      setState(() {});
                    },
                    child: const Text('Show content - Descrypted'),
                  )
                : const Offstage(),
            const SizedBox(height: 20),
            Text(
              conteudoDescriptografado,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _createFile(BuildContext context) async {
    try {
      Map<String, dynamic> json = {
        "id": 1,
        "nome": "PacItens",
        "isValid": false,
        "price": 10.50
      };
      String textToWrite = jsonEncode(json);
      String fileName = 'registro_Pac.text';
      const String folderName = 'EasyPac';

      textToWrite = criptografia.criptografar(textToWrite);

      final String directoryPath = await ExtStorage.createFolderInPublicDir(
        folderName: folderName,
      );

      late Directory directory;

      log('directoryPath: $directoryPath');
      directory = Directory(directoryPath);
      String filePath = '${directory.path}/$fileName';
      log('filePath: $filePath');
      File file = File(filePath);
      await file.writeAsString(textToWrite);
      log('Arquivo $fileName salvo em: ${directory.path}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Arquivo $fileName salvo em: ${directory.path}'),
        ),
      );

      return filePath;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to write file: $e'),
        ),
      );
      return '';
    }
  }
}
