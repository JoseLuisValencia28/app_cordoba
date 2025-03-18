// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/modelo/model_index_icons.dart';
import 'package:app_cordoba/modelo/soap_model_fecha_liquida.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/soap_model_infoVig.dart';
import 'package:app_cordoba/modelo/soap_model_propietario.dart';

import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/views/Declaracion/declara_vehiculo_liquida.dart';

import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_footer.dart';

class TabA extends StatefulWidget {
  final List<ModelPropietario> names;
  final String? idprop;
  const TabA({required this.names, this.idprop, Key? key}) : super(key: key);
  @override
  ScreenDeclaraVehiculo createState() => ScreenDeclaraVehiculo();
}

late Future<List<SoapModelInfoVig>> soapInfoVig;
final people2 = <String>[];
final List<SoapModelInfoVig> vigencia = [];
late List<SoapModelInfoVig> dataVig;

final mapaProvider = SoapProvider();
String? placa;

String? result;
String? identificacion;
var data;
String vigencias = "Seleccione";
bool enable = false;
bool _isVisible = false;
String? _fecha;

class ScreenDeclaraVehiculo extends State<TabA> {
  get child => null;

  late Future<List<SoapModelInfoVehi>> soapInfoVehi;

  final List<SoapModelInfoVehi> itemsListInfoVehi = [];
  final GlobalKey<ScaffoldState> _formKey2 = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    soapInfoVehi = mapaProvider.getSoapInfoVehiculo(widget.names[0].placa!);
    soapInfoVig = mapaProvider.getSoapInfoVigenciaValida(
      widget.names[0].placa!,
    );
  }

  late List<DropdownMenuItem<String>> dropdownMenuOptionsvigencia;
  late BuildContext contextDialog;

  Future _createList(BuildContext context, data) async {
    if (people2.isEmpty) {
      for (var i = 0; i < data.length; i++) {
        people2.add(data[i].p_dscrpcion_mrca);
        people2.add(data[i].p_dscrpcion_lnea);
        people2.add(data[i].p_mdlo);
        people2.add(data[i].p_dscrpcion_clse);
        people2.add(data[i].p_dscrpcion_crrcria);
        people2.add(data[i].p_dscripcion_blndje);
        people2.add(data[i].p_clndrje);
        people2.add(data[i].p_cpcdad_psjros);
        people2.add(data[i].p_cpcdad_crga);
      }
    }

    dropdownMenuOptionsvigencia =
        dataVig
            .map(
              (dataVig) => DropdownMenuItem<String>(
                value: dataVig.vigencia,
                child: Text(dataVig.vigencia!),
              ),
            )
            .toList();
  }

  late BuildContext dialogContextBody;
  @override
  Widget build(BuildContext ctx) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    placa = widget.names[0].placa;
    identificacion = widget.idprop;
    dialogContextBody = context;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(dialogContextBody),
        ),
        title: const Text(
          'Paso 2 Vehículo',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      key: _formKey2,
      body: Container(
        // widgetbody: Container(
        child: FutureBuilder(
          future: Future.wait([soapInfoVehi, soapInfoVig]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return MyCircularProgress();
            } else {
              data = snapshot.data[0];
              dataVig = snapshot.data[1];
              _createList(context, data);

              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: people2.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 6,
                            ),
                            child: ListTile(
                              title: Text(
                                titulos[index],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                people2[index],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        dialogo(context);
                      },
                    ),
                    Footer(),
                  ],
                ),
              );
            }
          },
        ),
        // ),
      ),
    );
  }

  dialogo(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext contextDialog) {
        contextDialog = contextDialog;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.zero,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Card(
                      child: SwitchListTile(
                        title: const Text(
                          'Está de acuerdo con la información?',
                        ),
                        value: enable,
                        onChanged: (value) {
                          setState(() {
                            enable = value;
                            if (!enable == false) {
                              _isVisible = true;
                            } else {
                              _isVisible = false;
                            }
                          });
                        },
                      ),
                    ),
                    Divider(),
                    Visibility(
                      visible: _isVisible,
                      child: Container(
                        height: 40.0,
                        child: DropdownButtonFormField<String>(
                          value: vigencias,
                          itemHeight: 50.0,
                          iconSize: 0,
                          elevation: 0,
                          isExpanded: true,
                          isDense: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(
                              gapPadding: 1,
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            labelText: 'Vigencia a declarar',
                            labelStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.black,
                            hoverColor: Colors.black,
                          ),
                          onChanged: (String? newValue) {
                            vigencias = newValue!;
                            setState(() {
                              vigencias = newValue;
                            });
                          },
                          items: dropdownMenuOptionsvigencia,
                        ),
                      ),
                    ),
                    Divider(),
                    ElevatedButton(
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        declararVehiculo(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> declararVehiculo(context) async {
    //1068660499
    //MGX155
    //2013
    //MAZDA

    switch (enable && _isVisible) {
      case true:
        if (vigencias != 'Seleccione') {
          if (vigencias != 'Sin vigencia a liquidar') {
            List<SoapFechaLiquida> value = await mapaProvider
                .getSoapFechaLiquida(placa!, vigencias);
            _fecha = value[0].p_fcha_lmte;
            result = value[0].result;
            if (value.isNotEmpty) {
              if (_fecha == '0' || result == '0') {
                showdialog(context, liquiValida);
              } else {
                Navigator.pop(context);
                openPage(context);
              }
            } else {
              Navigator.pop(context);
              showdialog(context, 'Debe Seleccionar una Vigencia Válida');
            }
          } else {
            Navigator.pop(context);
            showdialog(context, 'Debe Seleccionar una Vigencia Válida');
          }
        } else {
          Navigator.pop(context);
          showdialog(context, 'Debe Seleccionar una Vigencia Válida');
        }
        break;
      case false:
        Navigator.pop(context);
        showdialog(context, '');
        break;
    }
  }

  void openPage(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (context) => TabB(
            dataInfVeh: data,
            placa: placa,
            vigencia: vigencias,
            identificacion: identificacion,
            fecha: _fecha,
            result: result,
          ),
    ),
  );
  Future<void> showdialog(BuildContext contextS, String val) async {
    showDialog<void>(
      context: contextS,
      builder: (BuildContext contextDialog2) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext contextDialog2, StateSetter setState) {
              return Container(
                width: MediaQuery.of(contextS).size.width,
                margin: EdgeInsets.zero,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Card(
                      elevation: 0.0,
                      child: Text('Información importante!'),
                    ),
                    Divider(),
                    Card(elevation: 0.0, child: Text(val)),
                    Divider(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      onPressed: () => Navigator.pop(contextDialog2),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
