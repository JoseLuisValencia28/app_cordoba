// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/upercase.dart';
import 'package:app_cordoba/modelo/soap_model_pazysalvo.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_viewmodel.dart';
import 'package:app_cordoba/uix/deco_form.dart';
import 'package:app_cordoba/widget/widget_toast.dart';
import 'package:stacked/stacked.dart';

class ViewPazySalvoVerificar extends StatefulWidget {
  final PazySalvoREST? resultrest;
  final String? placa;

  const ViewPazySalvoVerificar({Key? key, this.resultrest, this.placa})
    : super(key: key);
  @override
  State<ViewPazySalvoVerificar> createState() => _ViewPazySalvoState();
}

class _ViewPazySalvoState extends State<ViewPazySalvoVerificar> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Informatica y Tributos',
      home: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'VERIFICACIÓN DE PROPIETARIO',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 5,
            toolbarHeight: 90.0,
            iconTheme: IconThemeData(color: Colors.blue.shade900),
            backgroundColor: Colors.blue.shade900,
          ),
          body: Center(
            child: ViewModelBuilder<PazYSalvoViewModel>.reactive(
              viewModelBuilder: () => PazYSalvoViewModel(),
              builder: (context, model, child) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Form(
                      key: model.formKeyVerificar,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Digite los datos del propietario del vehiculo",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              cursorColor: Colors.blue.shade900,
                              controller: model.controllernombre,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                UpperCaseTextFormatter(),
                              ],
                              style: styleform,
                              decoration: decorationform.copyWith(
                                //contentPadding: EdgeInsets.all(10),
                                suffixIcon: Icon(
                                  Icons.account_box,
                                  color: Colors.blue.shade900,
                                ),
                                labelText: "Nombre Completo",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Llenar campo nombre';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              cursorColor: Colors.blue.shade900,
                              controller: model.controllercc,
                              keyboardType: TextInputType.number,
                              //maxLength: 11,
                              style: styleform,
                              decoration: decorationform.copyWith(
                                suffixIcon: Icon(
                                  Icons.contacts,
                                  color: Colors.blue.shade900,
                                ),
                                labelText: "Número Nit/Cédula",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Llenar campo Nit/Cédula';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              cursorColor: Colors.blue.shade900,
                              controller: model.controllecorreo,
                              keyboardType: TextInputType.emailAddress,
                              style: styleform,
                              decoration: decorationform.copyWith(
                                suffixIcon: Icon(
                                  Icons.email,
                                  color: Colors.blue.shade900,
                                ),
                                labelText: "Correo Electrónico",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Llenar campo Correo';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              cursorColor: Colors.blue.shade900,
                              controller: model.controllercelular,
                              keyboardType: TextInputType.number,
                              //maxLength: 10,
                              style: styleform,
                              decoration: decorationform.copyWith(
                                labelText: "Celular",
                                suffixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Llenar campo Celular';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(7),
                            padding: EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade400, // Set border color
                                width: 2.0,
                              ), // Set border width
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.0),
                              ), // Set rounded corner radius
                            ),
                            child: Row(
                              children: [
                                (model.resultPicker == null)
                                    ? Expanded(
                                      child: GestureDetector(
                                        onTap: () => model.verificarpazysalvo(),
                                        child: Text(
                                          " Seleccionar documento de propiedad",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ),
                                    )
                                    : Expanded(
                                      child: Text(
                                        " Nombre Archivo : ${model.resultPicker!.names[0]}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                (model.filebytes.length == 0)
                                    ? Icon(Icons.check_box, color: Colors.grey)
                                    : const Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    ),
                                IconButton(
                                  onPressed: () {
                                    model.clearbyte();
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tipo de datos admitidos: (.png, .jpg, .pdf)",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              model.controllecorreo.text.replaceAll(' ', '');
                              if (!model.formKeyVerificar.currentState!
                                  .validate()) {
                                MyToast().getDialog(mensaje: "Campo vacios");
                              } else {
                                if (widget.resultrest!.identificacion !=
                                    model.controllercc.text) {
                                  //10766742
                                  model.modaldialogSnap(
                                    contextpadre: context,
                                    mensaje: model.mensajes,
                                    placa: widget.placa.toString(),
                                    tipo: 1,
                                  );
                                } else {
                                  model.modaldialogSnap(
                                    contextpadre: context,
                                    mensaje: model.mensajes,
                                    placa: widget.placa.toString(),
                                    tipo: 0,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            child: const Text(
                              'VERIFICAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
