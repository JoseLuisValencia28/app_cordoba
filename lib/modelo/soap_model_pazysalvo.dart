import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_cordoba/api/certificate.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:http/http.dart' as http;

class Pin {
  int? pin;
  int? grdo;
  Pin({this.grdo, this.pin});
  Map<String, dynamic> toMap() {
    return {'pin': pin, 'grdo': grdo};
  }

  factory Pin.fromMap(Map<String, dynamic> map) {
    return Pin(pin: map['pin'], grdo: map['grdo']);
  }

  String toJson() => json.encode(toMap());

  factory Pin.fromJson(String source) => Pin.fromMap(json.decode(source));
}

class PazySalvoREST {
  int? existe;
  String? estado;
  int? reimprimir;
  String? nombre;
  String? identificacion;
  String? correo;
  String? telefono;
  int? vigencias;
  String? pslctdexstnte; //p_slctd_exstnte

  PazySalvoREST({
    this.correo,
    this.estado,
    this.existe,
    this.identificacion,
    this.nombre,
    this.pslctdexstnte,
    this.reimprimir,
    this.telefono,
    this.vigencias,
  });

  Map<String, dynamic> toMap() {
    return {
      'existe': existe,
      'estado': estado,
      'reimprimir': reimprimir,
      'identificacion': identificacion,
      'correo': correo,
      'telefono': telefono,
      'vigencias': vigencias,
      'p_slctd_exstnte': pslctdexstnte,
    };
  }

  factory PazySalvoREST.fromMap(Map<String, dynamic> map) {
    return PazySalvoREST(
      existe: map['existe'],
      estado: map['estado'],
      reimprimir: map['reimprimir'],
      identificacion: map['identificacion'],
      correo: map['correo'],
      telefono: map['telefono'],
      vigencias: map['vigencias'],
      pslctdexstnte: map['p_slctd_exstnte'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PazySalvoREST.fromJson(String source) =>
      PazySalvoREST.fromMap(json.decode(source));

  Future<PazySalvoREST> postValidaSolicitud(placa) async {
    HttpOverrides.global = MyHttpOverrides();
    final uri = Uri.parse('$urlvalidarplaca');
    PazySalvoREST result = PazySalvoREST();

    var jsonEncoder = jsonEncode({"placa": placa});
    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncoder,
      );

      if (response.statusCode == 200 && response.body != "") {
        print(response.body);
        var resutl64 = json.decode(response.body);
        String jsonObj = json.encode(resutl64["datos"][0]);

        result = PazySalvoREST.fromJson(jsonObj);

        //result = PazySalvoREST.fromJson(resutl64["datos"]);
      }
    } on TimeoutException catch (_) {
      result = PazySalvoREST();
    } on SocketException catch (_) {
      result = PazySalvoREST();
    }
    return result;
  }

  Future<Pin> postRegistrarSolicitud({
    String? placa,
    String? nombrepropietario,
    String? mimeType,
    Uint8List? bytearchivo,
    String? identificacion,
    String? telefono,
    String? correo,
    String? nombreArchivo,
  }) async {
    final uri = Uri.parse('$urlPazYsalvo');

    var jsonEncoder = jsonEncode({
      "placa": placa,
      "accion": "registraSolicitud",
      "nombre": nombrepropietario,
      "mimeType": mimeType,
      "byte": base64Encode(bytearchivo!),
      "identificacion": identificacion,
      "telefono": telefono,
      "correo": correo?.replaceAll(" ", ""),
      "nombreArchivo": nombreArchivo,
    });
    Pin respon = Pin();
    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncoder,
      );

      if (response.statusCode == 200 && response.body != "") {
        Map result = json.decode(response.body);
        respon = Pin.fromMap(result['datos'][0]);
      }
    } on TimeoutException catch (_) {
      respon = Pin();
    } on SocketException catch (_) {
      respon = Pin();
    }
    return respon;
  }

  Future<Map> postConsultarPing({String? pin}) async {
    final uri = Uri.parse('$urlPazYsalvo');
    Map result = {};

    var jsonEncoder = jsonEncode({"pin": pin, "accion": "consultaPin"});

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncoder,
      );

      if (response.statusCode == 200 && response.body != "") {
        result = json.decode(response.body);
        //respon = Ping.fromMap(result['datos'][0]);
      }
    } on TimeoutException catch (_) {
      result = {"timeout": "error de respuesta"};
    } on SocketException catch (_) {
      result = {};
    }
    return result;
  }

  Future<String> postCancelarSolicitud({
    List<String>? pin,
    List<String>? placa,
  }) async {
    final uri = Uri.parse('$urlPazYsalvo');
    var result = "";

    var jsonEncoder = jsonEncode({
      "pin": pin,
      "accion": "actualizaEstado",
      "placa": placa,
      "estado": 4,
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncoder,
      );

      if (response.statusCode == 200 && response.body != "") {
        String valor = response.body.replaceAll("\n", "").toString();
        result = valor;

        print(result);
        //respon = Ping.fromMap(result['datos'][0]);
      }
    } on TimeoutException catch (_) {
      result = "Sin conexión";
    } on SocketException catch (_) {
      result = "Exception";
    }
    return result;
  }

  Future<String> postdescargarpazysalvo({String? pin}) async {
    final uri = Uri.parse('$urlPazYsalvo');
    String result = "";

    var jsonEncoder = jsonEncode({"pin": pin, "accion": "nombreEstampilla"});

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncoder,
      );

      if (response.statusCode == 200 && response.body != "") {
        result = response.body;
      }
    } on TimeoutException catch (_) {
      result = "";
    } on SocketException catch (_) {
      result = "";
    }
    return result;
  }

  decodebase64({String? base64set}) {
    //final dataTitle64 = base64.decode(base64set);
    String decoded = utf8.decode(
      base64.decode(base64set.toString()),
      allowMalformed: true,
    );
    //PazySalvoREST result = PazySalvoREST.fromJson(decoded);
    return decoded;
  }
}
