// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapModel> soapModelFromJson(String str) =>
    List<SoapModel>.from(json.decode(str).map((x) => SoapModel.fromJson(x)));

String soapModelToJson(List<SoapModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModel {
  SoapModel({
    this.codEan,
    this.fechaVencimiento,
    this.numeroDocumento,
    this.valorPago,
  });

  int? codEan;
  String? fechaVencimiento;
  String? numeroDocumento;
  String? valorPago;

  factory SoapModel.fromJson(Map<String, dynamic> json) => SoapModel(
        codEan: json["cod_EAN"],
        fechaVencimiento: json["fecha_Vencimiento"],
        numeroDocumento: json["numero_Documento"],
        valorPago: json["valor_Pago"],
      );

  Map<String, dynamic> toJson() => {
        "cod_EAN": codEan,
        "fecha_Vencimiento": fechaVencimiento,
        "numero_Documento": numeroDocumento,
        "valor_Pago": valorPago,
      };
}
