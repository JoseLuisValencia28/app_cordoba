// ignore_for_file: prefer_interpolation_to_compose_strings, sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/pdf_api.dart';
import 'package:app_cordoba/modelo/soap_model_convenio_detalle.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/modelo/soap_model_recibo_pago_convenio.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/views/ConsultaImpuesto/pageestadoCuenta.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_footer.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/soap_model_recibo_pago.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(PageReciboConvenio());
}

final oCcy = NumberFormat("#,##0", "en_US");
final formatCurrency = NumberFormat.simpleCurrency();

class PageReciboConvenio extends StatefulWidget {
  final String? placa;
  final List<SoapModelInfoVehi>? infoVehi;
  final List<SoapInfoCartera>? infoCartera;
  const PageReciboConvenio({
    this.placa,
    this.infoVehi,
    this.infoCartera,
    Key? key,
  }) : super(key: key);

  @override
  _PageReciboConvenioState createState() => _PageReciboConvenioState();
}

late Future<List<SoapModelConvenio>> soapConvenio;
late Future<List<SoapModelConvenioDetalle>> soapConvenioDetalle;
late List<SoapModelRecibo> listRecibo;
List<String> listVigencia = [];
List<String> listEstados = [];
var childButtons;

class _PageReciboConvenioState extends State<PageReciboConvenio> {
  final mapaProvider = SoapProvider();

  @override
  void initState() {
    super.initState();
    soapConvenio = mapaProvider.getSoapConvenio(widget.placa!);
  }

  var data;
  var getConvenio;
  String vigencia = '';
  static int _len = 0;
  var _valorconvenio;
  void getVigencia() {
    vigencia = '';
    if (listVigencia.isEmpty) {
    } else {
      for (int i = 0; i < listVigencia.length; i++) {
        vigencia = vigencia + (",") + listVigencia[i];
      }
      vigencia = vigencia.substring(1);
    }
  }

  Future<Future<List<SoapModelConvenioDetalle>>> fetchUserOrder() async {
    soapConvenioDetalle = mapaProvider.getSoapConvenioDetalle(
      widget.placa!,
      _valorconvenio,
    );
    return soapConvenioDetalle;
  }

  List<bool> isChecked = List.generate(_len, (index) => false);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final name = 'Convenio de pago';
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
      ),
      body: FutureBuilder(
        // widgetbody: FutureBuilder(
        future: soapConvenio,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<SoapModelConvenio>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container(child: Center(child: CircularProgressIndicator()));
          } else {
            var data = snapshot.data;
            _valorconvenio = data![0].numeroconvenio;
            if (data[0].estadoconvenio == '0') {
              return Column(
                children: [
                  Expanded(
                    child: Center(child: Text('No tiene convenio activo')),
                  ),
                  Footer(),
                ],
              );
            } else {
              fetchUserOrder();
              return FutureBuilder(
                future: soapConvenioDetalle,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<SoapModelConvenioDetalle>> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return Container(child: MyCircularProgress());
                  } else {
                    getConvenio = snapshot.data;

                    _len = getConvenio.length;
                    listEstados = [];
                    for (int i = 0; i < getConvenio.length; i++) {
                      listEstados.add(getConvenio[i].estadoconvenio);
                    }

                    return Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                controller: ScrollController(
                                  keepScrollOffset: true,
                                ),
                                itemCount: getConvenio.length,
                                itemBuilder: (context, index) {
                                  if (isChecked.isEmpty) {
                                    isChecked = List.generate(
                                      _len,
                                      (index) => false,
                                    );
                                  }

                                  return Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 8,
                                    child: ClipPath(
                                      clipper: ShapeBorderClipper(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
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
                                            ListTile(
                                              subtitle: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(1),
                                                    child: Text(
                                                      'Cuota: ' +
                                                          getConvenio[index]
                                                              .numerocuota +
                                                          '\nValor cuota convenio: ' +
                                                          oCcy.format(
                                                            int.parse(
                                                              getConvenio[index]
                                                                  .valorcuota,
                                                            ),
                                                          ) +
                                                          '\nFecha cuota convenio: ' +
                                                          getConvenio[index]
                                                              .fechavenceconvenio +
                                                          '\nEstado cuota convenio: ' +
                                                          getConvenio[index]
                                                              .estadoconvenio,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (getConvenio[index]
                                                                .estadoconvenio !=
                                                            'PAGADA') {
                                                          final url =
                                                              Url_CONV +
                                                              'Placa=' +
                                                              widget.placa! +
                                                              '&NDif=' +
                                                              _valorconvenio +
                                                              '&Cuota=' +
                                                              getConvenio[index]
                                                                  .numerocuota +
                                                              '&operacion=A';
                                                          print(url);

                                                          String nombrearchivo =
                                                              'Recibo_de_pago_convenio' +
                                                              widget.placa! +
                                                              '.pdf';

                                                          final file =
                                                              await PDFApi.loadNetwork(
                                                                url: url,
                                                                filename:
                                                                    nombrearchivo,
                                                              );

                                                          if (file != null) {
                                                            openPDF(
                                                              context,
                                                              file,
                                                            );
                                                          } else {
                                                            Fluttertoast.showToast(
                                                              msg:
                                                                  "No se pudo cargar el archivo PDF",
                                                              toastLength:
                                                                  Toast
                                                                      .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0,
                                                            );
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                            msg:
                                                                "Esta cuota ya está pagada",
                                                            toastLength:
                                                                Toast
                                                                    .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0,
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        'Imprimir',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255,
                                                          ),
                                                        ),
                                                      ),
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .blue
                                                                    .shade900,
                                                            textStyle:
                                                                TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                ],
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
                      ),
                    );
                  }
                },
              );
            }
          }
        },
      ),
    );
  }
}

void openPDF(BuildContext context, File file) => Navigator.of(
  context,
).push(MaterialPageRoute(builder: (context) => PageEstadoCuenta(file: file)));
