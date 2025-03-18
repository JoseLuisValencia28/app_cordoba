import 'dart:convert';

List<SoapModelRegistroLiquida> soapModelFromJson(String str) =>
    List<SoapModelRegistroLiquida>.from(
        json.decode(str).map((x) => SoapModelRegistroLiquida.fromJson(x)));

String soapModelToJson(List<SoapModelRegistroLiquida> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelRegistroLiquida {
  // ignore: non_constant_identifier_names
  SoapModelRegistroLiquida({
    this.prgstro,
    this.pcnsctvo,
    this.pnmroprmprso,
  });
  // String toString() => pnmroprmprso;

  String? prgstro, pcnsctvo, pnmroprmprso;

  factory SoapModelRegistroLiquida.fromJson(Map<String, dynamic> json) =>
      SoapModelRegistroLiquida(
        prgstro: json["p_rgstro"],
        pcnsctvo: json["p_cnsctvo"],
        pnmroprmprso: json["p_nmro_prmprso"],
      );

  Map<String, dynamic> toJson() => {
        "p_rgstro": prgstro,
        "p_cnsctvo": pcnsctvo,
        "p_nmro_prmprso": pnmroprmprso,
      };
}
