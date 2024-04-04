import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

enum extPublicDir {
  Music,
  PodCasts,
  Ringtones,
  Alarms,
  Notifications,
  Pictures,
  Movies,
  Download,
  DCIM,
  Documents,
  Screenshots,
  Audiobooks,
}

class ExtStorage {
  static Future<String> get _directoryPathESD async {
    List<Directory>? directories = await getExternalStorageDirectories();
    late Directory? directory;

    if (directories != null && directories.length > 1) {
      final String sdCardDirectoryPath = directories.last.path;
      log('sdCardDirectoryPath: $sdCardDirectoryPath');
      directory = Directory(sdCardDirectoryPath);
    } else {
      directory = await getExternalStorageDirectory();
    }
    if (directory != null) {
      return directory.path;
    }
    log('_directoryPathESD==null');
    return '';
  }

  static Future<String> createFolderInPublicDir({
    extPublicDir type = extPublicDir.Download,
    required String folderName,
  }) async {
    var appDocDir = await _directoryPathESD;

    log("createFolderInPublicDir:_appDocDir:${appDocDir.toString()}");

    var values = appDocDir.split(Platform.pathSeparator);

    var dim = values.length - 4; // Android/Data/package.name/files
    appDocDir = "";

    for (var i = 0; i < dim; i++) {
      appDocDir += values[i];
      appDocDir += Platform.pathSeparator;
    }
    appDocDir += "${type.toString().split('.').last}${Platform.pathSeparator}";
    appDocDir += folderName;

    log("_appDocDir:$appDocDir");

    if (await Directory(appDocDir).exists()) {
      log(
        "Directory: [$appDocDir] already exist",
      );

      return appDocDir;
    } else {
      final appDocDirNewFolder =
          await Directory(appDocDir).create(recursive: true);
      final pathNorma = Path.normalize(appDocDirNewFolder.path);
      log("createFolderInPublicDir:ToCreate:pathNorma:$pathNorma");

      return pathNorma;
    }
  }
}
