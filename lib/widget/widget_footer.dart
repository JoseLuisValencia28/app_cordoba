import 'package:flutter/material.dart';
import 'package:app_cordoba/providers/variables.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(14),
      width: double.infinity,
      color: Colors.blue.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            footer_row1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
