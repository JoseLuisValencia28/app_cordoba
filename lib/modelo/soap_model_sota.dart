// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapSOAT> soapModelFromJson(String str) =>
    List<SoapSOAT>.from(json.decode(str).map((x) => SoapSOAT.fromJson(x)));

String soapModelToJson(List<SoapSOAT> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapSOAT {
  // ignore: non_constant_identifier_names
  SoapSOAT({this.dgto_vrfccion, this.idntfccion_asgrdra, this.nmbre_asgrdra});
  // String toString() => nmbre_asgrdra;
  // ignore: non_constant_identifier_names
  String? dgto_vrfccion, idntfccion_asgrdra, nmbre_asgrdra;

  factory SoapSOAT.fromJson(Map<String, dynamic> json) => SoapSOAT(
        dgto_vrfccion: json["dgto_vrfccion"],
        idntfccion_asgrdra: json["idntfccion_asgrdra"],
        nmbre_asgrdra: json["nmbre_asgrdra"],
      );

  Map<String, dynamic> toJson() => {
        "dgto_vrfccion": dgto_vrfccion,
        "idntfccion_asgrdra": idntfccion_asgrdra,
        "nmbre_asgrdra": nmbre_asgrdra,
      };
}
