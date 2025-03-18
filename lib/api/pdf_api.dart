import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:app_cordoba/api/certificate.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFApi {
  static final Dio dio = Dio();
  static late Directory directory;

  static Future<File?> loadNetwork({String? url, String? filename}) async {
    HttpOverrides.global = MyHttpOverrides();
    Uint8List bytes;

    try {
      final response = await http
          .get(Uri.parse(url.toString()))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        bytes = response.bodyBytes;
        return _storeFile(bytes, filename.toString());
      } else {
        print(
          "Error: No se pudo descargar el archivo. Código ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error en loadNetwork: $e");
    }
    return null;
  }

  static Future<File?> downloadPazYSalvo({
    required String filename,
    required String pin,
  }) async {
    Uri uri = Uri.parse('$urlPazYsalvo');
    String nombreArchivo = "";
    final jsonEncoder = jsonEncode({
      "pin": pin,
      "accion": "descargarPazySalvo",
    });

    try {
      final response = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncoder,
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        nombreArchivo = response.body.trim();

        if (nombreArchivo.isNotEmpty) {
          String url = '$certificadospazysalvo/$nombreArchivo';
          return await loadNetwork(url: url, filename: filename);
        }
      }
    } catch (e) {
      print("Error en downloadPazYSalvo: $e");
    }
    return null;
  }

  static Future<File> _storeFile(Uint8List bytes, String filename) async {
    final String filePath;

    if (Platform.isAndroid) {
      final dir = await getApplicationDocumentsDirectory();
      filePath = '${dir.path}/$filename';
    } else {
      directory = await getApplicationDocumentsDirectory();
      filePath = '${directory.path}/$filename';
    }

    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
