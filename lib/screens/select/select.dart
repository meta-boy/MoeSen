import 'package:flutter/material.dart';
import 'package:moe_client/constants/colors.dart';
import 'package:moe_client/screens/select/radiocard.dart';

class Select extends StatefulWidget {
  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        title: Text("Select Radio"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RadioCard(
                text: "J-POP",
                uri: "lib/assets/original.gif",
                musicStream: "https://listen.moe/fallback",
                socketUrl: "wss://listen.moe/gateway_v2",
              ),
              
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RadioCard(
                text: "K-POP",
                uri: "lib/assets/tzuyu.gif",
                musicStream: "https://listen.moe/kpop/fallback",
                socketUrl: "wss://listen.moe/kpop/gateway_v2",
              ),
              
            )
          ],
        ),
      ),
    );
  }
}