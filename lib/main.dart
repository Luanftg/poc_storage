import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poc_storage/external_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FileWritingPage(),
    );
  }
}

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
            Center(child: Text(filePath)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // _writeToFile(context);
                // saveFile(context);
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
      String fileName = 'registro_Pac_1.text';
      const String folderName = 'EasyPac';

      final String directoryPath = await ExtStorage.createFolderInPublicDir(
        folderName: folderName,
        type: extPublicDir.EasyPac,
      );

      late Directory directory;

      log('directoryPath: $directoryPath');
      directory = Directory(directoryPath);
      if (await directory.exists()) {
        var files = directory.listSync();
        final bool isFileNameAlreadyInDirectory =
            files.where((element) => element.path == fileName).isNotEmpty;
        if (isFileNameAlreadyInDirectory) {
          var tiles = fileName.split('-');
          if (tiles.length > 1) {
            int number = int.tryParse(tiles.last) ?? 0;
          }
          fileName = '$fileName - 1';
        }
      }
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

  Future<void> _writeToFile(BuildContext context) async {
    try {
      String textToWrite = 'Hello, World!';
      Directory? directory;

      if (Platform.isAndroid && !Platform.isIOS) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        log('EXTERNAL STORAGE PATH: ${directory.path}');
        Directory directorySSD = await getApplicationSupportDirectory();
        log(' SD Card DIRECTORY PATH:${directorySSD.path}');
        // Define o caminho do arquivo
        String filePath = '${directory.path}/my_file.txt';
        String ssdFilePath = '${directorySSD.path}/my_file.txt';

        // Cria o arquivo e escreve o texto nele
        File file = File(filePath);
        File ssDFile = File(ssdFilePath);
        await file.writeAsString(textToWrite);
        await ssDFile.writeAsString(textToWrite);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File written successfully!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to write file: $e'),
        ),
      );
    }
  }

  Future<String> _getAppExternalStorageDirectory() async {
    Directory? appDir = await getExternalStorageDirectory();
    Directory? appDir2 = await getApplicationCacheDirectory();
    Directory? appDir3 = await getApplicationDocumentsDirectory();
    // Directory? appDir4 = await getLibraryDirectory();
    Directory? appDir5 = await getDownloadsDirectory();
    List<Directory>? appDir6 = await getExternalCacheDirectories();
    List<Directory>? appDir7 = await getExternalStorageDirectories();
    log('getExternalStorageDirectory: ${appDir?.absolute}');
    log('getApplicationCacheDirectory: ${appDir2.absolute}');
    log('getApplicationDocumentsDirectory: ${appDir3.absolute}');
    // log('getLibraryDirectory: ${appDir4.absolute}');
    log('getDownloadsDirectory: ${appDir5?.absolute}');

    appDir6?.forEach((element) {
      log('getExternalCacheDirectories: ${element.absolute}');
    });
    appDir7?.forEach((element) {
      log('getExternalStorageDirectories: ${element.absolute}');
    });

    // return appDir7?.last.path ?? '';

    if (appDir != null) {
      String appStorageDir = '${appDir.path}/poc_storage';
      Directory(appStorageDir).createSync(recursive: true);
      return appStorageDir;
    }
    return '';
  }

  void saveFile(BuildContext context) async {
    try {
      String appDir = await _getAppExternalStorageDirectory();
      File file = File('$appDir/meu_arquivo.txt');
      await file.writeAsString('Conteúdo do arquivo');
      print('Arquivo salvo em: ${file.path}');
      Directory? appDir3 = await getApplicationDocumentsDirectory();
      File fileAppDir3 = File('${appDir3.path}/meu_arquivo.txt');
      await fileAppDir3.writeAsString('Conteúdo do arquivo');
      print('Arquivo salvo em: ${fileAppDir3.path}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File written successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to write file: $e'),
        ),
      );
    }
  }
}
