import 'package:permission_handler/permission_handler.dart';

class ApiPermisos {
  static Future<bool> requestWritePermission() async {
    bool allowWriteFile = false;

    try {
      if (await Permission.storage.request().isGranted) {
        allowWriteFile = true;
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        allowWriteFile = true;
      } else if (await Permission.storage.isPermanentlyDenied ||
          await Permission.manageExternalStorage.isPermanentlyDenied) {
        print(
          "Permiso denegado permanentemente. Abre la configuración para activarlo.",
        );
        openAppSettings();
      } else {
        print("Permiso denegado por el usuario.");
      }
    } catch (e) {
      print("Error al solicitar permiso: $e");
    }

    return allowWriteFile;
  }
}
