// ignore_for_file: sort_child_properties_last, avoid_unnecessary_containers, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls, override_on_non_overriding_member

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:app_cordoba/api/autocomplete_textfield.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/soap_model_marca.dart';
import 'package:app_cordoba/modelo/soap_model_propietario.dart';
import 'package:app_cordoba/modelo/soap_verifiation.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:app_cordoba/views/ConsultaImpuesto/consultaImpuestoIndex.dart';
import 'package:app_cordoba/views/Declaracion/declara_vehiculo.dart';
import 'package:app_cordoba/widget/widget_toast.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class ConsultaViewModel extends ChangeNotifier {
  SoapProvider mapaProvider = SoapProvider();
  Future<List<SoapModelo>>? soapModel;
  Future<List<SoapModelMarca>>? soapMarca;
  List<String> listaMarca = [];
  List<String> listaModelo = [];
  Future<List<SoapModelInfoVehi>>? soapInfoVehi;
  SoapModelInfoVehi soapModelInfoVehi = SoapModelInfoVehi();
  final TextEditingController controladorId = TextEditingController();
  late TextEditingController controladormodel = TextEditingController();
  final TextEditingController controladormarca = TextEditingController();
  FocusNode? focusNodeModel;
  // @override
  // void initState() {
  //   super.initState();
  //   focusNodeModel.addListener(() {
  //     if (!focusNodeModel.hasFocus) {
  //       controladormodel.clear(); // Limpia el campo cuando pierde el foco
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    focusNodeModel = FocusNode();

    focusNodeModel!.addListener(() {
      if (!focusNodeModel!.hasFocus) {
        controladormodel.clear(); // Limpia el campo cuando pierde el foco
      }
    });
    focusNodeModel
        ?.dispose(); // Verifica que el FocusNode no sea null antes de eliminarlo
    controladormodel.dispose();
  }

  String placa = "";
  // ignore: non_constant_identifier_names
  String id_consult = "";
  // ignore: non_constant_identifier_names
  String modelo_consult = "";
  // ignore: non_constant_identifier_names
  String marca_consult = "";
  var data;
  var data2;
  var dataInfo;
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  bool loading = true;
  String? selectedLetter;

  final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');
  final List<ModelPropietario> listProp2 = <ModelPropietario>[];
  bool autovalidate = false;

  List<String> added = [];

  final GlobalKey<AutoCompleteTextFieldState<String>> key1 = GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<String>> key2 = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BuildContext? showDialogContext;
  getMarcayModelo() {
    soapModel = mapaProvider.getSoap();
    soapMarca = mapaProvider.getSoapMarca();

    soapMarca?.then(
      (List<SoapModelMarca> value) => value.forEach((element) {
        listaMarca.add(element.marca.toString());
      }),
    );

    soapModel?.then(
      (List<SoapModelo> value) => value.forEach((element) {
        listaModelo.add(element.modelo.toString());
      }),
    );

    listaMarca.forEach((element) {
      print(element);
    });

    notifyListeners();
  }

  Future<void> onLoadingPage(context, placa, tipo) async {
    late BuildContext contextloading;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        contextloading = context;
        return Center(
          child:
              Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator(),
        );
      },
    );
    List<SoapModelInfoVehi> value = await mapaProvider.getSoapInfoVehiculo(
      placa,
    );
    if (value.isNotEmpty) {
      List<SoapInfoCartera> cartera = await mapaProvider.getInfoCartera(placa);
      Navigator.pop(contextloading);
      if (cartera.isNotEmpty) {
        id_consult = value[0].p_idntfccion_prptrios.toString();
        modelo_consult = value[0].p_mdlo.toString();
        marca_consult = value[0].p_dscrpcion_mrca.toString();

        final List<String> da = [];
        da.add(placa);
        da.add(controladorId.text);
        da.add(controladormodel.text);
        da.add(controladormarca.text);

        await load();
        if (id_consult != '0') {
          print(tipo);
          if (tipo == 0) {
            _showDialog(
              context,
              placa,
              da,
              dataInfo,
              id_consult,
              modelo_consult,
              marca_consult,
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => PageConsultaImpuesto(
                      placa: placa,
                      infoVehi: value,
                      infoCartera: cartera,
                    ),
              ),
            );
          }
        } else {
          print('No');
        }
      } else {
        MyToast().getDialog(mensaje: "Intente Mas Tarde");
      }
    } else {
      MyToast().getDialog(mensaje: "Intente Mas Tarde");
    }
  }

  Future<bool> load() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future _showDialog(
    context,
    String placa,
    da,
    dataInfo,
    idconsult,
    modeloConsult,
    marcaConsult,
  ) async {
    if (controladorId != null) {
      controladorId.text;
    }
    if (controladormarca != null) {
      controladormarca.text;
    }
    if (controladormodel != null) {
      controladormodel.text;
    }

    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        showDialogContext = context;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.zero,
                child: Form(
                  key: formKey3,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(child: Text('Verificación del Vehículo')),
                      Divider(),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controladorId,
                          decoration: InputDecoration(
                            labelText: 'Identificación',
                            hintText: 'Identificación',
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            controladorId.text = value;
                          },
                        ),
                      ),
                      Divider(),
                      SimpleAutoCompleteTextField(
                        key: key1,
                        keyboardType: TextInputType.text,
                        clearOnSubmit: false,
                        focusNode: focusNodeModel, // Asigna el FocusNode
                        controller: controladormodel,
                        decoration: InputDecoration(
                          // filled: true,
                          labelText: 'Modelo',
                          hintText: 'Modelo',
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),

                        suggestions: listaModelo,
                        textChanged: (text) {
                          controladormodel.text = text;
                        },
                        textSubmitted: (text) {
                          setState(() {
                            controladormodel.text = text;
                            listaModelo.clear();
                          });
                          FocusScope.of(context).unfocus();
                        },
                        submitOnSuggestionTap: true,
                      ),
                      Divider(),
                      SimpleAutoCompleteTextField(
                        key: key2,
                        keyboardType: TextInputType.text,
                        clearOnSubmit: false,
                        controller: controladormarca,
                        decoration: InputDecoration(
                          labelText: 'Marca',
                          hintText: 'Marca',
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),

                        suggestions: listaMarca,
                        textChanged: (text) {
                          setState(() {
                            controladormarca.text =
                                text.toUpperCase(); // Convierte a mayúsculas
                            // controladormarca
                            //     .selection = TextSelection.fromPosition(
                            //   TextPosition(
                            //     offset: controladormarca.text.length,
                            //   ),
                            // );
                          });
                        },
                        textSubmitted: (text) {
                          setState(() {
                            controladormarca.text =
                                text.toUpperCase(); // Convierte a mayúsculas
                            listaMarca.clear();
                          });
                          FocusScope.of(context).unfocus();
                        },
                        submitOnSuggestionTap: true,
                      ),

                      Divider(),
                      ElevatedButton(
                        onPressed: () {
                          if (controladorId.text == '' &&
                              controladormarca.text == '' &&
                              controladormodel.text == '') {
                            _asyncSimpleDialog(context, 1);
                          } else {
                            if (idconsult == controladorId.text &&
                                modeloConsult == controladormodel.text &&
                                marcaConsult == controladormarca.text) {
                              List<ModelPropietario> listProp2 = [];
                              listProp2.add(
                                ModelPropietario(
                                  placa: placa,
                                  idprop: controladorId.text,
                                  modelovehi: controladormodel.text,
                                  marcavehi: controladormarca.text,
                                ),
                              );
                              Navigator.pop(showDialogContext!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TabA(
                                        names: listProp2,
                                        idprop: controladorId.text,
                                      ),
                                ),
                              );
                            } else {
                              _asyncSimpleDialog(context, 2);
                            }
                          }
                        },
                        child: const Text(
                          'Buscar',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  //15035780
  Future _asyncSimpleDialog(BuildContext context, tipo) async {
    if (tipo == 1) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Campos vacios'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (tipo == 2) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('La Información no coincide'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
