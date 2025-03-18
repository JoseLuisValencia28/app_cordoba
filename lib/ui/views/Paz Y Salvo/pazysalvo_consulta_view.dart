import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_consultaviewmodel.dart';
import 'package:app_cordoba/widget/widget_toast.dart';
import 'package:stacked/stacked.dart';

class ViewPazySalvoConsulta extends StatefulWidget {
  @override
  State<ViewPazySalvoConsulta> createState() => _MyAppState();
}

class _MyAppState extends State<ViewPazySalvoConsulta> {
  @override
  Widget build(BuildContext contextpadre) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        // widgetbody: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(contextpadre).pop();
            },
          ),
          title: Text(
            'CONSULTA ESTADO DE SOLICITUD',
            maxLines: 2,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 5,
          iconTheme: IconThemeData(color: Colors.blue.shade900),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Center(
          child: ViewModelBuilder<PazYSalvoConsultarViewModel>.reactive(
            onModelReady: (model) {},
            viewModelBuilder: () => PazYSalvoConsultarViewModel(),
            builder: (context, model, child) {
              return SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Container(
                  child: Form(
                    key: model.formKey,
                    child: Column(
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
                              "Digite Codigo PIN de la solicitud de Paz y Salvo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 230,
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: TextFormField(
                            controller: model.controllerpin,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'PIN',
                              hintText: '123456',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.directions_car_filled,
                                size: 30,
                              ),
                              prefixIcon: Icon(Icons.search, size: 30),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                print('False');
                                return 'Debe digitar un PIN';
                              }
                              model.placa = value;
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (model.formKey.currentState!.validate()) {
                              model.postConsultarPing(
                                pin: model.controllerpin.text,
                                context: contextpadre,
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
