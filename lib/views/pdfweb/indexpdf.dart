import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/pdf_api.dart';
import 'package:app_cordoba/modelo/model_index_icons.dart';
import 'package:app_cordoba/views/ConsultaImpuesto/pageestadoCuenta.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_footer.dart';

void main() => runApp(Tab_F());

// ignore: camel_case_types
class Tab_F extends StatefulWidget {
  final String? data;
  final List<dynamic>? itemsPdf;
  const Tab_F({
    this.data,
    this.itemsPdf,
    Key? key,
  }) : super(key: key);
  @override
  Pdfweb createState() => Pdfweb();
}

//List<UnicornButton> childButtons = [];

// ignore: must_be_immutable
class Pdfweb extends State<Tab_F> {
  @override
  void initState() {
    super.initState();
    _botones();
  }

  File? file;

  @override
  Widget build(BuildContext ctx) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    String titulo = widget.data!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Normatividad para $titulo',
          maxLines: 2,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.itemsPdf!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: InkWell(
                        child: Card(
                          margin: const EdgeInsets.all(15),
                          child: ListTile(
                            title: Text(widget.itemsPdf![index].nombreText,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                        onTap: () => _onLoadingPage(ctx, itemsPdf[index].url,
                            widget.itemsPdf![index].nombreText),
                      ),
                    );
                  }),
            ),
            Footer()
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          // UnicornDialer(
          //     backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          //     parentButtonBackground: Colors.blue.shade900,
          //     orientation: UnicornOrientation.VERTICAL,
          //     parentButton: Icon(Icons.menu),
          //     childButtons: childButtons),
        ],
      ),
    );
  }

  void openPDF(BuildContext context, File file, String nombre) =>
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => PageEstadoCuenta(
                  file: file,
                  nombre: nombre,
                  infoVehi: [],
                )),
      );

  void _botones() {
    // childButtons = [];
    // childButtons.add(UnicornButton(
    //     hasLabel: true,
    //     labelText: "Inicio",
    //     currentButton: FloatingActionButton(
    //       heroTag: "Inicio",
    //       backgroundColor: Colors.blue.shade900,
    //       mini: true,
    //       child: Icon(Icons.home),
    //       onPressed: () {
    //         Navigator.of(context).pushAndRemoveUntil(
    //             MaterialPageRoute(builder: (context) => SecondScreen()),
    //             (Route<dynamic> route) => false);
    //       },
    //     )));
  }

  Future<void> _onLoadingPage(ctx, url, nombretext) async {
    late BuildContext contextloading;
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        contextloading = context;
        return MyCircularProgress();
      },
    );
    file = await PDFApi.loadNetwork(url: url, filename: nombretext + '.pdf');
    Navigator.pop(contextloading);
    if (file != null) {
      openPDF(ctx, file!, nombretext);
    }
  }

  Future<bool> load() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
