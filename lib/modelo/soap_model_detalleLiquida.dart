import 'dart:convert';

List<SoapDetalleLiquida> soapModelFromJson(String str) =>
    List<SoapDetalleLiquida>.from(
        json.decode(str).map((x) => SoapDetalleLiquida.fromJson(x)));

String soapModelToJson(List<SoapDetalleLiquida> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoapDetalleLiquida {
  // ignore: non_constant_identifier_names
  SoapDetalleLiquida({
    this.detalleliquidacion,
    this.cdgoblndje,
    this.cdgoclse,
    this.cdgodprtrmnto,
    this.cdgolnea,
    this.cdgomncpio,
    this.cdgotpocrrcria,
    this.clndrje,
    this.cpcdadcrgas,
    this.cpcdadpsjros,
    this.dgtovrfccion,
    this.drccionprptrio,
    this.dscrpcionblndje,
    this.dscrpcionclse,
    this.dscrpcioncrrcria,
    this.dscrpcionlnea,
    this.fchalmte,
    this.fchavlda,
    this.frccionano,
    this.indcdoractos,
    this.nmbreprptrio,
    this.tlfnoprptrio,
    this.tpoidntfccion,
  });

  String? detalleliquidacion,
      cdgoblndje,
      cdgoclse,
      cdgodprtrmnto,
      cdgolnea,
      cdgomncpio,
      cdgotpocrrcria,
      clndrje,
      cpcdadcrgas,
      cpcdadpsjros,
      dgtovrfccion,
      drccionprptrio,
      dscrpcionblndje,
      dscrpcionclse,
      dscrpcioncrrcria,
      dscrpcionlnea,
      fchalmte,
      fchavlda,
      frccionano,
      indcdoractos,
      nmbreprptrio,
      tlfnoprptrio,
      tpoidntfccion;

  factory SoapDetalleLiquida.fromJson(Map<String, dynamic> json) =>
      SoapDetalleLiquida(
        detalleliquidacion: json["detalle_liquidacion"],
        cdgoblndje: json["p_cdgo_blndje"],
        cdgoclse: json["p_cdgo_clse"],
        cdgodprtrmnto: json["p_cdgo_dprtrmnto"],
        cdgolnea: json["p_cdgo_lnea"],
        cdgomncpio: json["p_cdgo_mncpio"],
        cdgotpocrrcria: json["p_cdgo_tpo_crrcria"],
        clndrje: json["p_clndrje"],
        cpcdadcrgas: json["p_cpcdad_crgas"],
        cpcdadpsjros: json["p_cpcdad_psjros"],
        dgtovrfccion: json["p_dgto_vrfccion"],
        drccionprptrio: json["p_drccion_prptrio"],
        dscrpcionblndje: json["p_dscrpcion_blndje"],
        dscrpcionclse: json["p_dscrpcion_clse"],
        dscrpcioncrrcria: json["p_dscrpcion_crrcria"],
        dscrpcionlnea: json["p_dscrpcion_lnea"],
        fchalmte: json["p_fcha_lmte"],
        fchavlda: json["p_fcha_vlda"],
        frccionano: json["p_frccion_ano"],
        indcdoractos: json["p_idntfccion_prptrios"],
        nmbreprptrio: json["p_nmbre_prptrio"],
        tlfnoprptrio: json["p_tlfno_prptrio"],
        tpoidntfccion: json["p_tpo_idntfccion"],
      );

  Map<String, dynamic> toJson() => {
        "detalle_liquidacion": detalleliquidacion,
        "p_cdgo_blndje": cdgoblndje,
        "p_cdgo_clse": cdgoclse,
        "p_cdgo_dprtrmnto": cdgodprtrmnto,
        "p_cdgo_lnea": cdgolnea,
        "p_cdgo_mncpio": cdgomncpio,
        "p_cdgo_tpo_crrcria": cdgotpocrrcria,
        "p_clndrje": clndrje,
        "p_cpcdad_crgas": cpcdadcrgas,
        "p_cpcdad_psjros": cpcdadpsjros,
        "p_dgto_vrfccion": dgtovrfccion,
        "p_drccion_prptrio": drccionprptrio,
        "p_dscrpcion_blndje": dscrpcionblndje,
        "p_dscrpcion_clse": dscrpcionclse,
        "p_dscrpcion_crrcria": dscrpcioncrrcria,
        "p_dscrpcion_lnea": dscrpcionlnea,
        "p_fcha_lmte": fchalmte,
        "p_fcha_vlda": fchavlda,
        "p_frccion_ano": frccionano,
        "p_idntfccion_prptrios": indcdoractos,
        "p_nmbre_prptrio": nmbreprptrio,
        "p_tlfno_prptrio": tlfnoprptrio,
        "p_tpo_idntfccion": tpoidntfccion,
      };
}
