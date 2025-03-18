// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_cordoba/api/pdf_api.dart';
import 'package:app_cordoba/api/permisos.dart';
import 'package:app_cordoba/api/upercase.dart';
import 'package:app_cordoba/modelo/soap_model_pazysalvo.dart';
import 'package:app_cordoba/providers/string_modal.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_pdf_multi_view.dart';
import 'package:app_cordoba/ui/views/pdf/view_pdf.dart';
import 'package:app_cordoba/uix/deco_form.dart';
import 'package:app_cordoba/widget/widget_alert.dart';
import 'package:app_cordoba/widget/widget_toast.dart';

void completada({
  required BuildContext context,
  String? mensaje,
  String? jsonresult,
  String? pin,
}) {
  String valormensaje = mensaje!
      .replaceAll("Codigopin", pin.toString())
      .replaceAll("ESTADO", jsonDecode(jsonresult!)['estado'].toString())
      .replaceAll("PLACA", jsonDecode(jsonresult)['placa'].toString())
      .replaceAll("PIN", pin.toString())
      .replaceAll("MOTIVO", jsonDecode(jsonresult)['mtvo'].toString())
      .replaceAll("DATE", jsonDecode(jsonresult)['fcha_cnclda'].toString());
  showDialog(
    context: context,
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  EasyRichTextPattern(
                    targetString: jsonDecode(jsonresult)['placa'],
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  EasyRichTextPattern(
                    targetString: pin,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible:
                    (jsonDecode(jsonresult)['estado'] == "COMPLETADA")
                        ? true
                        : false,
                child: ElevatedButton(
                  child: const Text('DESCARGAR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade900,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(contextmodal).pop();
                    onLoadingPage(
                      context: context,
                      placa: jsonDecode(jsonresult)['placa'],
                    );
                  },
                ),
              ),
              Visibility(
                visible:
                    (jsonDecode(jsonresult)['estado'] == "VALIDACION" &&
                            jsonDecode(jsonresult)['estado'] == "ESTAMPILLA")
                        ? true
                        : false,
                child: ElevatedButton(
                  child: const Text('CANCELAR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await showAlertDialogCancelar(
                      context: context,
                      mensaje: modalpinvalidacioncancelar,
                      jsonresult: jsonresult,
                      pin: pin!,
                    );
                  },
                ),
              ),
              Visibility(
                visible:
                    (jsonDecode(jsonresult)['estado'] == "ESTAMPILLA")
                        ? true
                        : false,
                child: ElevatedButton(
                  child: const Text('INSTRUCCIONES'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.of(contextmodal).pop();
                    await showAlertDialogInstrucciones(
                      context: context,
                      mensaje: instructivo,
                      jsonresult: jsonresult,
                      pin: pin!,
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: ElevatedButton(
                  child: const Text(
                    'REGRESAR',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(contextmodal);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void pinerror({required BuildContext context, String? mensaje}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext contextmodal) {
      return AlertDialog(
        title: const Text('INFORMACIÓN IMPORTANTE'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              EasyRichText(
                mensaje!,
                selectable: true,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 8),
                child: ElevatedButton(
                  child: const Text(
                    'REGRESA',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(contextmodal);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> onLoadingPage({
  required BuildContext context,
  String? placa,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (BuildContext context) {
      return Center(
        child:
            Platform.isAndroid
                ? const CircularProgressIndicator()
                : const CupertinoActivityIndicator(),
      );
    },
  );
  final url = urlreimprimirpaz + 'placa=' + placa!;
  print(url);
  if (Platform.isAndroid) {
    if (await ApiPermisos.requestWritePermission()) {
      file = await PDFApi.loadNetwork(
        url: url,
        filename: "Paz y Salvo $placa.pdf",
      );
    } else {
      MyToast().getDialog(mensaje: "No tiene permisos");
    }
  } else {
    file = await PDFApi.loadNetwork(
      url: url,
      filename: "Paz y Salvo $placa.pdf",
    );
  }
  Navigator.pop(context);
  if (file != null) {
    openPDF(context, file!, 'PAZ Y SALVO $placa');
  } else {
    MyToast().getDialog(mensaje: "Intente mas tarde");
  }
}

void openPDF(BuildContext context, File file, String nombre) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                PageViewPdf(file: file, nombre: nombre, contextpadre: context),
      ),
    );

showAlertDialogInstrucciones({
  BuildContext? context,
  String? mensaje,
  String? pin,
  String? jsonresult,
}) async {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceAround,
        title: const Text('INFORMACIÓN IMPORTANTE'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ListBody(
              children: <Widget>[Text(mensaje!, textAlign: TextAlign.justify)],
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('DESCARGAR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade900,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              String download = await PazySalvoREST().postdescargarpazysalvo(
                pin: pin,
              );
              List valor = jsonDecode(download)['datos'];
              fileestampillas.clear();
              if (valor.isNotEmpty) {
                if (Platform.isAndroid) {
                  if (await ApiPermisos.requestWritePermission()) {
                    for (int i = 0; i < valor.length; i++) {
                      Map data = valor[i];
                      String archivo = data.values
                          .toString()
                          .replaceAll("(", "")
                          .replaceAll(")", "");
                      File? file = await PDFApi.loadNetwork(
                        filename: archivo,
                        url: certificadosestampilla + "/" + archivo,
                      );

                      fileestampillas.add(file!);
                    }
                    print(fileestampillas);
                  } else {
                    MyToast().getDialog(mensaje: "Sin permisos de archivo");
                  }
                } else {
                  for (int i = 0; i < valor.length; i++) {
                    fileestampillas.add(file!);
                  }
                }
                int sizeInBytes = fileestampillas[0].lengthSync();
                int sizeInBytes2 = fileestampillas[0].lengthSync();
                double sizeInMb = sizeInBytes / (1024 * 1024);
                double sizeInMb2 = sizeInBytes2 / (1024 * 1024);

                if (fileestampillas.isNotEmpty &&
                    sizeInMb >= 0.1 &&
                    sizeInMb2 >= 0.1) {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => PageViewPdfMulti(files: fileestampillas),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  MyToast().getDialog(
                    mensaje: "No se han generado las estampillas",
                  );
                }
              }
            },
          ),
          ElevatedButton(
            child: const Text('VOLVER'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return context;
}

showAlertDialogCancelar({
  BuildContext? context,
  String? mensaje,
  String? pin,
  String? jsonresult,
}) async {
  TextEditingController controllerplaca = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late BuildContext contextpro;
  showDialog(
    context: context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('INFORMACIÓN IMPORTANTE'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ListBody(
              children: <Widget>[
                Text(mensaje!, textAlign: TextAlign.justify),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.blue.shade900,
                    controller: controllerplaca,
                    keyboardType: TextInputType.text,
                    maxLength: 6,
                    inputFormatters: [UpperCaseTextFormatter()],
                    style: styleform,
                    decoration: decorationform.copyWith(
                      //contentPadding: EdgeInsets.all(10),
                      suffixIcon: Icon(
                        Icons.directions_car_rounded,
                        color: Colors.blue.shade900,
                      ),
                      labelText: "Placa",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Llenar campo Placa';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('CONFIRMAR CANCELACIÓN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade900,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  contextpro = context;
                  return Center(
                    child:
                        Platform.isAndroid
                            ? CircularProgressIndicator()
                            : CupertinoActivityIndicator(),
                  );
                },
              );
              if (formKey.currentState!.validate()) {
                if (controllerplaca.text == jsonDecode(jsonresult!)['placa']) {
                  String result = await PazySalvoREST().postCancelarSolicitud(
                    pin: [pin!],
                    placa: [controllerplaca.text],
                  );
                  if (result != "0") {
                    MyToast().getDialog(
                      color: Colors.green,
                      mensaje:
                          "Se\u00f1or contribuyente, se ha cancelado la solicitud de paz y salvo de impuesto sobre \nveh\u00edculo automor satisfactoriamente",
                    );
                  } else {
                    MyToast().getDialog(
                      color: Colors.red.shade900,
                      mensaje: "hubo un error al cancelar la solicitud",
                    );
                  }
                } else {
                  MyToast().getDialog(
                    color: Colors.red.shade900,
                    mensaje:
                        "Se\u00f1or contribuyente la placa ingresada no corresponde a la placa asociada al pin $pin",
                  );
                }
              }
              Navigator.pop(context);
              Navigator.pop(contextpro);
            },
          ),
          ElevatedButton(
            child: const Text('VOLVER'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  return context;
}
