// ignore_for_file: use_super_parameters, prefer_const_constructors_in_immutables, library_private_types_in_public_api, unnecessary_cast, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_cordoba/modelo/model_index_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_cordoba/widget/widget_card_portal.dart';
import 'package:app_cordoba/widget/widget_footer.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Informatica y Tributos',
      home: InicioImpueto(),
    );
  }
}

class InicioImpueto extends StatefulWidget {
  InicioImpueto({Key? key}) : super(key: key);

  @override
  _SecondScreen createState() => _SecondScreen();
}

class _SecondScreen extends State<InicioImpueto> {
  bool ok = false;
  int versionFull = 0;
  int storeVersionFull = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<String> litems = [];
  late BuildContext dialogHome;

  PageController controllerIndex = PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.8,
  );
  int indexPage = 0;
  int radioVal = 0;
  int valor = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 170.0,
        flexibleSpace: CarouselSlider(
          options: CarouselOptions(
            height: 250.0,
            enlargeCenterPage: true,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 8),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.fastOutSlowIn,
            disableCenter: true,
            scrollDirection: Axis.horizontal,
          ),
          items:
              img.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: i.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                    );
                  },
                );
              }).toList(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(8),
              child: Image.asset('assets/images/escudo.jpg', height: 150),
            ),
            Flexible(
              flex: 4,
              child: PageView.builder(
                itemCount: 2,
                controller: controllerIndex,
                onPageChanged:
                    (int index) => setState(() {
                      indexPage = index;
                      radioVal = index;
                      valor = index;
                    }),
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == indexPage ? 1 : 0.9,
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.green.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: PortalCard(index: i),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...[0, 1]
                        .map(
                          (e) => Radio(
                            fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue.shade900,
                            ),
                            focusColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue.shade900,
                            ),
                            value: e,
                            groupValue: valor,
                            onChanged: (value) {
                              setState(() {
                                valor = (value as int?) ?? valor;
                                controllerIndex.animateToPage(
                                  valor,
                                  curve: Curves.linear,
                                  duration: const Duration(milliseconds: 300),
                                );
                              });
                            },
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Footer(),
          ],
        ),
      ),
    );
  }
}
