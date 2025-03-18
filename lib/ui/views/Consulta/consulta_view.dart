// ignore_for_file: unnecessary_null_comparison

import 'package:app_cordoba/api/upercase.dart';
import 'package:app_cordoba/modelo/model_index_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/ui/views/Consulta/consulta_viewmodel.dart';
import 'package:app_cordoba/widget/widget_footer.dart';
import 'package:app_cordoba/widget/widget_speed_dial.dart';
import 'package:stacked/stacked.dart';

void main() => runApp(PortalCordoba(tipo: 0));

class PortalCordoba extends StatelessWidget {
  final int? tipo;
  const PortalCordoba({this.tipo, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Informatica y Tributos',
      home: SoapPage(tipo: tipo),
    );
  }
}

class SoapPage extends StatefulWidget {
  final int? tipo;
  final BuildContext? contextsheet;
  const SoapPage({this.tipo, this.contextsheet, Key? key}) : super(key: key);

  @override
  _SoapPageState createState() => _SoapPageState();
}

class _SoapPageState extends State<SoapPage> {
  List<Botones> secciones = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      // widgetbody: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('CONSULTA', style: TextStyle(color: Colors.white)),
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
        backgroundColor: Colors.blue.shade900,
      ),
      body: ViewModelBuilder<ConsultaViewModel>.reactive(
        onModelReady: (model) {
          model.getMarcayModelo();
        },
        viewModelBuilder: () => ConsultaViewModel(),
        builder: (context, model, child) {
          return Container(
            color: Colors.white,
            child: Form(
              key: model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              elevation: 0.0,
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 0),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Image.asset(
                                "assets/images/escudo.jpg",
                                scale: 5,
                              ),
                            ),
                            Card(
                              elevation: 0.0,
                              margin: EdgeInsets.fromLTRB(26, 0, 26, 16),
                              color: Colors.white,
                              child: Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/plaque.png',
                                    ),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                padding: EdgeInsets.all(30),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            inputFormatters: [
                                              UpperCaseTextFormatter(),
                                            ],
                                            textAlign: TextAlign.center,
                                            maxLength: 6,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              height: 2.0,
                                              color: Colors.black,
                                            ),
                                            decoration: const InputDecoration(
                                              hintText: 'ABC123',
                                              isDense: true,
                                            ),
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                print('False');
                                                return 'Debe digitar la placa';
                                              }
                                              model.placa = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (model.formKey.currentState!.validate()) {
                                    model.onLoadingPage(
                                      context,
                                      model.placa,
                                      widget.tipo,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade900,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text(
                                  'Buscar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Footer(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: MySpeedDial(secciones: secciones),
    );
  }
}
