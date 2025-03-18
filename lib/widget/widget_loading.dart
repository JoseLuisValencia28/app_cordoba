import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//48230
loadingindicator({required BuildContext context}) {
  late BuildContext contextload;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      contextload = context;
      return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator()
            : CupertinoActivityIndicator(),
      );
    },
  );
  return contextload;
}
