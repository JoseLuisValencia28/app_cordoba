import 'package:flutter/material.dart';

TextStyle styleform = TextStyle(
  fontSize: 18,
  color: Colors.blue.shade900,
  fontStyle: FontStyle.normal,
);
InputDecoration decorationform = InputDecoration(
  labelStyle: TextStyle(
    fontSize: 16,
    color: Colors.blue.shade900,
    fontStyle: FontStyle.normal,
  ),
  labelText: '',
  isDense: false,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue.shade900),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
  ),
  border: const OutlineInputBorder(),
);
