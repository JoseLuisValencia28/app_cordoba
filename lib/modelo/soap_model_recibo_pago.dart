import 'dart:convert';

List<SoapModelRecibo> soapModelFromJson(String str) =>
    List<SoapModelRecibo>.from(
        json.decode(str).map((x) => SoapModelRecibo.fromJson(x)));

String soapModelToJson(List<SoapModelRecibo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelRecibo {
  // ignore: non_constant_identifier_names
  SoapModelRecibo(
      {this.capital,
      this.estadoFactura,
      this.interes,
      this.numeroFactura,
      this.periodoFraccion,
      this.periodoLiquida,
      this.total,
      this.vigencia});

  String? capital,
      estadoFactura,
      interes,
      numeroFactura,
      periodoFraccion,
      periodoLiquida,
      total,
      vigencia;

  factory SoapModelRecibo.fromJson(Map<String, dynamic> json) =>
      SoapModelRecibo(
        capital: json["CAPITAL"],
        estadoFactura: json["ESTDO_FCTRA"],
        interes: json["INTERES"],
        numeroFactura: json["NMRO_FCTRA"],
        periodoFraccion: json["PRDO_FCTRCION"],
        periodoLiquida: json["PRDO_LQDCION"],
        total: json["TOTAL"],
        vigencia: json["VGNCIA"],
      );
  Map<String, dynamic> toJson() => {
        "CAPITAL": capital,
        "ESTDO_FCTRA": estadoFactura,
        "INTERES": interes,
        "NMRO_FCTRA": numeroFactura,
        "PRDO_FCTRCION": periodoFraccion,
        "PRDO_LQDCION": periodoLiquida,
        "TOTAL": total,
        "VGNCIA": vigencia,
      };
}
