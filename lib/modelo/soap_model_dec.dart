// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapModelDec> soapModelFromJson(String str) => List<SoapModelDec>.from(
    json.decode(str).map((x) => SoapModelDec.fromJson(x)));

String soapModelToJson(List<SoapModelDec> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelDec {
  SoapModelDec({
    this.crrcion,
    this.fcharcbolte,
    this.nmbrebnco,
    this.nmroprimprso,
    this.prdolqdcion,
    this.vgncia,
  });

  String? crrcion, fcharcbolte, nmbrebnco, nmroprimprso, prdolqdcion, vgncia;

  factory SoapModelDec.fromJson(Map<String, dynamic> json) => SoapModelDec(
        crrcion: json["crrcion"],
        fcharcbolte: json["fcha_rcbo_lte"],
        nmbrebnco: json["nmbre_bnco"],
        nmroprimprso: json["nmro_primprso"],
        prdolqdcion: json["prdo_lqdcion"],
        vgncia: json["vgncia"],
      );

  Map<String, dynamic> toJson() => {
        "crrcion": crrcion,
        "fcha_rcbo_lte": fcharcbolte,
        "nmbre_bnco": nmbrebnco,
        "nmro_primprso": nmroprimprso,
        "prdo_lqdcion": prdolqdcion,
        "vgncia": vgncia,
      };
}
