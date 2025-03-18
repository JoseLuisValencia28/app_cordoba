// ignore_for_file: unused_field

import 'dart:async';

import 'package:dart_ping/dart_ping.dart';

class ConnectivityInternet {
  bool resultado = false;
  Future<bool> initConnectivity() async {
    var pingFn2 = await pingFn();
    if (pingFn2.toString().contains("ttl")) {
      resultado = true;
    } else {
      resultado = false;
    }
    // try {
    //   // final result = await InternetAddress.lookup("8.8.8.8")
    //   //     .timeout(const Duration(seconds: 3));

    // } on SocketException catch (e) {
    //   resultado = false;

    //   throw FetchDataException('No Internet connection $e');
    // } on TimeoutException catch (e) {
    //   resultado = false;

    //   throw FetchDataException('Timeout Internet connection $e');
    // } on Error catch (e) {
    //   resultado = false;
    //   throw FetchDataException('$e');
    // }
    return resultado;
  }

  Future<PingData> pingFn() async {
    Ping ping = Ping('google.com', count: 3);

    return await ping.stream.first;
  }
}
