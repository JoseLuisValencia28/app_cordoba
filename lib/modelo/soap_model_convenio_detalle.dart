import 'dart:convert';

List<SoapModelConvenioDetalle> soapModelFromJson(String str) =>
    List<SoapModelConvenioDetalle>.from(
        json.decode(str).map((x) => SoapModelConvenioDetalle.fromJson(x)));

String soapModelToJson(List<SoapModelConvenioDetalle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelConvenioDetalle {
  // ignore: non_constant_identifier_names
  SoapModelConvenioDetalle({
    this.estadoconvenio,
    this.fechavenceconvenio,
    this.numerocuota,
    this.valorcuota,
  });

  String? estadoconvenio, fechavenceconvenio, numerocuota, valorcuota;

  factory SoapModelConvenioDetalle.fromJson(Map<String, dynamic> json) =>
      SoapModelConvenioDetalle(
        estadoconvenio: json["ESTADO"],
        fechavenceconvenio: json["FCHA_VNCE"],
        numerocuota: json["NMRO_CTA"],
        valorcuota: json["VLOR_TTAL_CTA"],
      );
  Map<String, dynamic> toJson() => {
        "ESTADO": estadoconvenio,
        "FCHA_VNCE": fechavenceconvenio,
        "NMRO_CTA": numerocuota,
        "VLOR_TTAL_CTA": valorcuota,
      };
}
