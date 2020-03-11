import 'package:flutter/material.dart';
import 'package:moe_client/constants/colors.dart';

class LogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(text: TextSpan(
        children: [
          TextSpan(text: "LISTEN", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w800)),
          TextSpan(text: ".moe", style: TextStyle(fontSize: 30, color: darkBlue,fontWeight: FontWeight.w800))
        ]
      ),),
    );
  }
}