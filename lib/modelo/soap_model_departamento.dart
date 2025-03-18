// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapMoedelDepartamento> soapModelFromJson(String str) =>
    List<SoapMoedelDepartamento>.from(
        json.decode(str).map((x) => SoapMoedelDepartamento.fromJson(x)));

String soapModelToJson(List<SoapMoedelDepartamento> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapMoedelDepartamento {
  SoapMoedelDepartamento({
    this.cdgodprtmnto,
    this.nmbre,
    this.position,
  });
  String? cdgodprtmnto, nmbre, position;

  factory SoapMoedelDepartamento.fromJson(Map<String, dynamic> json) =>
      SoapMoedelDepartamento(
        cdgodprtmnto: json["cdgo_dprtmnto"],
        nmbre: json["nmbre"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "cdgo_dprtmnto": cdgodprtmnto,
        "nmbre": nmbre,
        "position": position,
      };
}
