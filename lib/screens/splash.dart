import 'package:flutter/material.dart';
import 'package:moe_client/constants/colors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hotPink,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: darkBlue, 
                        offset: Offset(0, 5),
                        blurRadius: 100,
                        // spreadRadius: 5
                      )
                    ],
                    color: darkBlue, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("lib/assets/logo.png"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
