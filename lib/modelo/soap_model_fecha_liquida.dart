// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapFechaLiquida> soapModelFromJson(String str) =>
    List<SoapFechaLiquida>.from(
        json.decode(str).map((x) => SoapFechaLiquida.fromJson(x)));

String soapModelToJson(List<SoapFechaLiquida> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapFechaLiquida {
  // ignore: non_constant_identifier_names
  SoapFechaLiquida({this.p_fcha_lmte, this.result});
  // ignore: non_constant_identifier_names
  String? p_fcha_lmte, result;

  factory SoapFechaLiquida.fromJson(Map<String, dynamic> json) =>
      SoapFechaLiquida(
        p_fcha_lmte: json["p_fcha_lmte"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "p_fcha_lmte": p_fcha_lmte,
        "result": result,
      };
}
