import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poc_storage/external_storage.dart';

class FileWritingPage extends StatefulWidget {
  const FileWritingPage({super.key});

  @override
  State<FileWritingPage> createState() => _FileWritingPageState();
}

class _FileWritingPageState extends State<FileWritingPage> {
  String filePath = '';

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
              child: const Text('Write to File'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _createFile(BuildContext context) async {
    try {
      String textToWrite = 'Item PAC';
      String fileName = 'registro_Pac.text';
      const String folderName = 'EasyPac';

      final String directoryPath = await ExtStorage.createFolderInPublicDir(
        folderName: folderName,
      );

      late Directory directory;

      log('directoryPath: $directoryPath');
      directory = Directory(directoryPath);
      // if (await directory.exists()) {
      //   var files = directory.listSync();
      //   final bool isFileNameAlreadyInDirectory = files
      //       .where((element) => element.path.split('/').last == fileName)
      //       .isNotEmpty;
      //   if (isFileNameAlreadyInDirectory) {
      //     final fileNameTiles = fileName.split('.');
      //     final fileNameWithoutExtensionType = fileNameTiles.first;
      //     final extensionType = fileNameTiles.last;
      //     var tiles = fileNameTiles.first.split('_');
      //     if (tiles.length > 1) {
      //       int? num = int.tryParse(tiles.last);
      //       if (num != null) {
      //         int newNumber = num++;
      //         fileName =
      //             '${fileNameWithoutExtensionType}_$newNumber.$extensionType';
      //       } else {
      //         fileName = '${fileName}_1.$extensionType';
      //       }
      //     }
      //   }
      // }
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
