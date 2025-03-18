// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapModelMarca> soapModelFromJson(String str) => List<SoapModelMarca>.from(
    json.decode(str).map((x) => SoapModelMarca.fromJson(x)));

String soapModelToJson(List<SoapModelMarca> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelMarca {
  SoapModelMarca({this.marca});
  String? marca;

  factory SoapModelMarca.fromJson(Map<String, dynamic> json) => SoapModelMarca(
        marca: json["marca"],
      );

  Map<String, dynamic> toJson() => {
        "marca": marca,
      };
}
