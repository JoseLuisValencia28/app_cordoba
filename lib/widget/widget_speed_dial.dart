import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app_cordoba/modelo/model_index_icon.dart';

import 'package:app_cordoba/views/Index/soap_page_index.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MySpeedDial extends StatefulWidget {
  final List<Botones>? secciones;
  final File? file;
  const MySpeedDial({this.secciones, this.file});

  @override
  State<MySpeedDial> createState() => _MySpeedDialState();
}

class _MySpeedDialState extends State<MySpeedDial> {
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
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.blue.shade900,
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
      heroTag: 'speed-dial-hero-tag-imprimir',
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
          onLongPress: () => debugPrint(''),
        ),
        SpeedDialChild(
          child: const Icon(Icons.arrow_back_ios),
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
          label: 'ATRAS',
          onTap: () => Navigator.pop(context),
        ),
        (widget.secciones!.isNotEmpty)
            ? SpeedDialChild(
              child: const Icon(Icons.share),
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              label: 'COMPARTIR DOCUMENTO',
              onTap:
                  () async => {
                    if (widget.file!.path.isNotEmpty)
                      {
                        await Share.shareXFiles([
                          XFile(widget.file!.path),
                        ], text: 'Aquí tienes el documento.'),
                      },
                  },
            )
            : SpeedDialChild(
              child: null,
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
            ),
      ],
    );
  }
}
