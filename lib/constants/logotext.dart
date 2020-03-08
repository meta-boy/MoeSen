import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(text: TextSpan(
        children: [
          TextSpan(text: "LISTEN"),
          TextSpan(text: ".moe")
        ]
      ),),
    );
  }
}