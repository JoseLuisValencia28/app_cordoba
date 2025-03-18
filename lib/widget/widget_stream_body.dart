// import 'dart:async';
// import 'dart:io';

// import 'package:dart_ping_ios/dart_ping_ios.dart';
// import 'package:flutter/material.dart';
// import 'package:app_cordoba/api/certificate.dart';
// import 'package:app_cordoba/widget/widget_offline.dart';
// import 'package:upgrader/upgrader.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// class WidgetStream extends StatefulWidget {
//   final Widget widgetbody;

//   const WidgetStream({Key? key, required this.widgetbody}) : super(key: key);

//   @override
//   State<WidgetStream> createState() => _MyAppState();
// }

// class _MyAppState extends State<WidgetStream> {
//   final InternetConnectionChecker customInstance =
//       InternetConnectionChecker.createInstance(
//         checkTimeout: const Duration(seconds: 1),
//         checkInterval: const Duration(seconds: 1),
//       );

//   final StreamController<bool> controller = StreamController<bool>.broadcast();
//   late StreamSubscription<InternetConnectionStatus> _connectivitySubscription;

//   @override
//   void initState() {
//     HttpOverrides.global = MyHttpOverrides();
//     DartPingIOS.register();

//     super.initState();

//     _connectivitySubscription = customInstance.onStatusChange.listen((status) {
//       print("Estado de conexión detectado: $status"); // Debugging

//       switch (status) {
//         case InternetConnectionStatus.connected:
//           controller.add(true);
//           break;
//         case InternetConnectionStatus.disconnected:
//         case InternetConnectionStatus
//             .slow: // Manejar estado lento como desconectado
//           controller.add(false);
//           break;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return UpgradeAlert(
//       child: Scaffold(
//         body: StreamBuilder<bool>(
//           stream: controller.stream,
//           builder: (context, snapshot) {
//             print(
//               "Valor recibido en StreamBuilder: ${snapshot.data}",
//             ); // Debugging

//             if (snapshot.connectionState == ConnectionState.waiting ||
//                 snapshot.data == false) {
//               return const Center(child: Offline());
//             } else {
//               return MediaQuery(
//                 data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//                 child: widget.widgetbody,
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _connectivitySubscription.cancel();
//     controller.close();
//     super.dispose();
//   }
// }
