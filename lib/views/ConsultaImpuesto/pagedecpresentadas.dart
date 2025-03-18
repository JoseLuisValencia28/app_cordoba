import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/modelo/soap_model_dec.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:app_cordoba/widget/widget_footer.dart';

void main() {
  runApp(MaterialApp());
}

//final GlobalKey<ScaffoldState> _formKeyDec = GlobalKey<ScaffoldState>();

class PageDecPresentada extends StatefulWidget {
  final String? placa;
  final List<SoapModelInfoVehi> infoVehi;
  const PageDecPresentada({this.placa, required this.infoVehi, Key? key})
    : super(key: key);

  @override
  _PageDecState createState() => _PageDecState();
}

late Future<List<SoapModelDec>> soapdec;
late List<SoapModelDec> listDec;

class _PageDecState extends State<PageDecPresentada> {
  final mapaProvider = SoapProvider();

  @override
  void initState() {
    super.initState();
    soapdec = mapaProvider.getSoapDeclaracion(widget.placa.toString());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final name = 'Declaraciones presentadas';
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade900,
      ),
      body: FutureBuilder(
        // widgetbody: FutureBuilder(
        future: soapdec,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<SoapModelDec>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Container(child: Center(child: CircularProgressIndicator()));
          } else {
            var data = snapshot.data;
            return Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        controller: ScrollController(keepScrollOffset: true),
                        children:
                            data!
                                .map(
                                  (item) => Container(
                                    margin: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: 8,
                                      top: 3,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Center(
                                        child: ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          children: <Widget>[
                                            Card(
                                              semanticContainer: true,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              elevation: 8,
                                              child: ClipPath(
                                                clipper: ShapeBorderClipper(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      left: BorderSide(
                                                        color:
                                                            Colors
                                                                .blue
                                                                .shade900,
                                                        width: 5,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          'Vigencia: ' +
                                                              item.vgncia
                                                                  .toString(),
                                                        ),
                                                        subtitle: Text(
                                                          'Tipo de declaración: ' +
                                                              item.crrcion
                                                                  .toString() +
                                                              '\n Pre-Impreso: ' +
                                                              item.nmroprimprso
                                                                  .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              10.0,
                                                            ),
                                                        child: Text(
                                                          'Banco: ' +
                                                              item.nmbrebnco
                                                                  .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    Footer(),
                  ],
                ),
              ),
            );
          }
        },
        // ),
      ),
    );
  }
}
