// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/pdf_api.dart';
import 'package:app_cordoba/api/permisos.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/model_index_icons.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/views/ConsultaImpuesto/pageestadoCuenta.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_footer.dart';
import 'package:app_cordoba/widget/widget_toast.dart';

import 'pagedecpresentadas.dart';
import 'pagerecibopago.dart';
import 'pagerecibopagoConvenio.dart';

void main() {
  runApp(MaterialApp());
}

class PageConsultaImpuesto extends StatefulWidget {
  final int? tipo;
  final String? placa;
  final List<SoapModelInfoVehi> infoVehi;
  final List<SoapInfoCartera> infoCartera;
  const PageConsultaImpuesto({
    this.tipo,
    required this.infoVehi,
    this.placa,
    required this.infoCartera,
    Key? key,
  }) : super(key: key);

  @override
  _PageImpuestoState createState() => _PageImpuestoState();
}

class _PageImpuestoState extends State<PageConsultaImpuesto> {
  final mapaProvider = SoapProvider();
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";

  File? file;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> load() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<void> _onLoadingPage(context, title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyCircularProgress();
      },
    );
    if (Platform.isAndroid) {
      if (await ApiPermisos.requestWritePermission()) {
        await load();
        if (title == 'Ver Estado de Cuenta') {
          String nombrearchivo =
              'Estado_cuenta_' + widget.placa.toString() + '.pdf';
          final url = Url_EST + 'txt_NumPlaca=' + widget.placa.toString() + '';
          print(url);
          file = await PDFApi.loadNetwork(url: url, filename: nombrearchivo);

          if (mounted) {
            Navigator.pop(context);
          }

          if (file != null) {
            openPDF(context, file!, 'Estado de cuenta');
          } else {
            MyToast().getDialog(mensaje: "No se pudo descargar el archivo");
          }
        }

        if (title == 'Declaraciones Presentadas') {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PageDecPresentada(
                    placa: widget.placa.toString(),
                    infoVehi: widget.infoVehi,
                  ),
            ),
          );
        }
        if (title == 'Generar Recibo de Pago') {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PageRecibo(
                    placa: widget.placa.toString(),
                    infoVehi: widget.infoVehi,
                    infoCartera: widget.infoCartera,
                  ),
            ),
          );
        }
        if (title == 'Genera Recibo de Pago Convenio') {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PageReciboConvenio(
                    placa: widget.placa.toString(),
                    infoVehi: widget.infoVehi,
                    infoCartera: widget.infoCartera,
                  ),
            ),
          );
        }
      }
    } else {
      await load();
      if (title == 'Ver Estado de Cuenta') {
        String nombrearchivo =
            'Estado_cuenta_' + widget.placa.toString() + '.pdf';
        final url = Url_EST + 'txt_NumPlaca=' + widget.placa.toString() + '';
        print(url);
        file = await PDFApi.loadNetwork(url: url, filename: nombrearchivo);
        Navigator.pop(context);
        openPDF(context, file!, 'Estado de cuenta');
      }
      if (title == 'Declaraciones Presentadas') {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PageDecPresentada(
                  placa: widget.placa.toString(),
                  infoVehi: widget.infoVehi,
                ),
          ),
        );
      }
      if (title == 'Generar Recibo de Pago') {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PageRecibo(
                  placa: widget.placa.toString(),
                  infoVehi: widget.infoVehi,
                  infoCartera: widget.infoCartera,
                ),
          ),
        );
      }
      if (title == 'Genera Recibo de Pago Convenio') {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PageReciboConvenio(
                  placa: widget.placa.toString(),
                  infoVehi: widget.infoVehi,
                  infoCartera: widget.infoCartera,
                ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta Impuesto', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Column(
        // widgetbody: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                final item = itemList[index];
                return GestureDetector(
                  onTap: () => _onLoadingPage(context, item.title),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Image.asset(item.icon, fit: BoxFit.fill),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Footer(),
        ],
        // ),
      ),
    );
  }
}

void openPDF(BuildContext context, File file, String nombre) => Navigator.of(
  context,
).push(
  MaterialPageRoute(
    builder:
        (context) => PageEstadoCuenta(file: file, nombre: nombre, infoVehi: []),
  ),
);
