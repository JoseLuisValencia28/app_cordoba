import 'dart:math';
import 'package:flutter/material.dart';

List<PdfWebClas> itemsPdf = [
  PdfWebClas(
    nombreText: 'Ordenanza 02 de 2015 mdf E.R.',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza%2002%20de%202.015%20Mdf%20E.R..pdf',
  ),
  PdfWebClas(
    nombreText: 'Ordenanza 06 de 2016 mdf E.R.',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza%2006%20de%202.016%20Mdf%20E.R..pdf',
  ),
  PdfWebClas(
    nombreText: 'Ordenanza 07 de 2012',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza%2007%20de%202.012.pdf',
  ),
  PdfWebClas(
    nombreText: 'Ordenanza 09 de 2015 mdf E.R.',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza%2009%20de%202.015%20Mdf%20E.R..pdf',
  ),
  PdfWebClas(
    nombreText: 'Ordenanza 20 de 2013 mdf E.R.',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza%2020%20de%202.013%20Mdf%20E.R..pdf',
  ),
  PdfWebClas(
    nombreText: 'Ordenanza 21 de 2016 mdf E.R.',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza%2021%20de%202.016%20Mdf%20E.R..pdf',
  ),
  PdfWebClas(
    nombreText: 'Ordenanza 31 de 2016',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza_31%20de_2016_Monopolio_Licores.pdf',
  ),
  PdfWebClas(
    nombreText: 'Ordenanza 04 de 2018',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Ordenanza_04_2018.pdf',
  ),
];
List<PdfWebDecretos> itemsPdfDecretos = [
  PdfWebDecretos(
    nombreText: 'DECRETO 1148 DE 2016',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/DECRETO%201148%20DE%202016.PDF',
  ),
  PdfWebDecretos(
    nombreText: 'DECRETO 0034 DE 2017',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Decreto_0034_de_2017.pdf',
  ),
  PdfWebDecretos(
    nombreText: 'DECRETO 0184 DE 2017',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Decreto_0184_de_2017.pdf',
  ),
  PdfWebDecretos(
    nombreText: 'DECRETO 0203 DE 2017',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Decreto_0203_de-2017.pdf',
  ),
  PdfWebDecretos(
    nombreText: 'DECRETO 0698 DE 2017',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/DECRETO%200698%20DE%202017.pdf',
  ),
  PdfWebDecretos(
    nombreText: 'DECRETO 0640 DE 2018',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/DECRETO_0640_DE_2018.PDF',
  ),
  PdfWebDecretos(
    nombreText: 'DECRETO 0815 DE 2019',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/DECRETO_0815_2019.pdf',
  ),
];

List<PdfWebResoluciones> itemsPdfRes = [
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0237 DE 2016',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Resolucion%200237%20de%202016.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0251 DE 2016 CERVEZAS',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/R-0251_CERVEZA.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0250 DE 2016 LICORES',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/R-0250_LICORES.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0249 DE 2016 CIGARRIILO',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/R-0249_CIGARRILLO.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0345 DE 2017',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/Resolucion%200345%20de%202017.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0016 DE 2018',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/RESOLUCION_0016_2018.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0326 DE 2018',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/RES_0326_DE_27_DE_DIC_2018.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0327 DE 2018',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/RES_0327_%20DE_%2027_DE_NOV_DE_2018.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0328 DE 2018',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/RES_0328_DE_27_DE_DIC_DE_2018.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0329 DE 2018',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/RES_0329_DE_27_DE_DIC_DE_%202018.PDF',
  ),
  PdfWebResoluciones(
    nombreText: 'RESOLUCIÓN 0266 DE 2019',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/RESOLUCION_0266_2019.pdf',
  ),
];
List<PdfWebCirculares> itemsPdfCircula = [
  PdfWebCirculares(
    nombreText: 'CIRCULAR 0021 DE 2016',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/CIRCULAR%200021%20DE%202016.PDF',
  ),
  PdfWebCirculares(
    nombreText: 'CIRCULAR 03 DE 2017',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/CIRCULAR_03_de%202017.pdf',
  ),
  PdfWebCirculares(
    nombreText: 'CIRCULAR 07 DE 2017',
    url:
        'https://ftp.cordoba.gobiernoit.com/PUBLICACIONESWEB/CIRCULAR_07_de%202017.pdf',
  ),
];

List<GridListItems> items = [
  GridListItems(
    color: Colors.green,
    title: 'Impuesto Vehicular',
    icon: "assets/images/ic_car.png",
    lista: [
      'Declaración Impuesto de Vehículo',
      'Consulta',
      'Notificaciones por aviso',
      'Solicitud de Paz y Salvo',
    ],
  ),
  GridListItems(
    color: Color(DateTime.august),
    title: 'Normatividad',
    icon: "assets/images/ic_book.png",
    lista: ['Ordenanzas', 'Decretos', 'Resoluciones', 'Circulares'],
  ),
];

List<GridListItems2> itemList = [
  GridListItems2(
    title: 'Ver Estado de Cuenta',
    icon: "assets/images/ic_estadodecuenta.png",
  ),
  GridListItems2(
    title: 'Declaraciones Presentadas',
    icon: "assets/images/ic_declaraciones.png",
  ),
  GridListItems2(
    title: 'Generar Recibo de Pago',
    icon: "assets/images/ic_factura.png",
  ),
  GridListItems2(
    title: 'Genera Recibo de Pago Convenio',
    icon: "assets/images/ic_convenio_web.png",
  ),
];
List<Imagenes> img = [
  // Imagenes(image: AssetImage("assets/images/ic_logo.jpg")),
  Imagenes(image: AssetImage("assets/images/slide1.jpg")),
  Imagenes(image: AssetImage("assets/images/slide2.jpg")),
  Imagenes(image: AssetImage("assets/images/slide3.jpg")),
];
final titulos = <String>[
  'Marca',
  'Linea',
  'Modelo',
  'Clase',
  'Carroceria',
  'Blindaje',
  'Cilindraje',
  'No. Pasajeros',
  'Capacidad Carga',
];

class GridListItems {
  GridListItems({this.color, this.title, required this.icon, this.lista});

  Color? color;
  String? title;
  String icon;
  List<String>? lista;
}

class GridListItems2 {
  GridListItems2({required this.title, required this.icon});
  String title;
  String icon;
}

class DescItems {
  DescItems({required this.title, required this.desc});
  String title;
  String desc;
}

class PdfWebClas {
  PdfWebClas({this.nombreText, this.url});
  String? nombreText;
  String? url;
}

class PdfWebDecretos {
  PdfWebDecretos({this.nombreText, this.url});
  String? nombreText;
  String? url;
}

class PdfWebResoluciones {
  PdfWebResoluciones({this.nombreText, this.url});
  String? nombreText;
  String? url;
}

class PdfWebCirculares {
  PdfWebCirculares({this.nombreText, this.url});
  String? nombreText;
  String? url;
}

class Imagenes {
  Imagenes({this.image});
  AssetImage? image;
}

enum ImpuestoVehicular { Titulo }

enum Sobretasa { Titulo }

enum Estampilla { Titulo }

class RandomColorModel {
  Random random = Random();
  Color getColor() {
    return Color.fromARGB(
      random.nextInt(300),
      random.nextInt(300),
      random.nextInt(300),
      random.nextInt(300),
    );
  }
}
