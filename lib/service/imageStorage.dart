import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageStorage {
Future<String?> saveUserImage(String userId, Uint8List imageBytes, String fileName) async {
  final userImageDirectory = await getUserImageDirectory(userId);
  final filePath = path.join(userImageDirectory!, fileName);

  try {
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return filePath;
  } catch (e) {
    print('Erro ao salvar a imagem: $e');
    return null;
  }
}

    Future<String?> getUserImageDirectory(String userId) async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final userDirectory = path.join(appDocumentDirectory.path, userId);

    // Verifique se o diretório do usuário já existe, caso contrário, crie-o.
    final userDir = Directory(userDirectory);
    if (!userDir.existsSync()) {
      userDir.createSync(recursive: true);
    }

    return userDirectory;
  }
}



