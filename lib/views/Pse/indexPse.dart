// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/modelo/soap_model_detalleLiquida.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/views/Declaracion/declara_vehiculo_liquida.dart';
import 'package:app_cordoba/widget/widget_footer.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: camel_case_types
class Tab_E extends StatefulWidget {
  final List<SoapDetalleLiquida>? data;
  final List<SoapInfoCartera>? cartera;
  final List<SoapModelInfoVehi>? infoVeh;
  final List<Elementos>? itemElementos;
  final String? placa;
  final String? vigencia;
  final String? fechalimite;
  final String? codigdepartamento;
  final String? codigmuni;
  final String? preImpreso;
  final String? v1;
  final String? v2;
  final String? v3;

  Tab_E({
    this.data,
    this.placa,
    this.infoVeh,
    this.cartera,
    this.vigencia,
    this.fechalimite,
    this.itemElementos,
    this.codigdepartamento,
    this.preImpreso,
    this.v1,
    this.v2,
    this.v3,
    this.codigmuni,
    Key? key,
  }) : super(key: key);

  final Brows brows = Brows();

  @override
  PSE createState() => PSE();
}

class Brows extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print('Browser Created!');
  }

  @override
  Future onLoadStart(url) async {
    print('Start $url!');
  }

  @override
  Future onLoadStop(url) async {
    print('Stop $url!');
  }

  @override
  Future onLoadError(url, code, message) async {
    print('Error $url..error $message!');
  }

  @override
  Future onProgressChanged(progress) async {
    print('Progress: $progress!');
  }

  @override
  void onExit() {
    print('Browser Closed!');
  }
}

var childButtons;

// ignore: must_be_immutable
class PSE extends State<Tab_E> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  late InAppWebViewController webViewController;
  var opcionInApp = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
  );
  var options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(hideUrlBar: false),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
    ),
  );
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pagos PSE'),
          backgroundColor: Colors.blue.shade900,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          // widgetbody: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialOptions: opcionInApp,
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(
                        "https://www.abcpagos.com/cordoba/index.php" as Uri,
                      ),
                      method: 'POST',
                      body: Uint8List.fromList(
                        utf8.encode(
                          'codigo_entidad=8001039356&codigo_servicio=1001&tpo_idntfccion=' +
                              widget.data![0].tpoidntfccion! +
                              '&vhclo=' +
                              widget.placa! +
                              '&dane=' +
                              widget.codigdepartamento! +
                              widget.codigmuni! +
                              '&idntfccion=' +
                              widget.infoVeh![0].p_idntfccion_prptrios! +
                              '&nmro_dcmnto=' +
                              widget.preImpreso! +
                              '&rzon_scial=' +
                              widget.data![0].nmbreprptrio! +
                              '&vlor=' +
                              widget.v1! +
                              '&vlor_dpto=' +
                              widget.v3! +
                              '&vlor_mpio=' +
                              widget.v2! +
                              '&cncpto=VHC' +
                              '&dscrpcion=Pago de impuesto Vehicular Cordoba Android ${widget.placa}' +
                              '&tipo_id=' +
                              widget.data![0].tpoidntfccion! +
                              '&Id_cliente=' +
                              widget.infoVeh![0].p_idntfccion_prptrios! +
                              '&nombre_cliente=' +
                              widget.data![0].nmbreprptrio! +
                              '&Id_pago=' +
                              widget.preImpreso! +
                              '&total_con_iva=' +
                              widget.v1! +
                              '&total_dpto=' +
                              widget.v3! +
                              '&total_mpio=' +
                              widget.v2! +
                              '',
                        ),
                      ),
                      headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                      },
                    ),
                  ),
                ],
              ),
            ),
            Footer(),
          ],
        ),
      ),
      // floatingActionButton: Stack(
      //   children: [
      //     // UnicornDialer(
      //     //     backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
      //     //     parentButtonBackground: Colors.blue.shade900,
      //     //     orientation: UnicornOrientation.VERTICAL,
      //     //     parentButton: Icon(Icons.menu),
      //     //     childButtons: childButtons),
      //   ],
      // ),
    );
  }
}
