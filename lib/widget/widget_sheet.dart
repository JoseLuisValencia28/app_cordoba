import 'package:flutter/material.dart';
import 'package:app_cordoba/modelo/banner.dart';
import 'package:app_cordoba/modelo/model_index_icons.dart';
import 'package:app_cordoba/ui/views/Consulta/consulta_view.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_view.dart';
import 'package:app_cordoba/views/pdfweb/indexpdf.dart';

class ShowBottomSheet {
  String? tipo;
  int? pos;
  ShowBottomSheet({this.tipo, this.pos});
  late BuildContext sheetContext;

  final List<BannerVehiculos> _listaBanner = BannerVehiculos().generarBaner();

  Future build(BuildContext context) {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        sheetContext = context;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            tipo!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _listaBanner.length,
                      itemBuilder: (_context, i) {
                        if (_listaBanner.elementAt(i).categoria == tipo) {
                          return GestureDetector(
                            onTap: () => goroutes(
                                context: context,
                                sheetContext: sheetContext,
                                data: _listaBanner.elementAt(i)),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: ListTile(
                                leading: Icon(_listaBanner[i].icono),
                                //trailing: const Icon(Icons.arrow_forward_ios),
                                title: Text(
                                  _listaBanner[i].titulo!,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
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
}

Future goroutes(
    {BuildContext? context,
    BuildContext? sheetContext,
    BannerVehiculos? data}) async {
  Navigator.pop(sheetContext!);
  int tipo;
  if (data!.titulo == 'Declaración Impuesto de Vehículo') {
    tipo = 0;
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => SoapPage(tipo: tipo),
      ),
    );
  }
  if (data.titulo == 'Solicitud de paz y salvo') {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => ViewPazySalvo(),
      ),
    );
  }
  if (data.titulo == 'Consulta estado de cuenta') {
    tipo = 1;

    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => SoapPage(tipo: tipo),
      ),
    );
  }
  if (data.titulo == 'Ordenanzas') {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => Tab_F(data: data.titulo, itemsPdf: itemsPdf),
      ),
    );
  }
  if (data.titulo == 'Decretos') {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) =>
            Tab_F(data: data.titulo, itemsPdf: itemsPdfDecretos),
      ),
    );
  }
  if (data.titulo == 'Resoluciones') {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => Tab_F(data: data.titulo, itemsPdf: itemsPdfRes),
      ),
    );
  }
  if (data.titulo == 'Circulares') {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) =>
            Tab_F(data: data.titulo, itemsPdf: itemsPdfCircula),
      ),
    );
  }
}
