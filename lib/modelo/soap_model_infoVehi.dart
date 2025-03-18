// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<SoapModelInfoVehi> soapModelFromJson(String str) =>
    List<SoapModelInfoVehi>.from(
      json.decode(str).map((x) => SoapModelInfoVehi.fromJson(x)),
    );

String soapModelToJson(List<SoapModelInfoVehi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapModelInfoVehi {
  SoapModelInfoVehi({
    this.fecha_server,
    this.p_cdad_or_trnsto,
    this.p_cdgo_blndje,
    this.p_cdgo_clse,
    this.p_cdgo_crrcria,
    this.p_cdgo_lnea,
    this.p_cdgo_mrca,
    this.p_clndrje,
    this.p_cntdad_vgncias,
    this.p_cpcdad_crga,
    this.p_cpcdad_psjros,
    this.p_dscripcion_blndje,
    this.p_dscrpcion_clse,
    this.p_dscrpcion_crrcria,
    this.p_dscrpcion_lnea,
    this.p_dscrpcion_mrca,
    this.p_estdo,
    this.p_exstes,
    this.p_idntfccion_prptrios,
    this.p_mdlo,
  });
  String? fecha_server;
  String? p_cdad_or_trnsto;
  String? p_cdgo_blndje;
  String? p_cdgo_clse;
  String? p_cdgo_crrcria;
  String? p_cdgo_lnea;
  String? p_cdgo_mrca;
  String? p_clndrje;
  String? p_cntdad_vgncias;
  String? p_cpcdad_crga;
  String? p_cpcdad_psjros;
  String? p_dscripcion_blndje;
  String? p_dscrpcion_clse;
  String? p_dscrpcion_crrcria;
  String? p_dscrpcion_lnea;
  String? p_dscrpcion_mrca;
  String? p_estdo;
  String? p_exstes;
  String? p_idntfccion_prptrios;
  String? p_mdlo;

  factory SoapModelInfoVehi.fromJson(Map<String, dynamic> json) =>
      SoapModelInfoVehi(
        fecha_server: json["fecha_server"],
        p_cdad_or_trnsto: json["p_cdad_or_trnsto"],
        p_cdgo_blndje: json["p_cdgo_blndje"],
        p_cdgo_clse: json["p_cdgo_clse"],
        p_cdgo_crrcria: json["p_cdgo_crrcria"],
        p_cdgo_lnea: json["p_cdgo_lnea"],
        p_cdgo_mrca: json["p_cdgo_mrca"],
        p_clndrje: json["p_clndrje"],
        p_cntdad_vgncias: json["p_cntdad_vgncias"],
        p_cpcdad_crga: json["p_cpcdad_crga"],
        p_cpcdad_psjros: json["p_cpcdad_psjros"],
        p_dscripcion_blndje: json["p_dscripcion_blndje"],
        p_dscrpcion_clse: json["p_dscrpcion_clse"],
        p_dscrpcion_crrcria: json["p_dscrpcion_crrcria"],
        p_dscrpcion_lnea: json["p_dscrpcion_lnea"],
        p_dscrpcion_mrca: json["p_dscrpcion_mrca"],
        p_estdo: json["p_estdo"],
        p_exstes: json["p_exste"],
        p_idntfccion_prptrios: json["p_idntfccion_prptrios"],
        p_mdlo: json["p_mdlo"],
      );

  Map<String, dynamic> toJson() => {
    "fecha_server": fecha_server,
    "p_cdad_or_trnsto": p_cdad_or_trnsto,
    "p_cdgo_blndje": p_cdgo_blndje,
    "p_cdgo_clse": p_cdgo_clse,
    "p_cdgo_crrcria": p_cdgo_crrcria,
    "p_cdgo_lnea": p_cdgo_lnea,
    "p_cdgo_mrca": p_cdgo_mrca,
    "p_clndrje": p_clndrje,
    "p_cntdad_vgncias": p_cntdad_vgncias,
    "p_cpcdad_crga": p_cpcdad_crga,
    "p_cpcdad_psjros": p_cpcdad_psjros,
    "p_dscripcion_blndje": p_dscripcion_blndje,
    "p_dscrpcion_clse": p_dscrpcion_clse,
    "p_dscrpcion_crrcria": p_dscrpcion_crrcria,
    "p_dscrpcion_lnea": p_dscrpcion_lnea,
    "p_dscrpcion_mrca": p_dscrpcion_mrca,
    "p_estdo": p_estdo,
    "p_exste": p_exstes,
    "p_idntfccion_prptrios": p_idntfccion_prptrios,
    "p_mdlo": p_mdlo,
  };
}
