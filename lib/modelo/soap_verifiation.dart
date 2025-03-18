// To parse this JSON data, do
//
//     final soapModelVeri = soapModelVeriFromJson(jsonString);

import 'dart:convert';

List<SoapModelo> soapModelVeriFromJson(String str) =>
    List<SoapModelo>.from(json.decode(str).map((x) => SoapModelo.fromJson(x)));

String soapModelVeriToJson(List<SoapModelo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelo {
  String? modelo;
  // String toString() => modelo;
  SoapModelo({this.modelo});

  factory SoapModelo.fromJson(Map<String, dynamic> json) => SoapModelo(
        modelo: json["modelo"],
      );

  Map<String, dynamic> toJson() => {
        "modelo": modelo,
      };
}
