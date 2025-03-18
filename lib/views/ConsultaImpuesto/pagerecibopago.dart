// ignore_for_file: prefer_interpolation_to_compose_strings, sort_child_properties_last

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/pdf_api.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/views/ConsultaImpuesto/pageestadoCuenta.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_footer.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/soap_model_recibo_pago.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp());
}

final oCcy = NumberFormat("#,##0", "en_US");
final formatCurrency = NumberFormat.simpleCurrency();

class PageRecibo extends StatefulWidget {
  final String? placa;
  final List<SoapModelInfoVehi> infoVehi;
  final List<SoapInfoCartera> infoCartera;
  const PageRecibo({
    this.placa,
    required this.infoVehi,
    required this.infoCartera,
    Key? key,
  }) : super(key: key);

  @override
  _PageReciboState createState() => _PageReciboState();
}

late Future<List<SoapModelRecibo>> soapRecibo;
late List<SoapModelRecibo> listRecibo;
List<String> listVigencia = [];
var childButtons;

class _PageReciboState extends State<PageRecibo> {
  final mapaProvider = SoapProvider();

  @override
  void initState() {
    super.initState();
    soapRecibo = mapaProvider.getReciboDepago(widget.placa!);
  }

  var isDialOpen = ValueNotifier<bool>(false);
  var customDialRoot = false; //Boton rectangular (true) - Circular (false)
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var extend = false;
  var visible = true;
  var speedDialDirection = SpeedDialDirection.up;
  var switchLabelPosition = false;
  var closeManually = false;
  var renderOverlay = true;
  var useRAnimation = true;
  var rmicons = false;

  //List<bool> _length = [];
  //List<bool> checkBoxValue = List<bool>.filled(_length.length, false);

  List<SoapModelRecibo> data = [];
  String vigencia = '';
  static int _len = 0;

  void getVigencia() {
    vigencia = '';
    if (listVigencia.isEmpty) {
      print('Lista vacia');
    } else {
      for (int i = 0; i < listVigencia.length; i++) {
        vigencia = vigencia + (",") + listVigencia[i];
      }
      vigencia = vigencia.substring(1);
      print('Vigencias: ' + vigencia);
    }
  }

  Future<bool> load() async {
    getVigencia();
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<void> _onLoadingPage(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child:
              Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator(),
        );
      },
    );
    await load();

    final url2 =
        Url_Global_REC +
        'p_placa=' +
        widget.placa.toString() +
        '&p_marca=' +
        widget.infoCartera[0].mrca.toString() +
        '&p_linea=' +
        widget.infoCartera[0].lnea.toString() +
        '&p_cilindraje=' +
        widget.infoCartera[0].clndrje.toString() +
        '&p_cap_Carga=' +
        widget.infoCartera[0].cpcdadcrgas.toString() +
        '&p_cap_Pasajeros=' +
        widget.infoCartera[0].cpcdadpsjros.toString() +
        '&p_tipo_Carroceria=' +
        widget.infoCartera[0].tpocrrcria.toString() +
        '&p_modelo=' +
        widget.infoCartera[0].mdlo.toString() +
        '&p_clase=' +
        widget.infoCartera[0].clse.toString() +
        '&p_blindaje=' +
        widget.infoCartera[0].blndje.toString() +
        '&p_municipio=' +
        widget.infoCartera[0].mncpio.toString() +
        '&p_dpto=' +
        widget.infoCartera[0].dprtmnto.toString() +
        '&ValCeckBox=' +
        vigencia;
    print(url2);
    String nombrearchivo = 'Recibo_de_pago ${widget.placa}.pdf';
    final file = await PDFApi.loadNetwork(url: url2, filename: nombrearchivo);
    Navigator.pop(context);
    openPDF(context, file!, 'Recibo de pago', widget.infoVehi);
  }

  List<bool> isChecked = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    botones();
    print(widget.placa);
    final name = 'Recibo de pago';
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
      ),
      body: FutureBuilder(
        // widgetbody: FutureBuilder(
        future: soapRecibo,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<SoapModelRecibo>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container(child: MyCircularProgress());
          } else {
            data = snapshot.data!;
            _len = data.length;
            if (isChecked.isEmpty) {
              isChecked = List.generate(_len, (index) => false);
            }

            if (data[0].numeroFactura == '0') {
              return Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(child: Text('No posee recibo de pago')),
                    ),
                    Footer(),
                  ],
                ),
              );
            } else {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        controller: ScrollController(keepScrollOffset: true),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          /*if (isChecked.isEmpty) {
                            isChecked = List.generate(_len, (index) => false);
                          }*/
                          return Card(
                            margin: EdgeInsets.only(left: 8, right: 8, top: 6),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 8,
                            child: ClipPath(
                              clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.blue.shade900,
                                      width: 5,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor:
                                            Colors.blue.shade900,
                                      ),
                                      child: CheckboxListTile(
                                        autofocus: true,
                                        activeColor: Colors.blue,
                                        checkColor: Colors.white,
                                        dense: true,
                                        title: Text(
                                          'Vigencia: ' +
                                              data[index].vigencia.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        secondary: Icon(Icons.fact_check),
                                        value: isChecked[index],
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            isChecked[index] =
                                                newValue ??
                                                false; // Manejar el valor nulo
                                            print(isChecked[index]);

                                            if (!isChecked[index]) {
                                              listVigencia.remove(
                                                data[index].vigencia! + "011",
                                              );
                                            } else {
                                              listVigencia.clear();
                                              for (
                                                int i = 0;
                                                i < isChecked.length;
                                                i++
                                              ) {
                                                if (isChecked[i]) {
                                                  listVigencia.add(
                                                    data[i].vigencia! + "011",
                                                  );
                                                }
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      subtitle: Text(
                                        'Capital: ' +
                                            oCcy.format(
                                              int.parse(
                                                data[index].capital.toString(),
                                              ),
                                            ) +
                                            '\nFactura: ' +
                                            data[index].numeroFactura
                                                .toString() +
                                            '\nTotal: ' +
                                            oCcy.format(
                                              int.parse(
                                                data[index].total.toString(),
                                              ),
                                            ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: 2,
                                          height: 1.7,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Footer(),
                  ],
                ),
              );
            }
          }
        },
      ),
      floatingActionButton:
          isChecked.contains(true)
              ? SpeedDial(
                backgroundColor: Colors.blue.shade900,
                child: Icon(Icons.menu, color: Colors.white, size: 25.0),
                activeIcon: Icons.close,
                foregroundColor: Colors.white,
                spacing: 2,
                openCloseDial: isDialOpen,
                childPadding: const EdgeInsets.all(5),
                spaceBetweenChildren: 4,
                buttonSize: buttonSize,
                label: extend ? const Text("Abrir") : null,
                activeLabel: extend ? const Text("Cerrar") : null,
                childrenButtonSize: childrenButtonSize,
                visible: visible,
                direction: speedDialDirection,
                switchLabelPosition: switchLabelPosition,
                closeManually: closeManually,
                renderOverlay: renderOverlay,
                onOpen: () => debugPrint('ABRIR MENU'),
                onClose: () => debugPrint('CERRAR MENU'),
                useRotationAnimation: useRAnimation,
                tooltip: 'Menu de opciones',
                heroTag: 'speed-dial-hero-tag',
                elevation: 8.0,
                isOpenOnStart: false,
                shape:
                    customDialRoot
                        ? const RoundedRectangleBorder()
                        : const StadiumBorder(),
                children: [
                  isChecked.contains(true)
                      ? SpeedDialChild(
                        child: const Icon(Icons.checklist_outlined),
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        label: 'MARCAR TODOS',
                        onTap:
                            () => {
                              setState(() {
                                listVigencia = [];
                                if (isChecked.first == true) {
                                  isChecked = List.generate(
                                    data.length,
                                    (index) => false,
                                  );
                                  listVigencia.add('');
                                  getVigencia();
                                } else {
                                  isChecked = List.generate(
                                    data.length,
                                    (index) => true,
                                  );
                                  for (int i = 0; i < isChecked.length; i++) {
                                    if (isChecked[i] == true) {
                                      listVigencia.add(
                                        data[i].vigencia! + "011",
                                      );
                                    }
                                  }
                                  getVigencia();
                                }
                              }),
                            },
                      )
                      : SpeedDialChild(visible: false),
                  isChecked.contains(true)
                      ? SpeedDialChild(
                        child: const Icon(Icons.print),
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        label: 'IMPRIMIR',
                        onTap: () => {_onLoadingPage(context)},
                      )
                      : SpeedDialChild(visible: false),
                ],
              )
              : SizedBox(),
    );
  }

  void botones() {
    // ignore: deprecated_member_use
    // childButtons = List<UnicornButton>();
    // childButtons.add(UnicornButton(
    //     hasLabel: true,
    //     labelText: "Marcar todos",
    //     currentButton: FloatingActionButton(
    //       heroTag: "Marcar todos",
    //       backgroundColor: Colors.blue.shade900,
    //       mini: true,
    //       child: Icon(Icons.check),
    //       onPressed: () {
    //         setState(() {
    //           listVigencia = [];
    //           if (isChecked.first == true) {
    //             isChecked = List.generate(data.length, (index) => false);
    //             listVigencia.add('');
    //             getVigencia();
    //           } else {
    //             isChecked = List.generate(data.length, (index) => true);
    //             for (int i = 0; i < isChecked.length; i++) {
    //               if (isChecked[i] == true) {
    //                 listVigencia.add(data[i].vigencia + "011");
    //               }
    //             }
    //             getVigencia();
    //           }
    //         });
    //       },
    //     )));
    // if (isChecked.contains(true)) {
    //   childButtons.add(UnicornButton(
    //       hasLabel: true,
    //       labelText: "Imprimir",
    //       currentButton: FloatingActionButton(
    //         heroTag: "Imprimir",
    //         backgroundColor: Colors.blue.shade900,
    //         mini: true,
    //         child: Icon(Icons.local_print_shop_outlined),
    //         onPressed: () async {
    //           _onLoadingPage(context);
    //         },
    //       )));
    // }
  }
}

void openPDF(
  BuildContext context,
  File file,
  String nombre,
  List<SoapModelInfoVehi> infoVehi,
) => Navigator.of(context).push(
  MaterialPageRoute(
    builder:
        (context) =>
            PageEstadoCuenta(file: file, nombre: nombre, infoVehi: infoVehi),
  ),
);
