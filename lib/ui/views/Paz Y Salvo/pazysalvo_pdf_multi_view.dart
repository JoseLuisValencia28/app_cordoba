// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables, unused_field

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/ui/views/Paz%20Y%20Salvo/pazysalvo_consulta_view.dart';
import 'package:app_cordoba/views/Index/soap_page_index.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_file/open_file.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class PageViewPdfMulti extends StatefulWidget {
  final int? tipo;
  final String? path;
  final List<File>? files;

  final String? nombre;
  final bool? firmado;
  const PageViewPdfMulti({
    this.tipo,
    this.path,
    this.files,
    this.nombre,
    this.firmado,
    Key? key,
  }) : super(key: key);

  @override
  _PageCiewPdfState createState() => _PageCiewPdfState();
}

class _PageCiewPdfState extends State<PageViewPdfMulti> {
  Color colorTheme = Color(0xff0069a2);

  int pages = 0;
  int indexPage = 0;
  List<File> fullList = [];
  bool firma = false;
  var _openResult;
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

  var openResult;
  @override
  void initState() {
    super.initState();

    if (widget.files != null) {
      for (var element in widget.files!) {
        fullList.add(element);
      }
    }

    pages = fullList.length;
    movefile();
  }

  late BuildContext contextBody;
  String text = 'Documento no Existe';
  String subject = 'Archivo PDF';
  List<String> pdfPaths = [];

  Future movefile() async {
    if (Platform.isAndroid) {
      for (var i = 0; i < widget.files!.length; i++) {
        File(widget.files![i].path)
            .copySync('/storage/emulated/0/Download/${widget.nombre}');
      }
    }
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    pdfPaths.clear();
    for (int i = 0; i < fullList.length; i++) {
      pdfPaths.add(fullList[i].path);
    }
    if (pdfPaths.isNotEmpty) {
      await Share.shareXFiles(pdfPaths.cast<XFile>(),
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  _openStorageFile() async {
    if (fullList.isNotEmpty) {
      openFile();
    }
  }

  Future onSelectNotification(String payload) async {
    payload = widget.files![indexPage].path;
    openFile();
  }

  Future<void> openFile() async {
    if (fullList.isNotEmpty) {
      final _result = await OpenFile.open(fullList[indexPage].path);

      setState(() {
        _openResult = "type=${_result.type}  message=${_result.message}";
      });
    }
  }

  PageController controllerPdf =
      PageController(initialPage: 0, keepPage: false);
  final Completer<PDFViewController> controller =
      Completer<PDFViewController>();
  bool isReady = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    contextBody = context;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final text = '${indexPage + 1} de $pages';
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(contextBody).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ViewPazySalvoConsulta(),
              ),
            ),
          ),
          backgroundColor: Colors.blue.shade900,
          elevation: 4,
          toolbarHeight: 90,
          title: Container(
            child: Text(
              'ESTAMPILLAS',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: pages > 1
              ? [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  )
                ]
              : null,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.files!.length,
                controller: controllerPdf,
                onPageChanged: (indexPage) =>
                    setState(() => this.indexPage = indexPage),
                itemBuilder: (context, index) {
                  return PDFView(
                    filePath: widget.files![index].path,
                    fitPolicy: FitPolicy.BOTH,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                    pageSnap: true,
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 42, color: colorTheme),
                    onPressed: () {
                      final page = indexPage == 0 ? pages : indexPage - 1;
                      controllerPdf.jumpToPage(page);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      size: 42,
                      color: colorTheme,
                    ),
                    onPressed: () {
                      final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                      controllerPdf.jumpToPage(page);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.blue.shade900,
          icon: Icons.menu,
          activeIcon: Icons.close,
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
          shape: customDialRoot
              ? const RoundedRectangleBorder()
              : const StadiumBorder(),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.home),
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              label: 'INICIO',
              onTap: () => Navigator.of(contextBody).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SecondScreen()),
                  (Route<dynamic> route) => false),
            ),
            SpeedDialChild(
              child: const Icon(Icons.arrow_back_ios),
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              label: 'ATRAS',
              onTap: () => Navigator.pop(contextBody),
            ),
            SpeedDialChild(
              child: const Icon(Icons.share),
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              label: 'COMPARTIR',
              onTap: () => _onShare(contextBody),
            ),
            SpeedDialChild(
              child: const Icon(Icons.open_in_new),
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              label: 'ABRIR',
              onTap: () => _openStorageFile(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controllerPdf.dispose();
    super.dispose();
  }

  TextStyle textStyle = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
}
