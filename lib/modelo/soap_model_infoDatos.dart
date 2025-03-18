// To parse this JSON data, do
//
//     final soapModel = soapModelFromJson(jsonString);

import 'dart:convert';

List<SoapInfoCartera> soapModelFromJson(String str) =>
    List<SoapInfoCartera>.from(
        json.decode(str).map((x) => SoapInfoCartera.fromJson(x)));

String soapModelToJson(List<SoapInfoCartera> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapInfoCartera {
  SoapInfoCartera({
    this.email,
    this.blndje,
    this.clndrje,
    this.clse,
    this.cpcdadcrgas,
    this.cpcdadpsjros,
    this.dprtmnto,
    this.exste,
    this.lnea,
    this.mdlo,
    this.mncpio,
    this.mrca,
    this.tpocrrcria,
  });

  String? email,
      blndje,
      clndrje,
      clse,
      cpcdadcrgas,
      cpcdadpsjros,
      dprtmnto,
      exste,
      lnea,
      mdlo,
      mncpio,
      mrca,
      tpocrrcria;

  factory SoapInfoCartera.fromJson(Map<String, dynamic> json) =>
      SoapInfoCartera(
        email: json["email"],
        blndje: json["p_blndje"],
        clndrje: json["p_clndrje"],
        clse: json["p_clse"],
        cpcdadcrgas: json["p_cpcdad_crgas"],
        cpcdadpsjros: json["p_cpcdad_psjros"],
        dprtmnto: json["p_dprtmnto"],
        exste: json["p_exste"],
        lnea: json["p_lnea"],
        mdlo: json["p_mdlo"],
        mncpio: json["p_mncpio"],
        mrca: json["p_mrca"],
        tpocrrcria: json["p_tpo_crrcria"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "p_blndje": blndje,
        "p_clndrje": clndrje,
        "p_clse": clse,
        "p_cpcdad_crgas": cpcdadcrgas,
        "p_cpcdad_psjros": cpcdadpsjros,
        "p_dprtmnto": dprtmnto,
        "p_exste": exste,
        "p_lnea": lnea,
        "p_mdlo": mdlo,
        "p_mncpio": mncpio,
        "p_mrca": mrca,
        "p_tpo_crrcria": tpocrrcria,
      };
}
