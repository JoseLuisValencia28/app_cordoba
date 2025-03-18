import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/upercase.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_viewmodel.dart';
import 'package:app_cordoba/widget/widget_toast.dart';
import 'package:stacked/stacked.dart';

class ViewPazySalvoSolicitar extends StatefulWidget {
  @override
  State<ViewPazySalvoSolicitar> createState() => _ViewPazySalvoState();
}

class _ViewPazySalvoState extends State<ViewPazySalvoSolicitar> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Informatica y Tributos',
      home: Scaffold(
        // widgetbody: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'GENERACIÓN DE PAZ Y SALVO',
            maxLines: 2,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 5,
          iconTheme: IconThemeData(color: Colors.blue.shade900),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Center(
          child: ViewModelBuilder<PazYSalvoViewModel>.reactive(
            viewModelBuilder: () => PazYSalvoViewModel(),
            builder: (context, model, child) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Container(
                  child: Form(
                    key: model.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10,
                          ),
                          child: Center(
                            child: Text(
                              "Digite número de la placa:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 260,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/plaque.png'),
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
                                        if (value == null || value.isEmpty) {
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
                        ElevatedButton(
                          onPressed: () async {
                            if (model.formKey.currentState!.validate()) {
                              model.validarPazYSalvo(
                                placa: model.placa,
                                context: context,
                              );
                            } else {
                              MyToast().getDialog(mensaje: "Campo vacios");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          child: const Text(
                            'CONSULTAR',
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }
}
