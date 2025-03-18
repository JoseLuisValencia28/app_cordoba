// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapModelInfoVig> soapModelFromJson(String str) =>
    List<SoapModelInfoVig>.from(
        json.decode(str).map((x) => SoapModelInfoVig.fromJson(x)));

String soapModelToJson(List<SoapModelInfoVig> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelInfoVig {
  SoapModelInfoVig({
    this.respuesta, // ignore: non_constant_identifier_names
    this.vigencia, // ignore: non_constant_identifier_names
  });

  String? respuesta, // ignore: non_constant_identifier_names
      vigencia; // ignore: non_constant_identifier_names

  factory SoapModelInfoVig.fromJson(Map<String, dynamic> json) =>
      SoapModelInfoVig(
        respuesta: json["respuesta"],
        vigencia: json["vigencia"],
      );

  Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
        "vigencia": vigencia,
      };
}
