import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poc_storage/external_storage.dart';
import 'package:poc_storage/file_controller.dart';
import 'package:poc_storage/key.dart';

class FileWritingPage extends StatefulWidget {
  const FileWritingPage({super.key});

  @override
  State<FileWritingPage> createState() => _FileWritingPageState();
}

class _FileWritingPageState extends State<FileWritingPage> {
  late final String criptoKey;
  late final Map<String, dynamic> json;
  late final String fileName;
  late final FileController _fileController;

  String filePath = '';
  String conteudoDescriptografado = '';

  @override
  void initState() {
    criptoKey = dotenv.get(Constants.dotEnvCriptoKey);
    fileName = 'novo_arquivo_cripto_ecb.txt';
    json = {"id": 3, "nome": "Pac Item 3", "isValid": true, "price": 13.0};
    _fileController = FileController(criptoKey: criptoKey);
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
              onPressed: () => _onWriteFile(),
              child: const Text('Write to File - Crypted'),
            ),
            const SizedBox(height: 20),
            Text(
              conteudoDescriptografado,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onOpenFile(),
              child: const Text('Open File'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onDeleteFile(),
              child: const Text('Delete File'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onWriteFile() async {
    try {
      final String result = await _fileController.createFileFromJson(
        json: json,
        fileName: fileName,

      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sucessfully Created File!\n $result'),
        ),
      );

      filePath = 'Arquivo salvo em: $result';
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to write file!\n ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> _onOpenFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        final conteudoCriptografado = await file.readAsString();
        conteudoDescriptografado =
            _fileController.criptografia.descriptografar(conteudoCriptografado);
        setState(() {});
      } else {
        log('User canceled the picker');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Show file!\n ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> _onDeleteFile() async {
    try {
      var statusExternalStorage =
          await Permission.manageExternalStorage.request();

      if (filePath.isNotEmpty) {
        final path = filePath.replaceAll('Arquivo salvo em: ', '');
        final path3 = path.split('.');
        final first = path3.first;
        final ext = path3.last;
        final result = '${first}_3';
        File file = File('$result.$ext');
        file.deleteSync();
        setState(() {
          conteudoDescriptografado =
              'Arquivo: ${file.path} deletado com sucesso!';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Delete file!\n ${e.toString()}'),
        ),
      );
    }
  }
}
