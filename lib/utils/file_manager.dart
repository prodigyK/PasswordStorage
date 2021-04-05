import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:password_storage_app/models/user.dart';

class FileManager {
  FileManager._();

  static Future<List<User>> openFileExplorer() async {
    List<User> users = [];
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);

      if (result != null) {
        File file = File(result.files.first.path);
        print(file.absolute);
        users = _loadLoginsFromList(await file.readAsLines());
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    return users;
  }

  static List<User> _loadLoginsFromList(List<String> futureList) {
    List<User> users = [];
    for (String line in futureList) {
      if (line.trim().length == 0) {
        continue;
      }
      List<String> data = line.trim().split(":");
      String name = data.first;
      String pass = data[1];

      users.add(User(
        name: name,
        password: pass,
        description: '',
        dateTime: DateTime.now(),
      ));
    }
    return users;
  }
}
