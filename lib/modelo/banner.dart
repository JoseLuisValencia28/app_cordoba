import 'package:flutter/material.dart';

class BannerVehiculos {
  String? titulo;
  String? categoria;
  IconData? icono;
  BannerVehiculos({
    this.titulo,
    this.categoria,
    this.icono,
  });

  List<BannerVehiculos> bannerList = [];

  List<BannerVehiculos> generarBaner() {
    bannerList.clear();

    bannerList.add(BannerVehiculos(
        titulo: "Declaración Impuesto de Vehículo",
        categoria: "Portal de Vehículos",
        icono: Icons.search));
    bannerList.add(BannerVehiculos(
        titulo: "Consulta estado de cuenta",
        categoria: "Portal de Vehículos",
        icono: Icons.book));
    bannerList.add(BannerVehiculos(
        titulo: "Solicitud de paz y salvo",
        categoria: "Portal de Vehículos",
        icono: Icons.library_books));
    bannerList.add(BannerVehiculos(
        titulo: "Ordenanzas",
        categoria: "Normatividad",
        icono: Icons.library_books));
    bannerList.add(BannerVehiculos(
        titulo: "Decretos",
        categoria: "Normatividad",
        icono: Icons.library_books));
    bannerList.add(BannerVehiculos(
        titulo: "Resoluciones",
        categoria: "Normatividad",
        icono: Icons.library_books));
    bannerList.add(BannerVehiculos(
        titulo: "Circulares",
        categoria: "Normatividad",
        icono: Icons.library_books));
    return bannerList;
  }
}
