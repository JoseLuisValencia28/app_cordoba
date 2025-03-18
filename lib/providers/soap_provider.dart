import 'dart:convert';

import 'package:app_cordoba/modelo/soap_model_convenio_detalle.dart';
import 'package:app_cordoba/modelo/soap_model_dec.dart';
import 'package:app_cordoba/modelo/soap_model_departamento.dart';
import 'package:app_cordoba/modelo/soap_model_detalleLiquida.dart';
import 'package:app_cordoba/modelo/soap_model_fecha_liquida.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/soap_model_infoVig.dart';
import 'package:app_cordoba/modelo/soap_model_marca.dart';
import 'package:app_cordoba/modelo/soap_model_municipio.dart';
import 'package:app_cordoba/modelo/soap_model_recibo_pago.dart';
import 'package:app_cordoba/modelo/soap_model_recibo_pago_convenio.dart';
import 'package:app_cordoba/modelo/soap_model_registrarLiquida.dart';
import 'package:app_cordoba/modelo/soap_model_sota.dart';
import 'package:app_cordoba/modelo/soap_verifiation.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

final oCcy = NumberFormat("#,##0", "en_US");

class SoapProvider {
  var decodjs = "";
  List<SoapModelo> itemsList = [];
  List<SoapModelMarca> itemsListMarca = [];
  List<SoapModelInfoVehi> itemsListInfoVehi = [];
  List<SoapModelInfoVig> itemsVig = [];
  List<SoapFechaLiquida> itemsFechaLiquida = [];
  List<SoapDetalleLiquida> itemsDetalleLiquida = [];
  List<SoapSOAT> itemsSoat = [];
  List<SoapInfoCartera> itemsCartera = [];
  List<SoapMoedelDepartamento> itemsDepartamento = [];
  List<SoapModelMunicipio> itemsMunicipio = [];
  List<SoapModelRegistroLiquida> itemsRegistroLiquida = [];
  List<SoapModelDec> itemsDec = [];
  List<SoapModelRecibo> itemsRecibo = [];
  List<SoapModelConvenio> itemsConvenio = [];
  List<SoapModelConvenioDetalle> itemsConvenioDetalle = [];

  SoapModelo soapModelVeri = SoapModelo();
  SoapModelMarca soapModelMarca = SoapModelMarca();
  SoapModelInfoVehi soapModelInfoVehi = SoapModelInfoVehi();
  SoapModelInfoVig soapModelInfoVig = SoapModelInfoVig();
  SoapFechaLiquida soapFechaLiquida = SoapFechaLiquida();
  SoapDetalleLiquida soapDetalleLiquida = SoapDetalleLiquida();
  SoapSOAT soapSOAT = SoapSOAT();
  SoapInfoCartera soapCartera = SoapInfoCartera();
  SoapMoedelDepartamento soapDepartamento = SoapMoedelDepartamento();
  SoapModelMunicipio soapMunicipio = SoapModelMunicipio();
  SoapModelRegistroLiquida soapModelRegistroLiquida =
      SoapModelRegistroLiquida();
  SoapModelDec soapDec = SoapModelDec();
  SoapModelRecibo soapRecibo = SoapModelRecibo();
  SoapModelConvenio soapConvenio = SoapModelConvenio();
  SoapModelConvenioDetalle soapConvenioDetalle = SoapModelConvenioDetalle();

  final uri = Uri.parse(Url_Global);

  final requestBody =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
      xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoModelo>
         <!--Optional:-->
         <PLACA>0</PLACA>
      </oper:InfoModelo>
   </soapenv:Body>
</soapenv:Envelope>''';

  final requestBodyMarca =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
      xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoMarca>
         <!--Optional:-->
         <MARCA>0</MARCA>
      </oper:InfoMarca>
   </soapenv:Body>
</soapenv:Envelope>''';

  final requestBodySOAT =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
      xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoSOAT>
         <!--Optional:-->
         <PLACA>0</PLACA>
      </oper:InfoSOAT>
   </soapenv:Body>
</soapenv:Envelope>''';

  final requestBodyDepartamento =
      '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoDepartamentos>
         <!--Optional:-->
         <DEP>0</DEP>
      </oper:InfoDepartamentos>
   </soapenv:Body>
</soapenv:Envelope>''';
  Future<List<SoapMoedelDepartamento>> getSoapDepartamento() async {
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoDepartamentos",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyDepartamento),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingDepartamento(bod);
      /*_prueba = soapModelVeriToJson(itemsList);
      final decodjs = jsonDecode(_prueba) as List;
      data = decodjs.map((e) => SoapModelVeri.fromJson(e)).toList();*/
      return itemsDepartamento;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapModelo>> getSoap() async {
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoModelo",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBody),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsing(bod);
      /*_prueba = soapModelVeriToJson(itemsList);
      final decodjs = jsonDecode(_prueba) as List;
      data = decodjs.map((e) => SoapModelVeri.fromJson(e)).toList();*/
      return itemsList;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapModelMarca>> getSoapMarca() async {
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoMarca",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyMarca),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingMarca(bod);
      /*_prueba = soapModelVeriToJson(itemsList);
      final decodjs = jsonDecode(_prueba) as List;
      data = decodjs.map((e) => SoapModelVeri.fromJson(e)).toList();*/
      return itemsListMarca;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapModelInfoVehi>> getSoapInfoVehiculo(String placa) async {
    final requestBodyInfoVehi =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
      xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoVehiculo>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
      </oper:InfoVehiculo>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoVehiculo",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyInfoVehi),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingInfoVehi(bod);
      /*_prueba = soapModelVeriToJson(itemsList);
      final decodjs = jsonDecode(_prueba) as List;
      data = decodjs.map((e) => SoapModelVeri.fromJson(e)).toList();*/
      return itemsListInfoVehi;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapModelConvenio>> getSoapConvenio(String placa) async {
    final requestBodyConvenio =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:ConsultaConvenio>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
      </oper:ConsultaConvenio>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "ConsultaConvenio",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyConvenio),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingConvenio(bod);
      return itemsConvenio;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapModelConvenioDetalle>> getSoapConvenioDetalle(
      String placa, String convenio) async {
    final requestBodyConvenioDetalle =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoConvenio>
         <!--Optional:-->
         <CONVENIO>''' +
            convenio +
            '''</CONVENIO>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
      </oper:InfoConvenio>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoConvenio",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyConvenioDetalle),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingConvenioDetalle(bod);
      return itemsConvenioDetalle;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapModelDec>> getSoapDeclaracion(String placa) async {
    final requestBodyDec =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoDeclaracion>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
      </oper:InfoDeclaracion>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoDeclaracion",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyDec),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingDeclara(bod);
      /*_prueba = soapModelVeriToJson(itemsList);
      final decodjs = jsonDecode(_prueba) as List;
      data = decodjs.map((e) => SoapModelVeri.fromJson(e)).toList();*/
      return itemsDec;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapModelInfoVig>> getSoapInfoVigenciaValida(String placa) async {
    final requestBodyVig =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
      xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoVigenciaValida>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
      </oper:InfoVigenciaValida>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoVigenciaValida",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyVig),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingVigValida(bod);
      return itemsVig;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapFechaLiquida>> getSoapFechaLiquida(
      String placa, String vigencia) async {
    final requestBodyFecha =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoFechaLiquida>
         <!--Optional:-->
         <p_nmro_plca>''' +
            placa +
            '''</p_nmro_plca>
         <!--Optional:-->
         <p_vgncia>''' +
            vigencia +
            '''</p_vgncia>
      </oper:InfoFechaLiquida>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoFechaLiquida",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyFecha),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingFechaLiquida(bod);
    } else {
      itemsFechaLiquida = [];
    }
    return itemsFechaLiquida;
  }

  Future<List<SoapDetalleLiquida>> getSoapInfoDetalleLiqudia(
      String placa, vigencia, fecha, identificacion) async {
    final requestBodyVig =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoLiquida>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
         <!--Optional:-->
         <VEGENCIA>''' +
            vigencia +
            '''</VEGENCIA>
         <!--Optional:-->
         <FECHA_PAGO>''' +
            fecha +
            '''</FECHA_PAGO>
         <!--Optional:-->
         <IDENTIFICACION>''' +
            identificacion +
            '''</IDENTIFICACION>
      </oper:InfoLiquida>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoLiquida",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyVig),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingDetalleLiquida(bod);
      return itemsDetalleLiquida;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapSOAT>> getSoat() async {
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoSOAT",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodySOAT),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingSOAT(bod);
      /*_prueba = soapModelVeriToJson(itemsList);
      final decodjs = jsonDecode(_prueba) as List;
      data = decodjs.map((e) => SoapModelVeri.fromJson(e)).toList();*/
      return itemsSoat;
    } else {
      throw Exception("error");
    }
  }

  Future<List<SoapInfoCartera>> getInfoCartera(String placa) async {
    final requestBodyCartera =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
        xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoCartera>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
      </oper:InfoCartera>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoCartera",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyCartera),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingCartera(bod);
    } else {
      itemsCartera = [];
    }
    return itemsCartera;
  }

  Future<List<SoapModelMunicipio>> getMunicipio(String departamento) async {
    final requestBodyMunicipio =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:InfoMun>
         <!--Optional:-->
         <MUN>''' +
            departamento +
            '''</MUN>
      </oper:InfoMun>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoMun",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyMunicipio),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingMunicipio(bod);
    } else {
      itemsMunicipio = [];
    }
    return itemsMunicipio;
  }

  Future<List<SoapModelRegistroLiquida>> getRegistroLiquida(
      List dato,
      String placa,
      List infoVeh,
      List cartera,
      String vigencia,
      String fechalimite,
      String _codigdepartamento,
      String _departamento,
      String _codigmuni,
      String _municipio,
      String direccion,
      String telefono,
      String correo,
      String nitSOAT,
      String nombreSOAT,
      String fechaSOAT,
      String valorPagar,
      String valorMunicipio,
      String valorDepartamento,
      String pse) async {
    final requestBodyRegisterLiquida =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:RegistraLiquida>
         <!--Optional:-->
         <Entrada1>''' +
            placa +
            '''</Entrada1>
         <!--Optional:-->
         <Entrada2>''' +
            vigencia +
            '''</Entrada2>
         <!--Optional:-->
         <Entrada3>''' +
            fechalimite +
            '''</Entrada3>
         <!--Optional:-->
         <Entrada4></Entrada4>
         <!--Optional:-->
         <Entrada5></Entrada5>
         <!--Optional:-->
         <Entrada6>''' +
            infoVeh[0].p_idntfccion_prptrios +
            '''</Entrada6>
         <!--Optional:-->
         <Entrada7>''' +
            dato[0].tpoidntfccion +
            '''</Entrada7>
         <!--Optional:-->
         <Entrada8>''' +
            dato[0].nmbreprptrio +
            '''</Entrada8>
         <!--Optional:-->
         <Entrada9>''' +
            direccion +
            '''</Entrada9>
         <!--Optional:-->
         <Entrada10>''' +
            _codigdepartamento +
            '''</Entrada10>
         <!--Optional:-->
         <Entrada11>''' +
            _codigmuni +
            '''</Entrada11>
         <!--Optional:-->
         <Entrada12>''' +
            telefono +
            '''</Entrada12>
         <!--Optional:-->
         <Entrada13>''' +
            correo +
            '''</Entrada13>
         <!--Optional:-->
         <Entrada14>''' +
            infoVeh[0].p_cdgo_mrca +
            '''</Entrada14>
         <!--Optional:-->
         <Entrada15>''' +
            infoVeh[0].p_cdgo_lnea +
            '''</Entrada15>
         <!--Optional:-->
         <Entrada16>''' +
            infoVeh[0].p_mdlo +
            '''</Entrada16>
         <!--Optional:-->
         <Entrada17>''' +
            infoVeh[0].p_cdgo_clse +
            '''</Entrada17>
         <!--Optional:-->
         <Entrada18>''' +
            infoVeh[0].p_cdgo_crrcria +
            '''</Entrada18>
         <!--Optional:-->
         <Entrada19>''' +
            infoVeh[0].p_cdgo_blndje +
            '''</Entrada19>
         <!--Optional:-->
         <Entrada20>''' +
            infoVeh[0].p_clndrje +
            '''</Entrada20>
         <!--Optional:-->
         <Entrada21>''' +
            infoVeh[0].p_cpcdad_psjros +
            '''</Entrada21>
         <!--Optional:-->
         <Entrada22>''' +
            infoVeh[0].p_cpcdad_crga +
            '''</Entrada22>
         <!--Optional:-->
         <Entrada23>''' +
            nitSOAT +
            '''</Entrada23>
         <!--Optional:-->
         <Entrada24>''' +
            nombreSOAT +
            '''</Entrada24>
         <!--Optional:-->
         <Entrada25>''' +
            fechaSOAT +
            '''</Entrada25>
         <!--Optional:-->
         <Entrada26>''' +
            infoVeh[0].p_idntfccion_prptrios +
            '''</Entrada26>
         <!--Optional:-->
         <Entrada27>''' +
            dato[0].tpoidntfccion +
            '''</Entrada27>
         <!--Optional:-->
         <Entrada28>''' +
            dato[0].nmbreprptrio +
            '''</Entrada28>
         <!--Optional:-->
         <Entrada29>''' +
            dato[0].frccionano +
            '''</Entrada29>
         <!--Optional:-->
         <Entrada30>''' +
            valorPagar +
            '''</Entrada30>
         <!--Optional:-->
         <Entrada31>''' +
            valorMunicipio +
            '''</Entrada31>
         <!--Optional:-->
         <Entrada32>''' +
            valorDepartamento +
            '''</Entrada32>
         <!--Optional:-->
         <Entrada33>$pse</Entrada33>
         <!--Optional:-->
         <Entrada34>''' +
            dato[0].detalleliquidacion +
            '''</Entrada34>
      </oper:RegistraLiquida>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "RegistraLiquida",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyRegisterLiquida),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingRegistroLiquida(bod);

      return itemsRegistroLiquida;
    } else {
      throw Exception("error");
    }
  }

  Future _parsingDetalleLiquida(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    items.map((xml.XmlElement item) {
      soapDetalleLiquida = SoapDetalleLiquida();
      soapDetalleLiquida.detalleliquidacion =
          _getValue(item.findElements("detalle_liquidacion"));
      soapDetalleLiquida.cdgoblndje =
          _getValue(item.findElements("p_cdgo_blndje"));
      soapDetalleLiquida.cdgoclse = _getValue(item.findElements("p_cdgo_clse"));
      soapDetalleLiquida.cdgodprtrmnto =
          _getValue(item.findElements("p_cdgo_dprtrmnto"));
      soapDetalleLiquida.cdgolnea = _getValue(item.findElements("p_cdgo_lnea"));
      soapDetalleLiquida.cdgomncpio =
          _getValue(item.findElements("p_cdgo_mncpio"));
      soapDetalleLiquida.cdgotpocrrcria =
          _getValue(item.findElements("p_cdgo_tpo_crrcria"));
      soapDetalleLiquida.clndrje = _getValue(item.findElements("p_clndrje"));
      soapDetalleLiquida.cpcdadcrgas =
          _getValue(item.findElements("p_cpcdad_crgas"));
      soapDetalleLiquida.cpcdadpsjros =
          _getValue(item.findElements("p_cpcdad_psjros"));
      soapDetalleLiquida.dgtovrfccion =
          _getValue(item.findElements("p_dgto_vrfccion"));
      soapDetalleLiquida.drccionprptrio =
          _getValue(item.findElements("p_drccion_prptrio"));
      soapDetalleLiquida.dscrpcionblndje =
          _getValue(item.findElements("p_dscrpcion_blndje"));
      soapDetalleLiquida.dscrpcionclse =
          _getValue(item.findElements("p_dscrpcion_clse"));
      soapDetalleLiquida.dscrpcioncrrcria =
          _getValue(item.findElements("p_dscrpcion_crrcria"));
      soapDetalleLiquida.dscrpcionlnea =
          _getValue(item.findElements("p_dscrpcion_lnea"));
      soapDetalleLiquida.fchalmte = _getValue(item.findElements("p_fcha_lmte"));
      soapDetalleLiquida.fchavlda = _getValue(item.findElements("p_fcha_vlda"));
      soapDetalleLiquida.frccionano =
          _getValue(item.findElements("p_frccion_ano"));
      soapDetalleLiquida.indcdoractos =
          _getValue(item.findElements("p_indcdor_actos"));
      soapDetalleLiquida.nmbreprptrio =
          _getValue(item.findElements("p_nmbre_prptrio"));
      soapDetalleLiquida.tlfnoprptrio =
          _getValue(item.findElements("p_tlfno_prptrio"));
      soapDetalleLiquida.tpoidntfccion =
          _getValue(item.findElements("p_tpo_idntfccion"));
      itemsDetalleLiquida.add(soapDetalleLiquida);
    }).toList();
  }

  Future<List<SoapModelRecibo>> getReciboDepago(String placa) async {
    final requestBodyRecibo =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:oper="http://oper.infortributos.co/">
   <soapenv:Header/>
   <soapenv:Body>
      <oper:infoReciboOficial>
         <!--Optional:-->
         <PLACA>''' +
            placa +
            '''</PLACA>
      </oper:infoReciboOficial>
   </soapenv:Body>
</soapenv:Envelope>''';
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "infoReciboOficial",
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBodyRecibo),
        encoding: Encoding.getByName("UTF-8"));

    if (resp.statusCode == 200) {
      final bod = resp.body;
      _parsingRecibo(bod);
      return itemsRecibo;
    } else {
      throw Exception("error");
    }
  }

  Future _parsingRecibo(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    itemsRecibo.clear();
    items.map((xml.XmlElement item) {
      soapRecibo = SoapModelRecibo();
      soapRecibo.capital = _getValue(item.findElements("CAPITAL"));
      soapRecibo.estadoFactura = _getValue(item.findElements("ESTDO_FCTRA"));
      soapRecibo.interes = _getValue(item.findElements("INTERES"));
      soapRecibo.numeroFactura = _getValue(item.findElements("NMRO_FCTRA"));
      soapRecibo.periodoFraccion =
          _getValue(item.findElements("PRDO_FCTRCION"));
      soapRecibo.periodoLiquida = _getValue(item.findElements("PRDO_LQDCION"));
      soapRecibo.total = _getValue(item.findElements("TOTAL"));
      soapRecibo.vigencia = _getValue(item.findElements("VGNCIA"));
      itemsRecibo.add(soapRecibo);
    }).toList();
  }

  Future _parsing(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    items.map((xml.XmlElement item) {
      soapModelVeri = SoapModelo();
      soapModelVeri.modelo = _getValue(item.findElements("modelo"));
      itemsList.add(soapModelVeri);
    }).toList();
  }

  Future _parsingDepartamento(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    items.map((xml.XmlElement item) {
      soapDepartamento = SoapMoedelDepartamento();
      soapDepartamento.cdgodprtmnto =
          _getValue(item.findElements("cdgo_dprtmnto"));
      soapDepartamento.nmbre = _getValue(item.findElements("nmbre"));
      soapDepartamento.position = _getValue(item.findElements("position"));
      itemsDepartamento.add(soapDepartamento);
    }).toList();
  }

  Future _parsingMunicipio(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');

    itemsMunicipio = [];
    items.map((xml.XmlElement item) {
      soapMunicipio = SoapModelMunicipio();
      soapMunicipio.cdgo_dprtmnto =
          _getValue(item.findElements("cdgo_dprtmnto"));
      soapMunicipio.cdgo_mncpio = _getValue(item.findElements("cdgo_mncpio"));
      soapMunicipio.nmbre_mncpio = _getValue(item.findElements("nmbre_mncpio"));
      itemsMunicipio.add(soapMunicipio);
    }).toList();
  }

  Future _parsingRegistroLiquida(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    itemsRegistroLiquida = [];
    items.map((xml.XmlElement item) {
      soapModelRegistroLiquida = SoapModelRegistroLiquida();
      soapModelRegistroLiquida.prgstro =
          _getValue(item.findElements("p_rgstro"));
      soapModelRegistroLiquida.pcnsctvo =
          _getValue(item.findElements("p_cnsctvo"));
      soapModelRegistroLiquida.pnmroprmprso =
          _getValue(item.findElements("p_nmro_prmprso"));
      itemsRegistroLiquida.add(soapModelRegistroLiquida);
    }).toList();
  }

  Future _parsingMarca(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    items.map((xml.XmlElement item) {
      soapModelMarca = SoapModelMarca();
      soapModelMarca.marca = _getValue(item.findElements("marca"));
      itemsListMarca.add(soapModelMarca);
    }).toList();
  }

  Future _parsingDeclara(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    itemsDec = [];
    items.map((xml.XmlElement item) {
      soapDec = SoapModelDec();

      soapDec.crrcion = _getValue(item.findElements("crrcion"));
      soapDec.fcharcbolte = _getValue(item.findElements("fcha_rcbo_lte"));
      soapDec.nmbrebnco = _getValue(item.findElements("nmbre_bnco"));
      soapDec.nmroprimprso = _getValue(item.findElements("nmro_primprso"));
      soapDec.prdolqdcion = _getValue(item.findElements("prdo_lqdcion"));
      soapDec.vgncia = _getValue(item.findElements("vgncia"));
      itemsDec.add(soapDec);
    }).toList();
  }

  Future _parsingInfoVehi(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    soapModelInfoVehi = SoapModelInfoVehi();
    itemsListInfoVehi = [];
    items.map((xml.XmlElement item) {
      soapModelInfoVehi.fecha_server =
          _getValue(item.findElements("fecha_server"));
      soapModelInfoVehi.p_cdad_or_trnsto =
          _getValue(item.findElements("p_cdad_or_trnsto"));
      soapModelInfoVehi.p_cdgo_blndje =
          _getValue(item.findElements("p_cdgo_blndje"));
      soapModelInfoVehi.p_cdgo_clse =
          _getValue(item.findElements("p_cdgo_clse"));
      soapModelInfoVehi.p_cdgo_crrcria =
          _getValue(item.findElements("p_cdgo_crrcria"));
      soapModelInfoVehi.p_cdgo_lnea =
          _getValue(item.findElements("p_cdgo_lnea"));
      soapModelInfoVehi.p_cdgo_mrca =
          _getValue(item.findElements("p_cdgo_mrca"));
      soapModelInfoVehi.p_clndrje = _getValue(item.findElements("p_clndrje"));
      soapModelInfoVehi.p_cntdad_vgncias =
          _getValue(item.findElements("p_cntdad_vgncias"));
      soapModelInfoVehi.p_cpcdad_crga =
          _getValue(item.findElements("p_cpcdad_crga"));
      soapModelInfoVehi.p_cpcdad_psjros =
          _getValue(item.findElements("p_cpcdad_psjros"));
      soapModelInfoVehi.p_dscripcion_blndje =
          _getValue(item.findElements("p_dscripcion_blndje"));
      soapModelInfoVehi.p_dscrpcion_clse =
          _getValue(item.findElements("p_dscrpcion_clse"));
      soapModelInfoVehi.p_dscrpcion_crrcria =
          _getValue(item.findElements("p_dscrpcion_crrcria"));
      soapModelInfoVehi.p_dscrpcion_lnea =
          _getValue(item.findElements("p_dscrpcion_lnea"));
      soapModelInfoVehi.p_dscrpcion_mrca =
          _getValue(item.findElements("p_dscrpcion_mrca"));
      soapModelInfoVehi.p_estdo = _getValue(item.findElements("p_estdo"));
      soapModelInfoVehi.p_exstes = _getValue(item.findElements("p_exste"));
      soapModelInfoVehi.p_idntfccion_prptrios =
          _getValue(item.findElements("p_idntfccion_prptrios"));
      soapModelInfoVehi.p_mdlo = _getValue(item.findElements("p_mdlo"));

      itemsListInfoVehi.add(soapModelInfoVehi);
    }).toList();
  }

  Future _parsingConvenio(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');

    itemsConvenio = [];
    items.map((xml.XmlElement item) {
      soapConvenio = SoapModelConvenio();
      soapConvenio.estadoconvenio =
          _getValue(item.findElements("ESTDO_CNVNIO"));
      soapConvenio.fechaconvenio = _getValue(item.findElements("FCHA_CNVNIO"));
      soapConvenio.placa = _getValue(item.findElements("IDNTFCCION"));
      soapConvenio.idcontribuyente =
          _getValue(item.findElements("IDNTFCCION_CNTRBYNTE"));
      soapConvenio.nombrecontribuyente =
          _getValue(item.findElements("NMBRE_CNTRBYNTE"));
      soapConvenio.numeroconvenio = _getValue(item.findElements("NMRO_CNVNIO"));
      soapConvenio.valorconvenio = _getValue(item.findElements("VLOR_CNVNIO"));
      itemsConvenio.add(soapConvenio);
    }).toList();
  }

  Future _parsingConvenioDetalle(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');

    itemsConvenioDetalle = [];
    items.map((xml.XmlElement item) {
      soapConvenioDetalle = SoapModelConvenioDetalle();
      soapConvenioDetalle.estadoconvenio =
          _getValue(item.findElements("ESTADO"));
      soapConvenioDetalle.fechavenceconvenio =
          _getValue(item.findElements("FCHA_VNCE"));
      soapConvenioDetalle.numerocuota =
          _getValue(item.findElements("NMRO_CTA"));
      soapConvenioDetalle.valorcuota =
          _getValue(item.findElements("VLOR_TTAL_CTA"));

      itemsConvenioDetalle.add(soapConvenioDetalle);
    }).toList();
  }

  Future _parsingFechaLiquida(var _response) async {
    var _document = XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    soapFechaLiquida = SoapFechaLiquida();
    itemsFechaLiquida = [];
    items.map((xml.XmlElement item) {
      soapFechaLiquida.p_fcha_lmte =
          _getValue(item.findElements("p_fcha_lmte"));
      soapFechaLiquida.result = _getValue(item.findElements("result"));
      itemsFechaLiquida.add(soapFechaLiquida);
    }).toList();
  }

  Future _parsingVigValida(var _response) async {
    var _document = XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    itemsVig.clear();
    items.map((xml.XmlElement item) {
      soapModelInfoVig = SoapModelInfoVig();
      soapModelInfoVig.respuesta = _getValue(item.findElements("respuesta"));
      soapModelInfoVig.vigencia = _getValue(item.findElements("vigencia"));
      itemsVig.add(soapModelInfoVig);
    }).toList();
  }

  Future _parsingSOAT(var _response) async {
    var _document = XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    items.map((xml.XmlElement item) {
      soapSOAT = SoapSOAT();
      soapSOAT.dgto_vrfccion = _getValue(item.findElements("dgto_vrfccion"));
      soapSOAT.idntfccion_asgrdra =
          _getValue(item.findElements("idntfccion_asgrdra"));
      soapSOAT.nmbre_asgrdra = _getValue(item.findElements("nmbre_asgrdra"));
      itemsSoat.add(soapSOAT);
    }).toList();
  }

  Future _parsingCartera(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    itemsCartera.clear();
    items.map((xml.XmlElement item) {
      soapCartera = SoapInfoCartera();
      soapCartera.email = _getValue(item.findElements("email"));
      soapCartera.blndje = _getValue(item.findElements("p_blndje"));
      soapCartera.clndrje = _getValue(item.findElements("p_clndrje"));
      soapCartera.clse = _getValue(item.findElements("p_clse"));
      soapCartera.cpcdadcrgas = _getValue(item.findElements("p_cpcdad_crgas"));
      soapCartera.cpcdadpsjros =
          _getValue(item.findElements("p_cpcdad_psjros"));
      soapCartera.dprtmnto = _getValue(item.findElements("p_dprtmnto"));
      soapCartera.exste = _getValue(item.findElements("p_exste"));
      soapCartera.lnea = _getValue(item.findElements("p_lnea"));
      soapCartera.mdlo = _getValue(item.findElements("p_mdlo"));
      soapCartera.mncpio = _getValue(item.findElements("p_mncpio"));
      soapCartera.mrca = _getValue(item.findElements("p_mrca"));
      soapCartera.tpocrrcria = _getValue(item.findElements("p_tpo_crrcria"));
      itemsCartera.add(soapCartera);
    }).toList();
  }

  _getValue(Iterable<xml.XmlElement> items) {
    var textValue;
    items.map((xml.XmlElement node) {
      textValue = node.text;
    }).toList();
    return textValue;
  }
}
