import 'dart:convert';

List<ModelPropietario> soapModelFromJson(String str) =>
    List<ModelPropietario>.from(
        json.decode(str).map((x) => ModelPropietario.fromJson(x)));

String soapModelToJson(List<ModelPropietario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelPropietario {
  ModelPropietario({this.placa, this.idprop, this.marcavehi, this.modelovehi});
  final String? placa, idprop, modelovehi, marcavehi;

  // String toString() => placa;

  factory ModelPropietario.fromJson(Map<String, dynamic> json) =>
      ModelPropietario(
        idprop: json["id_prop"],
        modelovehi: json["modelo_vehi"],
        marcavehi: json["marca_vehi"],
      );

//  ModelPropietario.fromDocument(doc);

  Map<String, dynamic> toJson() => {
        "id_prop": idprop,
        "modelo_vehi": modelovehi,
        "marca_vehi": marcavehi,
      };
}
