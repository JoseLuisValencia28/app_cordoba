// ignore_for_file: unused_import, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';
import 'views/Index/soap_page_index.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: UpgradeAlert(
          upgrader: Upgrader(debugLogging: false),
          child: SecondScreen(),
        ),
      ),
    );
  }
}
