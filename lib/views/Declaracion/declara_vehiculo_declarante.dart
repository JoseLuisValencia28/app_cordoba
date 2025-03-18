// ignore_for_file: unused_field, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/api/permisos.dart';
import 'package:app_cordoba/api/util_email.dart';
import 'package:app_cordoba/packages/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:app_cordoba/api/pdf_api.dart';
import 'package:app_cordoba/modelo/soap_model_departamento.dart';
import 'package:app_cordoba/modelo/soap_model_detalleLiquida.dart';
import 'package:app_cordoba/modelo/soap_model_infoDatos.dart';
import 'package:app_cordoba/modelo/soap_model_infoVehi.dart';
import 'package:app_cordoba/modelo/soap_model_municipio.dart';
import 'package:app_cordoba/modelo/soap_model_registrarLiquida.dart';
import 'package:app_cordoba/modelo/soap_model_sota.dart';
import 'package:app_cordoba/providers/soap_provider.dart';
import 'package:app_cordoba/providers/variables.dart';
import 'package:app_cordoba/views/ConsultaImpuesto/pageestadoCuenta.dart';
import 'package:app_cordoba/views/Declaracion/declara_vehiculo_liquida.dart';
import 'package:app_cordoba/views/Index/soap_page_index.dart';
import 'package:app_cordoba/views/Pse/indexPse.dart';
import 'package:app_cordoba/widget/widget_circular_progress.dart';
import 'package:app_cordoba/widget/widget_footer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class TabC extends StatefulWidget {
  final List<SoapDetalleLiquida> data;
  final List<SoapInfoCartera> cartera;
  final List<SoapModelInfoVehi> infoVeh;
  final List<Elementos> itemElementos;
  final String placa;
  final String vigencia;
  final String fechalimite;
  const TabC({
    required this.data,
    required this.placa,
    required this.infoVeh,
    required this.cartera,
    required this.vigencia,
    required this.fechalimite,
    required this.itemElementos,
    Key? key,
  }) : super(key: key);
  @override
  ScreenDeclaraVehiculoDeclarante createState() =>
      ScreenDeclaraVehiculoDeclarante();
}

class ScreenDeclaraVehiculoDeclarante extends State<TabC> {
  final mapaProvider = SoapProvider();
  late Future<List<SoapDetalleLiquida>> soapFechaLiquida;
  late Future<List<SoapMoedelDepartamento>> soapDepartamento;
  late Future<List<SoapSOAT>> soapSoat;
  late Future<List<SoapInfoCartera>> soapCartera;
  late Future<List<SoapModelMunicipio>> soapMunicipio;
  late List<SoapSOAT> _listSoat = [];
  late List<String> _listDep = [];
  late List<String> _listMun = [];
  late List<SoapModelMunicipio> value = [];
  final soatDrop = <SoapSOAT>[];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    soapSoat = mapaProvider.getSoat();
    soapCartera = mapaProvider.getInfoCartera(widget.placa);
    soapDepartamento = mapaProvider.getSoapDepartamento();
    soapMunicipio = mapaProvider.getMunicipio(widget.cartera[0].dprtmnto!);
    requestWritePermission();
  }

  bool enable = false;
  late String _nit = 'NIT', _nombreSoat, _dv = 'DV';
  late String _departamentoget, _municipioget, _departamentoTxt;
  late String coddep, codmun;
  late List<DropdownMenuItem<String>> dropdownMenuOptionsSoat;
  late List<DropdownMenuItem<String>> dropdownMenuOptionsDep;
  late List<DropdownMenuItem<String>> dropdownMenuOptionsMun;
  //List<DropdownMenuItem<String>> dropdownValue;

  List<String> depfull = [];
  List<SoapMoedelDepartamento> depfull2 = [];
  List<String> munfull = [];

  final controllernit = TextEditingController();
  final controllerDv = TextEditingController();
  final controlleAseguradora = TextEditingController();
  final controllerfecha = TextEditingController();
  final controllernombreP = TextEditingController();
  final controllertipoId = TextEditingController();
  final controllercedula = TextEditingController();
  final controllertel = TextEditingController();
  final controllerdvprop = TextEditingController();
  final controllerdireccion = TextEditingController();
  final controllerdepartamento = TextEditingController();
  final controllermunicipio = TextEditingController();
  final controlleemail = TextEditingController();

  List _departamento = [];
  late String _municipio;

  late DateTime currentDate;
  var childButtons;
  GlobalKey<AutoCompleteTextFieldState<String>> keyDepartamento = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> keyMunicipio = GlobalKey();

  final GlobalKey<FormState> _formKeydeclara = GlobalKey<FormState>();

  String _soat = '0-Seleccione-0';
  late String dropdownValue;
  late String dropdownValueMun;

  bool _allowWriteFile = false;
  bool readyToShow = false;
  late String fileName;
  late Directory directory;
  bool loading = false;
  double progress = 0;
  var isDialOpen = ValueNotifier<bool>(false);
  var customDialRoot = false; //Boton rectangular (true) - Circular (false)
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var extend = false;
  var visible = true;
  var speedDialDirection = SpeedDialDirection.up;
  var switchLabelPosition = false;
  var closeManually = false;
  var renderOverlay = true;
  var useRAnimation = true;
  var rmicons = false;
  void requestWritePermission() async {
    if (await Permission.storage.request().isGranted) {
      _allowWriteFile = true;
    } else {
      // ignore: unused_local_variable
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
    }
  }

  Dio dio = Dio();
  late String dirFull;

  var datePicked;
  Map<String, dynamic> formData = {};
  @override
  Widget build(BuildContext ctx) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    botones();
    controllernombreP.text = widget.data[0].nmbreprptrio!;
    controllertipoId.text = widget.data[0].tpoidntfccion!;
    controllertel.text = widget.data[0].tlfnoprptrio!;
    controllercedula.text = widget.infoVeh[0].p_idntfccion_prptrios!;
    controllerdvprop.text = widget.data[0].dgtovrfccion!;
    controllerdireccion.text = widget.data[0].drccionprptrio!;
    _municipioget = widget.data[0].cdgomncpio!;
    _departamentoget = widget.data[0].cdgodprtrmnto!;
    controllernit.text = _nit;
    controllerDv.text = _dv;
    controllerfecha.text = '';

    return Scaffold(
      // widgetbody: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paso 4 Declarante',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: FutureBuilder(
        future: Future.wait([
          soapCartera,
          soapDepartamento,
          soapSoat,
          soapMunicipio,
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Container(child: MyCircularProgress());
          } else {
            var dataCartera = snapshot.data[0];
            var dataDepartamento = snapshot.data[1];
            var dataSoat = snapshot.data[2];
            var dataMunicipio = snapshot.data[3];
            _departamentoTxt = dataCartera[0].dprtmnto;
            _municipio = dataCartera[0].mncpio;
            controlleemail.text = dataCartera[0].email;
            _llenarListas(dataSoat, dataDepartamento, dataMunicipio);

            formData = {
              'Departamento': _departamentoget + '-' + _departamentoTxt,
              'Municipio': _municipioget + '-' + _municipio,
            };
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    child: Form(
                      key: _formKeydeclara,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    'INFORMACION DEL SOAT',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Divider(),
                                  DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: _soat,
                                    iconSize: 24,
                                    elevation: 0,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.directions_car_filled_outlined,
                                      ),
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(),
                                      labelText: 'Compañia SOAT',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.black,
                                      hoverColor: Colors.black,
                                      isDense: true,
                                    ),
                                    items:
                                        _listSoat.map<
                                          DropdownMenuItem<String>
                                        >((SoapSOAT value) {
                                          return DropdownMenuItem<String>(
                                            value:
                                                '${value.dgto_vrfccion!}-${value.nmbre_asgrdra!}-${value.idntfccion_asgrdra!}',
                                            child: Text(value.nmbre_asgrdra!),
                                          );
                                        }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _soat = newValue!;
                                      });
                                    },
                                  ),
                                  Divider(),
                                  TextField(
                                    controller: controllernit,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.filter_frames_outlined,
                                      ),
                                      isDense: true,
                                      fillColor: Colors.black,
                                      hoverColor: Colors.black,
                                      focusColor: Colors.black,
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      labelText: 'NIT',
                                      enabled: false,
                                    ),
                                  ),
                                  Divider(),
                                  TextField(
                                    controller: controllerDv,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.verified_user_outlined,
                                      ),
                                      isDense: true,
                                      fillColor: Colors.black,
                                      hoverColor: Colors.black,
                                      focusColor: Colors.black,
                                      border: OutlineInputBorder(),
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                      labelText: 'DV',
                                      enabled: false,
                                    ),
                                  ),
                                  Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: controllerfecha,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                  isDense: true,
                                                  fillColor: Colors.black,
                                                  hoverColor: Colors.black,
                                                  focusColor: Colors.black,
                                                  border: OutlineInputBorder(),
                                                  labelStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  labelText:
                                                      'Fecha de vencimiento SOAT',
                                                  enabled: false,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50.0,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.blue.shade900,
                                                  backgroundColor:
                                                      Colors
                                                          .blue
                                                          .shade900, // foreground
                                                ),
                                                onPressed: () async {
                                                  var fechaFormateada;
                                                  datePicked =
                                                      await DatePicker.showSimpleDatePicker(
                                                        context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime(
                                                          1990,
                                                        ),
                                                        lastDate: DateTime(
                                                          2022,
                                                        ),
                                                        dateFormat:
                                                            "dd-MMMM-yyyy",
                                                        locale:
                                                            DateTimePickerLocale
                                                                .es,
                                                        looping: true,
                                                      );

                                                  if (datePicked == null) {
                                                    fechaFormateada = '';
                                                  } else {
                                                    fechaFormateada =
                                                        DateFormat.yMd().format(
                                                          datePicked,
                                                        );
                                                  }
                                                  controllerfecha.text =
                                                      fechaFormateada;
                                                },
                                                child: Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.white,
                                                  size: 25.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'INFORMACION DEL DECLARANTE',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 15.0,
                                      bottom: 15.0,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: controllernombreP,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.person_outline,
                                                ),
                                                isDense: true,
                                                fillColor: Colors.black,
                                                hoverColor: Colors.black,
                                                focusColor: Colors.black,
                                                labelText:
                                                    'Nombre Completo o Razón Social',
                                                border: OutlineInputBorder(),
                                                enabled: false,
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60.0,
                                            child: TextField(
                                              controller: controllertipoId,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                fillColor: Colors.black,
                                                hoverColor: Colors.black,
                                                focusColor: Colors.black,
                                                labelText: 'Tipo',
                                                border: OutlineInputBorder(),
                                                enabled: false,
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    child: TextField(
                                      controller: controllercedula,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.remember_me),
                                        isDense: true,
                                        fillColor: Colors.black,
                                        hoverColor: Colors.black,
                                        focusColor: Colors.black,
                                        labelText: 'Numero NIT/Cedula',
                                        border: OutlineInputBorder(),
                                        enabled: false,
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: controllertel,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      validator: (value) {
                                        return value!.length < 10
                                            ? 'Teléfono incorrecto'
                                            : null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.phone),
                                        isDense: true,
                                        fillColor: Colors.black,
                                        hoverColor: Colors.black,
                                        focusColor: Colors.black,
                                        labelText: 'Teléfono Celular',
                                        border: OutlineInputBorder(),
                                        enabled: true,
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 0.0,
                                      right: 0.0,
                                    ),
                                    child: TextFormField(
                                      validator:
                                          (input) =>
                                              isEmail(controlleemail.text)
                                                  ? null
                                                  : "Correo no valido",
                                      controller: controlleemail,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        isDense: true,
                                        fillColor: Colors.black,
                                        hoverColor: Colors.black,
                                        focusColor: Colors.black,
                                        border: OutlineInputBorder(),
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        labelText: 'Correo',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 0.0,
                                      right: 0.0,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: controllerdireccion,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.location_city,
                                                ),
                                                isDense: true,
                                                fillColor: Colors.black,
                                                hoverColor: Colors.black,
                                                focusColor: Colors.black,
                                                labelText: 'Dirección',
                                                border: OutlineInputBorder(),
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              validator: (String? valueDir) {
                                                if (valueDir == null ||
                                                    valueDir.isEmpty) {
                                                  print('False');
                                                  return 'Debe digitar la dirección';
                                                }
                                                controllerdireccion.text =
                                                    valueDir;
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50.0,
                                            child: TextField(
                                              controller: controllerdvprop,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                fillColor: Colors.black,
                                                hoverColor: Colors.black,
                                                focusColor: Colors.black,
                                                labelText: 'DV',
                                                border: OutlineInputBorder(),
                                                enabled: false,
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 50.0,
                                      left: 0.0,
                                      right: 0.0,
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              child: DropDownField(
                                                itemsVisibleInDropdown: 5,
                                                textStyle: TextStyle(
                                                  fontSize: 16,
                                                ),
                                                value: formData['Departamento'],
                                                icon: Icon(Icons.location_city),
                                                required: true,
                                                hintText: 'Departamento',
                                                labelText: 'Departamento',
                                                items: _listDep,
                                                strict: false,
                                                onValueChanged: (
                                                  newValue,
                                                ) async {
                                                  List<String> split = [];
                                                  split = newValue.split("-");
                                                  _departamento.add(split[1]);

                                                  _listMun.clear();
                                                  value = await mapaProvider
                                                      .getMunicipio(
                                                        _departamento.first,
                                                      );

                                                  for (
                                                    int i = 0;
                                                    i < value.length;
                                                    i++
                                                  ) {
                                                    _listMun.add(
                                                      value[i].cdgo_mncpio! +
                                                          '-' +
                                                          value[i]
                                                              .nmbre_mncpio!,
                                                    );
                                                  }
                                                },
                                                setter: (dynamic newValue) {
                                                  formData['Departamento'] =
                                                      newValue;
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 15.0,
                                              color: Colors.grey,
                                            ),
                                            DropDownField(
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                              ),
                                              value: formData['Municipio'],
                                              icon: Icon(Icons.map),
                                              required: true,
                                              hintText: 'Municipio',
                                              labelText: 'Municipio',
                                              items: _listMun,
                                              setter: (dynamic newValue) {
                                                _municipio = newValue;
                                                formData['Municipio'] =
                                                    newValue;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Footer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.blue.shade900,
        // icon: Icons.menu,
        child: Icon(Icons.menu, color: Colors.white, size: 25.0),
        activeIcon: Icons.close,
        foregroundColor: Colors.white,
        spacing: 2,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        buttonSize: buttonSize,
        label: extend ? const Text("Abrir") : null,
        activeLabel: extend ? const Text("Cerrar") : null,
        childrenButtonSize: childrenButtonSize,
        visible: visible,
        direction: speedDialDirection,
        switchLabelPosition: switchLabelPosition,
        closeManually: closeManually,
        renderOverlay: renderOverlay,
        onOpen: () => debugPrint('ABRIR MENU'),
        onClose: () => debugPrint('CERRAR MENU'),
        useRotationAnimation: useRAnimation,
        tooltip: 'Menu de opciones',
        heroTag: 'speed-dial-hero-tag',
        elevation: 8.0,
        isOpenOnStart: false,
        shape:
            customDialRoot
                ? const RoundedRectangleBorder()
                : const StadiumBorder(),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.home),
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            label: 'INICIO',
            onTap:
                () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SecondScreen()),
                  (Route<dynamic> route) => false,
                ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.arrow_back_ios),
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            label: 'ATRAS',
            onTap: () => Navigator.pop(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.print),
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            label: 'IMPRIMIR',
            onTap: () {
              if (_formKeydeclara.currentState!.validate()) {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (dropdownValueMun != '0-Seleccione' ||
                      dropdownValue != '0-Seleccione') {
                    _onLoadingPage(context, 1);
                  } else {
                    print('Seleccione el departamento y municipio correcto');
                  }
                }
              }
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.payment),
            backgroundColor: Colors.blue.shade900,
            foregroundColor: Colors.white,
            label: 'PAGAR PSE',
            onTap: () {
              if (_formKeydeclara.currentState!.validate()) {
                _formKeydeclara.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _onLoadingPage(context, 2);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> load() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<void> _onLoadingPage(context, tipo) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyCircularProgress();
      },
    );
    await load();
    if (tipo == 1) {
      downloadFile(context, 1);
    } else {
      downloadFile(context, 2);
    }
  }

  void botones() {
    // ignore: deprecated_member_use
    // childButtons = List<UnicornButton>();
    // childButtons.add(UnicornButton(
    //     hasLabel: true,
    //     labelText: "Imprimir",
    //     currentButton: FloatingActionButton(
    //       heroTag: "Imprimir",
    //       backgroundColor: Colors.blue.shade900,
    //       mini: true,
    //       child: Icon(Icons.local_print_shop_outlined),
    //       onPressed: () {
    //         if (_formKeydeclara.currentState.validate()) {
    //           if (_formKey.currentState.validate()) {
    //             _formKey.currentState.save();
    //             if (dropdownValueMun != '0-Seleccione' ||
    //                 dropdownValue != '0-Seleccione') {
    //               _onLoadingPage(context, 1);
    //             } else {
    //               print('Seleccione el departamento y municipio correcto');
    //             }
    //           }
    //         }
    //       },
    //     )));

    // childButtons.add(UnicornButton(
    //     hasLabel: true,
    //     labelText: "Pagar PSE",
    //     currentButton: FloatingActionButton(
    //       heroTag: "Pagar PSE",
    //       backgroundColor: Colors.blue.shade900,
    //       mini: true,
    //       child: Icon(Icons.monetization_on_outlined),
    //       onPressed: () async {
    //         print(_formKeydeclara.currentState.validate());
    //         print(_formKey.currentState.validate());
    //         if (_formKeydeclara.currentState.validate()) {
    //           _formKeydeclara.currentState.save();
    //           if (_formKey.currentState.validate()) {
    //             _formKey.currentState.save();
    //             _onLoadingPage(context, 2);
    //           }
    //         }
    //       },
    //     )));

    // childButtons.add(UnicornButton(
    // hasLabel: true,
    // labelText: "Inicio",
    // currentButton: FloatingActionButton(
    //   heroTag: "Inicio",
    //   backgroundColor: Colors.blue.shade900,
    //   mini: true,
    //   child: Icon(Icons.home),
    //   onPressed: () {
    //     Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => SecondScreen()),
    //         (Route<dynamic> route) => false);
    //   },
    // )));
  }

  downloadFile(context, tipo) async {
    List<String> parte1 = [];
    List<String> parte2 = [];
    parte1 = formData['Departamento'].split("-");
    parte2 = formData['Municipio'].split("-");
    String _codigdepartamento = parte1[0];
    String _departamento = parte1[1];
    String _codigmuni = parte2[0];
    String _municipio = parte2[1];
    String direccion = controllerdireccion.text;
    String telefono = controllertel.text;
    String correo = controlleemail.text;
    String nitSOAT = controllernit.text;
    String nombreSOAT = controlleAseguradora.text;
    String dvSOAT = controllerDv.text;
    String fechaSOAT = controllerfecha.text;
    if (fechaSOAT == null) {
      fechaSOAT = '';
    }
    List l = widget.itemElementos;
    double valorPagar = double.parse(l[9].vlor);
    double valorMunicipio = (valorPagar * 20) / 100;
    double valorDepartamento = (valorPagar * 80) / 100;

    String v1 = valorPagar.toInt().toString();
    String v2 = valorMunicipio.toInt().toString();
    String v3 = valorDepartamento.toInt().toString();
    String v4Pro = l[6].vlor;
    String valoritem1 = l[0].vlor;
    String valoritem2 = l[1].vlor;
    String valoritem3 = l[2].vlor;
    String valoritem4 = l[3].vlor;
    String valoritem5 = l[4].vlor;
    String valoritem6 = l[5].vlor;
    String valoritem8 = l[7].vlor;
    String valoritem9 = l[8].vlor;

    List<SoapModelRegistroLiquida> registro = await mapaProvider
        .getRegistroLiquida(
          widget.data,
          widget.placa,
          widget.infoVeh,
          widget.cartera,
          widget.vigencia,
          widget.fechalimite,
          _codigdepartamento,
          _departamento,
          _codigmuni,
          _municipio,
          direccion,
          telefono,
          correo,
          nitSOAT,
          nombreSOAT,
          fechaSOAT,
          v1,
          v2,
          v3,
          (tipo == 0) ? 'S' : 'N',
        );
    if (registro.isEmpty) {
    } else {
      String preImpreso = registro[0].pnmroprmprso!;
      //String pcnsctvo = registro[0].pcnsctvo;
      //String prgstro = registro[0].prgstro;

      if (registro[0].prgstro == '1') {
        String url = Url_DEC;
        String valores =
            'placaVeh=' +
            widget.placa +
            '&vigenciDeclaradaVeh=' +
            widget.vigencia +
            '&fechaPago=' +
            widget.fechalimite +
            '&idDeclarante=' +
            widget.infoVeh[0].p_idntfccion_prptrios! +
            '&dvDec=' +
            widget.data[0].dgtovrfccion! +
            '&tipoidDec=' +
            widget.data[0].tpoidntfccion! +
            '&socialDeclarante=' +
            widget.data[0].nmbreprptrio! +
            '&dirDec=' +
            direccion +
            '&emailDec=' +
            correo +
            '&telefono=' +
            telefono +
            '&marcaDscripcion=' +
            widget.infoVeh[0].p_dscrpcion_mrca! +
            '&lineaDescripcion=' +
            widget.infoVeh[0].p_dscrpcion_lnea! +
            '&modeloDescripcion=' +
            widget.infoVeh[0].p_mdlo! +
            '&claseDescripcion=' +
            widget.infoVeh[0].p_dscrpcion_clse! +
            '&carroceriaDescripcion=' +
            widget.infoVeh[0].p_dscrpcion_crrcria! +
            '&blindajeDescripcion=' +
            widget.infoVeh[0].p_dscripcion_blndje! +
            '&cilindrajeVeh=' +
            widget.infoVeh[0].p_clndrje! +
            '&cap_pasajerosVeh=' +
            widget.infoVeh[0].p_cpcdad_psjros! +
            '&cap_cargaVeh=' +
            widget.infoVeh[0].p_cpcdad_crga! +
            '&nitSoat=' +
            nitSOAT +
            '&soatVeh=' +
            nombreSOAT +
            '&polizaNum=&dvSoat=' +
            dvSOAT +
            '&fechaVencimientoSoat=' +
            fechaSOAT +
            '&valorPagar=' +
            v1 +
            '&valorProelec=' +
            v4Pro +
            '&primpreso=' +
            preImpreso +
            '&valoritem1=' +
            valoritem1 +
            '&valoritem2=' +
            valoritem2 +
            '&valoritem3=' +
            valoritem3 +
            '&valoritem4=' +
            valoritem4 +
            '&valoritem5=' +
            valoritem5 +
            '&valoritem6=' +
            valoritem6 +
            '&valoritem8=' +
            valoritem8 +
            '&valoritem9=' +
            valoritem9 +
            '&departamentoDes=' +
            _departamento +
            '&municipioDes=' +
            _municipio +
            '&imprimir=SI&departamentoCod=' +
            _codigdepartamento +
            '&municipioCod=' +
            _codigmuni +
            '';

        String myurl = url + valores;
        String filename =
            "Declaración" + widget.placa + "_" + widget.vigencia + ".pdf";

        File file = File('');
        if (Platform.isAndroid) {
          if (await ApiPermisos.requestWritePermission()) {
            file = (await PDFApi.loadNetwork(url: myurl, filename: filename))!;
          } else {}
        } else {
          file = (await PDFApi.loadNetwork(url: myurl, filename: filename))!;
        }

        if (tipo == 1) {
          Navigator.pop(context);
          openPDF(context, file, 'Declaración');
        } else {
          Navigator.pop(context);

          openPSE(
            context,
            widget.placa,
            _codigdepartamento,
            preImpreso,
            v1,
            v2,
            v3,
            widget.data,
            _codigmuni,
            widget.infoVeh,
          );
        }
      } else {
        print('No se registro la declaracion');
      }
    }
  }

  void openPSE(
    BuildContext context,
    placa,
    _codigdepartamento,
    preImpreso,
    v1,
    v2,
    v3,
    data,
    _codigmuni,
    infoVeh,
  ) => Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (context) => Tab_E(
            infoVeh: infoVeh,
            placa: placa,
            codigdepartamento: _codigdepartamento,
            preImpreso: preImpreso,
            v1: v1,
            v2: v2,
            v3: v3,
            data: data,
            codigmuni: _codigmuni,
          ),
    ),
  );

  void openPDF(BuildContext context, File file, String nombre) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) =>
                  PageEstadoCuenta(file: file, nombre: nombre, infoVehi: []),
        ),
      );

  final List<String> listSi = ['Si', 'No'];

  Future<void> getData() async {
    value = await mapaProvider.getMunicipio(_departamento.first);
    dropdownMenuOptionsMun =
        value
            .map(
              (value) => DropdownMenuItem<String>(
                value: value.cdgo_mncpio! + '-' + value.nmbre_mncpio!,
                child: Container(
                  padding: const EdgeInsets.only(top: 0, bottom: 0),
                  width: 300,
                  child: Text(
                    value.cdgo_mncpio! + '-' + value.nmbre_mncpio!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 1,
                    ),
                  ),
                ),
              ),
            )
            .toList();
  }

  void _llenarListas(dataSoat, dataDepartamento, dataMunicipio) {
    _listSoat = [];
    _listDep = [];
    _listMun = [];
    if (dataSoat != null) {
      for (int i = 0; i < dataSoat.length; i++) {
        _listSoat.add(
          SoapSOAT(
            dgto_vrfccion: dataSoat[i].dgto_vrfccion,
            idntfccion_asgrdra: dataSoat[i].idntfccion_asgrdra,
            nmbre_asgrdra: dataSoat[i].nmbre_asgrdra,
          ),
        );
      }
    }
    if (dataDepartamento != null) {
      for (int i = 0; i < dataDepartamento.length; i++) {
        _listDep.add(
          dataDepartamento[i].cdgodprtmnto + '-' + dataDepartamento[i].nmbre,
        );
      }
    }
    if (dataMunicipio != null) {
      for (int i = 0; i < dataMunicipio.length; i++) {
        _listMun.add(
          dataMunicipio[i].cdgo_mncpio + '-' + dataMunicipio[i].nmbre_mncpio,
        );
      }
    }
  }

  @override
  void dispose() {
    controllertel.dispose();
    super.dispose();
  }
}
