import 'dart:convert';

import 'package:app_cordoba/modelo/soap_model_marca.dart';
import 'package:app_cordoba/providers/variables.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class SoapProviderMarca {
  var decodjs = "";
  List<SoapModelMarca> itemsList = [];
  SoapModelMarca soapModelmarca = SoapModelMarca();

  final requestBody =
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
  final uri = Uri.parse(Url_Global);
  Future<List<SoapModelMarca>> getSoap() async {
    final resp = await http.post(uri,
        headers: {
          "SOAPAction": "InfoMarca",
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

  Future _parsing(var _response) async {
    // ignore: deprecated_member_use
    var _document = xml.XmlDocument.parse(_response);
    Iterable<xml.XmlElement> items = _document.findAllElements('return');
    items.map((xml.XmlElement item) {
      soapModelmarca = SoapModelMarca();
      soapModelmarca.marca = _getValue(item.findElements("marca"));
      itemsList.add(soapModelmarca);
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
