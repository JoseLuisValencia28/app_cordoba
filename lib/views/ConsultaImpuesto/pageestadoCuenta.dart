import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/modelo/model_index_icon.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:app_cordoba/widget/widget_footer.dart';
import 'package:app_cordoba/widget/widget_speed_dial.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PageEstadoCuenta extends StatefulWidget {
  final int? tipo;
  final String? path;
  final File? file;
  final String? nombre;
  final List<SoapModelInfoVehi>? infoVehi;

  const PageEstadoCuenta({
    this.tipo,
    this.infoVehi, // <-- Agregar required
    this.path,
    this.file, // <-- Agregar required
    this.nombre,
    Key? key,
  }) : super(key: key);

  @override
  _PageEstadState createState() => _PageEstadState();
}

class _PageEstadState extends State<PageEstadoCuenta> {
  final mapaProvider = SoapProvider();
  late PDFViewController controller;
  List<Botones> listbotones = [];
  int pages = 0;
  int indexPage = 0;
  @override
  void initState() {
    super.initState();
    listbotones = [Botones(texto: "Comparti")];
  }

  var childButtons;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final name = "hola";
    final text = '${indexPage + 1} de $pages';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
        title: Text(
          "Documento",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        actions:
            pages >= 2
                ? [
                  Center(
                    child: Text(text, style: TextStyle(color: Colors.white)),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 32),
                    onPressed: () {
                      final page = indexPage == 0 ? pages : indexPage - 1;
                      controller.setPage(page);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 32),
                    onPressed: () {
                      final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                      controller.setPage(page);
                    },
                  ),
                ]
                : null,
      ),
      body: Container(
        // widgetbody: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PDFView(
                filePath: widget.file!.path,
                autoSpacing: true,
                swipeHorizontal: true,
                pageSnap: true,
                pageFling: true,
                onRender: (pages) => setState(() => this.pages = pages!),
                onViewCreated:
                    (controller) =>
                        setState(() => this.controller = controller),
                onPageChanged:
                    (indexPage, _) =>
                        setState(() => this.indexPage = indexPage!),
              ),
            ),
            Footer(),
          ],
        ),
      ),
      // ),
      floatingActionButton: MySpeedDial(
        file: widget.file,
        secciones: listbotones,
      ),
    );
  }
}
