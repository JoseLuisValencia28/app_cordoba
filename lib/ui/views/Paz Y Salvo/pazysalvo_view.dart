import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_consulta_view.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_solicitar_view.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';

class ViewPazySalvo extends StatefulWidget {
  @override
  State<ViewPazySalvo> createState() => _ViewPazySalvoState();
}

class _ViewPazySalvoState extends State<ViewPazySalvo> {
  @override
  void initState() {
    super.initState();
  }

  final Future<bool> go = Future<bool>.delayed(
    const Duration(seconds: 1),
    () => true,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Informatica y Tributos',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
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
          child: FutureBuilder(
            future: go,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return MyCircularProgress();
              } else {
                return Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Card(
                          elevation: 5,
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            margin: EdgeInsets.all(7),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    "Solicitud de Paz y Salvo de Vehículo Automotor",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      "Solicite su Paz y Salvo de Vehículo Automotor virtualmente por este link.",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    dense: true,
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Requisitos:",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "* Cédula de Ciudadania del Propietario",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "* Tarjeta de Propiedad del Vehículo o Manifiesto de Aduana",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "* Correo Electrónico",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "* Número de Celular",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade900,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                ViewPazySalvoSolicitar(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "SOLICITAR",
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
                      ),
                      Expanded(
                        flex: 5,
                        child: Card(
                          elevation: 5,
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            margin: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: Text(
                                    "Consultar Estado Actual de Paz y Salvo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  title: Text(
                                    "Consulte el estado actual su Paz y Salvo de Vehículo Automotor virtualmente por este link.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Requisitos:",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "* Código PIN de Solicitud de Paz y Salvo Realizada previamente",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.blue.shade900,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder:
                                            (BuildContext context) =>
                                                ViewPazySalvoConsulta(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "CONSULTAR",
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
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
