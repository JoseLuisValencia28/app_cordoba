// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapModelMunicipio> soapModelFromJson(String str) =>
    List<SoapModelMunicipio>.from(
        json.decode(str).map((x) => SoapModelMunicipio.fromJson(x)));

String soapModelToJson(List<SoapModelMunicipio> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelMunicipio {
  SoapModelMunicipio({
    this.cdgo_dprtmnto, // ignore: non_constant_identifier_names
    this.cdgo_mncpio, // ignore: non_constant_identifier_names
    this.nmbre_mncpio, // ignore: non_constant_identifier_names
  });
  // String toString() => nmbre_mncpio;
  String? cdgo_dprtmnto, // ignore: non_constant_identifier_names
      // ignore: non_constant_identifier_names
      cdgo_mncpio,
      nmbre_mncpio; // ignore: non_constant_identifier_names

  factory SoapModelMunicipio.fromJson(Map<String, dynamic> json) =>
      SoapModelMunicipio(
        cdgo_dprtmnto: json["cdgo_dprtmnto"],
        cdgo_mncpio: json["cdgo_mncpio"],
        nmbre_mncpio: json["nmbre_mncpio"],
      );

  Map<String, dynamic> toJson() => {
        "cdgo_dprtmnto": cdgo_dprtmnto,
        "cdgo_mncpio": cdgo_mncpio,
        "nmbre_mncpio": nmbre_mncpio,
      };
}
