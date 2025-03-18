// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_cordoba/modelo/soap_model_pazysalvo.dart';
import 'package:app_cordoba/providers/string_modal.dart';
import 'package:app_cordoba/widget/widget_modal_pin.dart';

class PazYSalvoConsultarViewModel extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controllerpin = TextEditingController();
  String placa = "";
  Pin pin = Pin();
  PazySalvoREST pazysalvo = PazySalvoREST();
  File? file;
  String jsonpin = "";

  BuildContext? padre;
  postConsultarPing(
      {required String pin, required BuildContext context}) async {
    late BuildContext contextloading;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        contextloading = context;
        return Center(
          child: Platform.isAndroid
              ? CircularProgressIndicator()
              : CupertinoActivityIndicator(),
        );
      },
    );
    Map valor = await pazysalvo.postConsultarPing(pin: pin);
    Navigator.pop(contextloading);
    print(valor);

    if (valor.isNotEmpty) {
      jsonpin = jsonEncode(valor['datos'][0]);

      if (jsonDecode(jsonpin)['existe'] == 1 && jsonpin.isNotEmpty) {
        switch (jsonDecode(jsonpin)['estado']) {
          case "VENCIDA":
            completada(
              context: context,
              jsonresult: jsonpin,
              mensaje: modalpinvencida,
              pin: pin,
            );
            break;
          case "DENEGADA":
            completada(
              context: context,
              jsonresult: jsonpin,
              mensaje: modalpindenegada,
              pin: pin,
            );
            break;
          case "CANCELADA":
            completada(
              context: context,
              jsonresult: jsonpin,
              mensaje: modalpincencelada,
              pin: pin,
            );
            break;
          case "ESTAMPILLA":
            completada(
              context: context,
              jsonresult: jsonpin,
              mensaje: modalpinestampilla,
              pin: pin,
            );
            break;
          case "VALIDACION":
            completada(
              context: context,
              jsonresult: jsonpin,
              mensaje: modalpinvalidacion,
              pin: pin,
            );
            break;
          case "COMPLETADA":
            completada(
              context: context,
              jsonresult: jsonpin,
            );
        }
      }
    }
  }
}
