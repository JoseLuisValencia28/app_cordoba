import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class PageViewPdf extends StatefulWidget {
  final int? tipo;
  final String? path;
  final File file;
  final String? nombre;
  final BuildContext contextpadre;

  const PageViewPdf({
    this.tipo,
    this.path,
    required this.file,
    this.nombre,
    required this.contextpadre,
    Key? key,
  }) : super(key: key);

  @override
  _PageViewPdfState createState() => _PageViewPdfState();
}

class _PageViewPdfState extends State<PageViewPdf> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    movefile();
    super.initState();
  }

  Future<void> movefile() async {
    try {
      if (Platform.isAndroid) {
        await File(widget.file.path)
            .copy('/storage/emulated/0/Download/${widget.nombre}');
      }
    } catch (e) {
      debugPrint('Error al mover el archivo: $e');
    }
  }

  late BuildContext contextBody;
  String text = 'Documento no Existe';
  String subject = 'Archivo PDF';

  @override
  Widget build(BuildContext context) {
    contextBody = context;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final name = widget.nombre ?? 'Documento sin título';
    final text = '${indexPage + 1} de $pages';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(contextBody),
        ),
        elevation: 0,
        toolbarHeight: 90.0,
        iconTheme: IconThemeData(color: Colors.blue.shade900),
        backgroundColor: Colors.blue.shade900,
        title: SizedBox(
          child: Text(
            name,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: pages >= 2
            ? [
                Center(
                    child: Text(text,
                        style: const TextStyle(color: Colors.white))),
                IconButton(
                  icon: const Icon(Icons.chevron_left,
                      size: 32, color: Colors.white),
                  onPressed: () {
                    final page = indexPage == 0 ? pages : indexPage - 1;
                    controller.setPage(page);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right,
                      size: 32, color: Colors.white),
                  onPressed: () {
                    final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                    controller.setPage(page);
                  },
                ),
              ]
            : null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PDFView(
              filePath: widget.file.existsSync() ? widget.file.path : null,
              autoSpacing: true,
              swipeHorizontal: true,
              pageSnap: true,
              pageFling: true,
              onRender: (pages) => setState(() => this.pages = pages!),
              onViewCreated: (controller) =>
                  setState(() => this.controller = controller),
              onPageChanged: (indexPage, _) =>
                  setState(() => this.indexPage = indexPage!),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.blue.shade900,
        icon: Icons.menu,
        activeIcon: Icons.close,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        children: [
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
    );
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    List<String> pdfPaths = [widget.file.path];

    if (widget.file.path.isNotEmpty) {
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
    if (widget.file.path.isNotEmpty) {
      openFile();
    }
  }

  Future<void> openFile() async {
    if (widget.file.path.isNotEmpty) {
      await OpenFile.open(widget.file.path);
    }
  }
}
