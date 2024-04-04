import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poc_storage/captalize_string_extension.dart';

enum ExtPublicDir {
  music,
  podCasts,
  ringtones,
  alarms,
  notifications,
  pictures,
  movies,
  download,
  dCIM,
  documents,
  screenshots,
  audiobooks,
}

class ExtStorage {
  //External Storage Directory
  static Future<String> _directoryPathESD({bool useSDCard = true}) async {
    Directory? directory;
    if (useSDCard) {
      List<Directory>? directories = await getExternalStorageDirectories();

      if (directories != null && directories.length > 1) {
        final String sdCardDirectoryPath = directories.last.path;
        log('sdCardDirectoryPath: $sdCardDirectoryPath');
        directory = Directory(sdCardDirectoryPath);
      }
    } else {
      directory = await getExternalStorageDirectory();
    }
    if (directory != null) {
      return directory.path;
    }
    log('Erro: Não foi possível obter External Storage Directory');
    return '';
  }

  static Future<String> createFolderInPublicDir({
    ExtPublicDir type = ExtPublicDir.download,
    bool useSDCard = true,
    required String folderName,
  }) async {
    var appDocDir = await _directoryPathESD(useSDCard: useSDCard);

    if (appDocDir.isEmpty) return '';

    log("createFolderInPublicDir:_appDocDir:${appDocDir.toString()}");

    var values = appDocDir.split(Platform.pathSeparator);

    var dim = values.length - 4; // Android/Data/package.name/files
    appDocDir = "";

    for (var i = 0; i < dim; i++) {
      appDocDir += values[i];
      appDocDir += Platform.pathSeparator;
    }
    appDocDir +=
        "${type.toString().split('.').last.capitalize()}${Platform.pathSeparator}";
    appDocDir += folderName;

    log("_appDocDir:$appDocDir");

    if (await Directory(appDocDir).exists()) {
      log("Directory: [$appDocDir] already exist");

      return appDocDir;
    } else {
      final appDocDirNewFolder =
          await Directory(appDocDir).create(recursive: true);
      final String pathNorma = normalize(appDocDirNewFolder.path);
      log("createFolderInPublicDir:ToCreate:pathNorma:$pathNorma");

      return pathNorma;
    }
  }
}
