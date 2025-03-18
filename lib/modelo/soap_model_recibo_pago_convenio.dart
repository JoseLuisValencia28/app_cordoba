import 'dart:convert';

List<SoapModelConvenio> soapModelFromJson(String str) =>
    List<SoapModelConvenio>.from(
        json.decode(str).map((x) => SoapModelConvenio.fromJson(x)));

String soapModelToJson(List<SoapModelConvenio> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelConvenio {
  // ignore: non_constant_identifier_names
  SoapModelConvenio(
      {this.estadoconvenio,
      this.fechaconvenio,
      this.placa,
      this.idcontribuyente,
      this.nombrecontribuyente,
      this.numeroconvenio,
      this.valorconvenio});

  String? estadoconvenio,
      fechaconvenio,
      placa,
      idcontribuyente,
      nombrecontribuyente,
      numeroconvenio,
      valorconvenio;

  factory SoapModelConvenio.fromJson(Map<String, dynamic> json) =>
      SoapModelConvenio(
        estadoconvenio: json["ESTDO_CNVNIO"],
        fechaconvenio: json["FCHA_CNVNIO"],
        placa: json["IDNTFCCION"],
        idcontribuyente: json["IDNTFCCION_CNTRBYNTE"],
        nombrecontribuyente: json["NMBRE_CNTRBYNTE"],
        numeroconvenio: json["NMRO_CNVNIO"],
        valorconvenio: json["VLOR_CNVNIO"],
      );
  Map<String, dynamic> toJson() => {
        "ESTDO_CNVNIO": estadoconvenio,
        "FCHA_CNVNIO": fechaconvenio,
        "IDNTFCCION": placa,
        "IDNTFCCION_CNTRBYNTE": idcontribuyente,
        "NMBRE_CNTRBYNTE": nombrecontribuyente,
        "NMRO_CNVNIO": numeroconvenio,
        "VLOR_CNVNIO": valorconvenio,
      };
}
