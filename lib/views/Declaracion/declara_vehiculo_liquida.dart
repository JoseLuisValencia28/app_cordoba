// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/modelo/soap_model_detalleLiquida.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/soap_model_infoVig.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_footer.dart';
import 'package:intl/intl.dart';
import 'declara_vehiculo_declarante.dart';

class TabB extends StatefulWidget {
  final String? placa, vigencia, identificacion, fecha, result;
  final List<SoapModelInfoVehi> dataInfVeh;
  const TabB({
    this.placa,
    this.vigencia,
    this.identificacion,
    this.fecha,
    this.result,
    required this.dataInfVeh,
    Key? key,
  }) : super(key: key);
  @override
  ScreenDeclaraVehiculoLiquida createState() => ScreenDeclaraVehiculoLiquida();
}

late Future<List<SoapModelInfoVig>> soapInfoVig;

// ignore: must_be_immutable
class ScreenDeclaraVehiculoLiquida extends State<TabB> {
  get child => null;
  final mapaProvider = SoapProvider();
  late Future<List<SoapDetalleLiquida>> soapFechaLiquida;
  late Future<List<SoapInfoCartera>> soapCartera;
  final GlobalKey<ScaffoldState> _formKey2 = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    soapFechaLiquida = mapaProvider.getSoapInfoDetalleLiqudia(
      widget.placa!,
      widget.vigencia,
      widget.fecha,
      widget.identificacion,
    );
    soapCartera = mapaProvider.getInfoCartera(widget.placa!);
  }

  var dataCartera;
  bool enable = false;
  NumberFormat oCcy = NumberFormat("#,##0", "en_US");

  late List<DropdownMenuItem<String>> dropdownMenuOptionsvigencia;
  @override
  Widget build(BuildContext ctx) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      // widgetbody: Scaffold(
      appBar: AppBar(
        title: Text(
          'Paso 3 Liquidación ' + widget.vigencia!,
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      key: _formKey2,
      body: FutureBuilder(
        future: Future.wait([soapCartera, soapFechaLiquida]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Container(child: MyCircularProgress());
          } else {
            dataCartera = snapshot.data[0];
            var data = snapshot.data[1];
            List<Elementos> itemElementos = [];
            String str = data[0].detalleliquidacion;
            List<String> parts = str.split("~");

            int cont = 0;
            String items;
            String desCripcion;
            String valor;
            while (cont < parts.length) {
              items = parts[cont];
              cont++;
              desCripcion = parts[cont];
              cont++;
              valor = parts[cont];
              cont++;
              itemElementos.add(
                Elementos(item: items, desc: desCripcion, vlor: valor),
              );
            }
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.only(left: 16, right: 16, top: 6),
                        child: DataTable(
                          horizontalMargin: 30,
                          columnSpacing: 5,
                          columns: [
                            DataColumn(
                              label: Text(
                                '#',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Descripción',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              numeric: true,
                              label: Text(
                                'Valor',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                          rows:
                              itemElementos
                                  .map(
                                    ((element) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Container(
                                            width: 100 * .2,
                                            child: Text(
                                              element.item!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            width: 900 * .2,
                                            child: Text(
                                              element.desc!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            oCcy.format(
                                              int.parse(element.vlor!),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text(
                            'Está de acuerdo con la información?',
                          ),
                          value: enable,
                          onChanged: (value) {
                            setState(() {
                              enable = value;
                            });
                          },
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
                          onPressed: () async {
                            if (!enable == false) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TabC(
                                        data: data,
                                        placa: widget.placa!,
                                        infoVeh: widget.dataInfVeh,
                                        cartera: dataCartera,
                                        vigencia: widget.vigencia!,
                                        fechalimite: widget.fecha!,
                                        itemElementos: itemElementos,
                                      ),
                                ),
                              );
                            }
                            if (enable == false) {
                              return showDialog<void>(
                                context: ctx,
                                builder: (BuildContext ctx2) {
                                  return AlertDialog(
                                    content: StatefulBuilder(
                                      builder: (
                                        BuildContext context,
                                        StateSetter setState,
                                      ) {
                                        return ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            Card(
                                              elevation: 0.0,
                                              child: Text(
                                                'Información importante!',
                                              ),
                                            ),
                                            Divider(),
                                            Card(
                                              elevation: 0.0,
                                              child: Text(dialog),
                                            ),
                                            Divider(),
                                            ElevatedButton(
                                              child: const Text(
                                                'Continuar',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                    255,
                                                    255,
                                                    255,
                                                    255,
                                                  ),
                                                ),
                                              ),
                                              onPressed:
                                                  () => Navigator.pop(ctx2),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Footer(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class Elementos {
  Elementos({this.item, this.desc, this.vlor});
  String? item;
  String? desc;
  String? vlor;
}
