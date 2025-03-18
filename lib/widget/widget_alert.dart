import 'dart:convert';
import 'dart:io';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

File? file;
List<File> fileestampillas = [];
late BuildContext contextpro;
showAlertDialog(
    {BuildContext? context,
    String? mensaje,
    String? pin,
    String? jsonresult,
    Widget? botones}) async {
  String valormensaje = mensaje!
      .replaceAll("Codigopin", pin.toString())
      .replaceAll("ESTADO", jsonDecode(jsonresult!)['estado'].toString())
      .replaceAll("PLACA", jsonDecode(jsonresult)['placa'].toString())
      .replaceAll("PIN", pin.toString())
      .replaceAll("MOTIVO", jsonDecode(jsonresult)['mtvo'].toString())
      .replaceAll("DATE", jsonDecode(jsonresult)['fcha_cnclda'].toString());
  showDialog(
    context: context!,
    barrierDismissible: false,
    builder: (BuildContext contextmodal) {
      return AlertDialog(
        title: const Text('INFORMACIÓN IMPORTANTE'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              EasyRichText(
                valormensaje,
                selectable: true,
                textAlign: TextAlign.justify,
                patternList: [
                  EasyRichTextPattern(
                    targetString: jsonDecode(jsonresult)['estado'],
                    style: TextStyle(
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.bold),
                  ),
                  EasyRichTextPattern(
                    targetString: jsonDecode(jsonresult)['placa'],
                    style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold),
                  ),
                  EasyRichTextPattern(
                    targetString: pin,
                    style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [botones!],
      );
    },
  );
}

// Future<void> onLoadingPage({BuildContext context, String ping}) async {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     useRootNavigator: false,
//     builder: (BuildContext context) {
//       return Center(
//         child: Platform.isAndroid
//             ? const CircularProgressIndicator()
//             : const CupertinoActivityIndicator(),
//       );
//     },
//   );

//   final url = urlreimprimirpaz + 'placa=' + placa;
//   if (Platform.isAndroid) {
//     if (await ApiPermisos.requestWritePermission()) {
//       file = await PDFApi.loadNetwork(url, "Paz y Salvo $placa.pdf");
//       Navigator.pop(context);
//       openPDF(context, file, 'PAZ Y SALVO $placa');
//     } else {
//       Navigator.pop(context);
//       MyToast().getDialog(mensaje: "No tiene permisos");
//     }
//   } else {
//     file = await PDFApi.loadNetwork(url, "Paz y Salvo $placa.pdf");
//     Navigator.pop(context);
//     openPDF(context, file, 'PAZ Y SALVO $placa');
//   }
// }

// void openPDF(BuildContext context, File file, String nombre) =>
//     Navigator.of(context).push(
//       MaterialPageRoute(
//           builder: (context) => PageViewPdf(file: file, nombre: nombre)),
//     );
