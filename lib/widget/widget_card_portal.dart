import 'package:flutter/material.dart';
import 'package:app_cordoba/modelo/banner.dart';
import 'package:app_cordoba/modelo/model_index_icons.dart';
import 'package:app_cordoba/ui/views/Consulta/consulta_view.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_view.dart';
import 'package:app_cordoba/views/pdfweb/indexpdf.dart';
import 'package:app_cordoba/widget/widget_sheet.dart';

class PortalCard extends StatefulWidget {
  final int? index;
  const PortalCard({Key? key, this.index}) : super(key: key);

  @override
  State<PortalCard> createState() => _MyAppState();
}

class _MyAppState extends State<PortalCard> {
  late BuildContext padre;
  late BuildContext sheetContext;

  final List<BannerVehiculos> _listaBanner = BannerVehiculos().generarBaner();
  List itemsPortal = [
    "Portal de Vehículos",
    "Normatividad",

    // "Impuesto de Registro y otras rentas",
    // "Usuario Especiales",
    // "Tramites Especiales",
    // "Sobretasa a la Gasolina"
  ];

  Future showModalBottomSheetbuild({BuildContext? contextpadre, String? tipo}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        sheetContext = context;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          //height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(child: Icon(Icons.drag_handle)),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _listaBanner.length,
                  itemBuilder: (_context, i) {
                    if (_listaBanner.elementAt(i).categoria == tipo) {
                      return Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap:
                                () => goroutes(
                                  context: context,
                                  sheetContext: sheetContext,
                                  data: _listaBanner.elementAt(i),
                                ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              child: ListTile(
                                leading: Icon(_listaBanner[i].icono),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                title: Text(_listaBanner[i].titulo!),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future goroutes({
    BuildContext? context,
    BuildContext? sheetContext,
    BannerVehiculos? data,
  }) async {
    Navigator.pop(sheetContext!);
    int tipo;
    if (data!.titulo == 'Declaración Impuesto de Vehículo') {
      tipo = 0;
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => SoapPage(tipo: tipo)),
      );
    }
    if (data.titulo == 'Solicitud de paz y salvo') {
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => ViewPazySalvo()),
      );
    }
    if (data.titulo == 'Consulta estado de cuenta') {
      tipo = 1;
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (BuildContext context) => SoapPage(tipo: tipo),
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
          builder:
              (context) => Tab_F(data: data.titulo, itemsPdf: itemsPdfDecretos),
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
          builder:
              (context) => Tab_F(data: data.titulo, itemsPdf: itemsPdfCircula),
        ),
      );
    }
  }

  gestureOnTap() async {
    switch (widget.index) {
      case 0:
        // showModalBottomSheetbuild(
        //     contextpadre: context, tipo: "Portal de Vehículos");
        ShowBottomSheet(tipo: "Portal de Vehículos").build(context);
        break;
      case 1:
        ShowBottomSheet(tipo: "Normatividad").build(context);
        //showModalBottomSheetbuild(contextpadre: context, tipo: "Normatividad");
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gestureOnTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(child: SizedBox()),
            Image.asset(
              items[widget.index!].icon,
              height: 50,
              fit: BoxFit.cover,
              color: Colors.white,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                itemsPortal.elementAt(widget.index!),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Flexible(
                    child: Text(
                      "Ingrese aquí",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
