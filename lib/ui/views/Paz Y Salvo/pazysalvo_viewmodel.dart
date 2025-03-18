// ignore_for_file: unnecessary_null_comparison, dead_code, sort_child_properties_last

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/pdf_api.dart';
import 'package:app_cordoba/api/permisos.dart';
import 'package:app_cordoba/modelo/soap_model_pazysalvo.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_verificar_view.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_view.dart';
import 'package:app_cordoba/ui/views/pdf/view_pdf.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_toast.dart';
import 'package:mime/mime.dart';

class PazYSalvoViewModel extends ChangeNotifier {
  TextEditingController controllernombre = TextEditingController();
  TextEditingController controllercc = TextEditingController();
  TextEditingController controllecorreo = TextEditingController();
  TextEditingController controllercelular = TextEditingController();
  String placa = "";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyVerificar = GlobalKey<FormState>();
  PazySalvoREST pz = PazySalvoREST();

  String mensaje = "";
  File? file;
  Uint8List filebytes = Uint8List(0);
  late BuildContext loading;
  FilePickerResult? resultPicker;
  String mensaje1 = "";
  String mensaje2 = "";
  String mensaje3 = "";
  String mensaje4 = "";
  String mensaje5 = "";
  String mensaje6 = "";
  List<String> mensajes = [];
  String mimeType = "";
  PazySalvoREST resultPazysalvo = PazySalvoREST();
  late BuildContext contextloading;
  Pin confirmar = Pin();
  clearbyte() {
    filebytes = Uint8List(0);
    resultPicker = null;
    notifyListeners();
  }

  validarPazYSalvo({String? placa, required BuildContext context}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        loading = context;
        return Center(
          child:
              Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator(),
        );
      },
    );

    PazySalvoREST result = await PazySalvoREST().postValidaSolicitud(placa);
    print(result.toJson());
    Navigator.pop(loading);
    //1041267484
    if (result != null) {
      if (result.reimprimir == 1) {
        onLoadingPage(context: context, placa: placa.toString());
      } else if (result.existe == 0) {
        mensaje =
            """Señor contribuyente, la placa digitada no está registrada en la base de datos de
            impuestos sobre vehículos automotores del departamento de córdoba, favor acercarse a
            la oficina de atención al contribuyente ubicada en el centro comercial suricentro,
            calle 10 no. 25-105 local 153, o enviar correo electrónico a
            recaudo.impuestos@cordoba.gov.co con los siguientes documentos adjuntos: tarjeta de
            propiedad o licencia de tránsito y factura de compra.""";

        //Placa no registrada
      } else if (result.estado == "N") {
        mensaje =
            """Señor contribuyente, el vehículo se encuentra actualmente inactivo.""";
        //
      } else {
        if (result.vigencias != 0) {
          //Posee deudas
          mensaje =
              "Señor contribuyente, el vehículo posee deudas, se le enviara un correo con información detallada.";
        } else if (result.existe == 1 &&
            result.estado == "S" &&
            result.pslctdexstnte == "0") {
          mensaje = "";
          //Segunda parte
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ViewPazySalvoVerificar(resultrest: result, placa: placa),
            ),
          );
        } else {
          mensaje =
              "Señor contribuyente, la placa digitada ya cuenta con una solicitud de paz y salvo realizada previamente,si desea información adicional sobre esta solicitud, puede solicitar el envio de un correo con los datos y el código PIN de esta solicitud. Por su seguridad esta información solo sera enviada a la persona que realizo la solicitud y registro el correo electronico.";
        }

        if (mensaje.isNotEmpty) {
          modaldialog(context: context, mensaje: mensaje);
        }
      }
    } else {
      MyToast().getDialog(
        mensaje: "Intente mas tarde",
        color: Colors.blue.shade900,
      );
    }
    notifyListeners();
  }

  onLoadingPagePing({required BuildContext context, Pin? ping}) async {
    mensaje1 = "Confirmación de datos:";
    mensaje2 = "EN VALIDACIÓN";
    mensaje3 = "Placa vehiculo: $placa";
    mensaje4 = "Código pin: ${ping!.pin}";
    mensaje5 =
        "Señor usuario, se ha confirmado satisfactoriamente la solicitud de Paz y Salvo de Impuesto Sobre Vehiculo Automotor, se ha enviado un correo electronico con información adicional al correo ${controllecorreo.text} con los datos de esta solicitud y su Codigo para consultar el estado de la solicitud.Su solicitud pasara al estado EN VALIDACIÓN. Se le informara al correo electronico cuando se actualice el estado de su solicitud.";

    List<String> mensaje = [];
    mensaje.addAll([mensaje1, mensaje2, mensaje3, mensaje4, mensaje5]);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('INFORMACIÓN IMPORTANTE'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      ...mensaje.map((e) {
                        //var index = mensaje.indexOf(e);
                        switch (e) {
                          case "EN VALIDACIÓN":
                            return TextSpan(
                              text: '$e\n',
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                            break;
                          default:
                            return TextSpan(
                              text: '$e\n',
                              style: TextStyle(fontSize: 16),
                            );
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              child: Text('Copiar Codigo Pin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                MyToast().getDialog(
                  mensaje: "Codigo ${confirmar.pin} copiado",
                  color: Colors.blue.shade900,
                );
                Clipboard.setData(
                  ClipboardData(text: confirmar.pin.toString()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('INICIO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPazySalvo()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  verificarpazysalvo() async {
    resultPicker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'pdf'],
    );

    if (resultPicker != null && resultPicker!.files.isNotEmpty) {
      String? filePath = resultPicker!.files.single.path;

      if (filePath != null && filePath.isNotEmpty) {
        file = File(filePath);
        filebytes = file!.readAsBytesSync();
        mimeType = getFileExtension(file!.path);
      }
    } else {
      // User canceled the picker
    }
    notifyListeners();
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

    final url = urlreimprimirpaz + 'placa=' + placa.toString();

    if (Platform.isAndroid) {
      if (await ApiPermisos.requestWritePermission()) {
        file = await PDFApi.loadNetwork(
          url: url,
          filename: "Paz y Salvo $placa.pdf",
        );
        Navigator.pop(context);
        openPDF(context, file!, 'PAZ Y SALVO $placa');
      } else {
        Navigator.pop(context);
        MyToast().getDialog(mensaje: "No tiene permisos");
      }
    } else {
      file = await PDFApi.loadNetwork(
        url: url,
        filename: "Paz y Salvo $placa.pdf",
      );
      Navigator.pop(context);
      openPDF(context, file!, 'PAZ Y SALVO $placa');
    }
  }

  void openPDF(BuildContext context, File file, String nombre) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) =>
                PageViewPdf(file: file, nombre: nombre, contextpadre: context),
      ),
    );
  }

  modaldialog({required BuildContext context, String? mensaje}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('INFORMACIÓN IMPORTANTE'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(mensaje.toString(), textAlign: TextAlign.justify),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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
  }

  modaldialogSnap({
    required BuildContext contextpadre,
    List<String>? mensaje,
    String? placa,
    int? tipo,
  }) {
    mensajes.clear();
    if (tipo == 1) {
      mensaje1 = "Confirmación de datos:";
      mensaje6 = "DENEGADA";
      mensaje2 =
          "Placa vehiculo: $placa\nSeñor usuario, los datos ingresados no corresponden a los registrados en nuestra base de datos y por tanto la confirmación de la solicitud de Paz y Salvo ha sido DENEGADA.";
      mensaje3 =
          "Si considera que hubo un error en el ingreso de los datos de la solicitud, haga click en el boton VOLVER.\nSi requiere de la actualización de los datos del propietario del vehiculo, por favor haga click en el boton ACTUALIZAR.";
    } else {
      mensaje1 = "Confirmación de datos:";
      mensaje6 = "APROBADA";
      mensaje2 =
          "Placa vehiculo: $placa\nSeñor usuario, al confirmar esta solicitud de paz y salvo se generara un Codigo PIN unico registrando la solicitud en nuestra base de datos, este PIN sera enviado a su correo electronico registrado y a su celular.";
      mensaje3 = "Su solicitud pasara al estado EN VALIDACIÓN.";
      mensaje4 =
          "Podra consultar el estado de su solicitud en esta pagina o a travez del vinculo incluido incluido en el mensaje de notificación del correo electronico.";
    }

    mensajes.addAll([mensaje1, mensaje6, mensaje2, mensaje3, mensaje4]);
    if (resultPicker != null) {
      showDialog(
        context: contextpadre,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('INFORMACIÓN IMPORTANTE'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        ...mensaje!.map((e) {
                          //var index = mensaje.indexOf(e);
                          switch (e) {
                            case "DENEGADA":
                              return TextSpan(
                                text: '$e\n',
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                  fontSize: 16,
                                ),
                              );
                              break;
                            case "APROBADA":
                              return TextSpan(
                                text: '$e\n',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              );
                              break;
                            case "Si considera que hubo un error en el ingreso de los datos de la solicitud, haga click en el boton VOLVER.\nSi requiere de la actualización de los datos del propietario del vehiculo, por favor haga click en el boton ACTUALIZAR.":
                              return TextSpan(
                                text: '$e\n',
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                  fontSize: 16,
                                ),
                              );
                              break;
                            default:
                              return TextSpan(
                                text: '$e\n',
                                style: TextStyle(fontSize: 16),
                              );
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions:
                (tipo == 1)
                    ? [
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
                      ElevatedButton(
                        child: const Text('ACTUALIZAR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]
                    : [
                      ElevatedButton(
                        child: const Text('CONFIRMAR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          String mensaje = "";
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              contextloading = context;
                              return MyCircularProgress();
                            },
                          );
                          confirmar = await resultPazysalvo
                              .postRegistrarSolicitud(
                                bytearchivo: filebytes,
                                correo: controllecorreo.text,
                                identificacion: controllercc.text,
                                nombreArchivo: "Paz y Salvo $placa",
                                mimeType: mimeType,
                                nombrepropietario: controllernombre.text,
                                placa: placa,
                                telefono: controllercelular.text,
                              );

                          Navigator.of(context).pop();
                          Navigator.of(contextloading).pop();
                          if (confirmar.pin == null && confirmar.grdo == 1) {
                            mensaje =
                                "No se pudo registrar la solicitud, intente mas tarde";
                            MyToast().getDialog(mensaje: mensaje);
                          } else {
                            mensaje = "";
                            onLoadingPagePing(
                              context: contextpadre,
                              ping: confirmar,
                            );
                          }

                          if (mensaje != "") {
                            MyToast().getDialog(mensaje: mensaje);
                          }
                        },
                      ),
                    ],
          );
        },
      );
    } else {
      MyToast().getDialog(mensaje: "Seleccionar documento de propiedad");
    }
  }

  getFileExtension(var fileName) {
    mimeType = lookupMimeType(file!.path)!;
    return mimeType;
  }
}
