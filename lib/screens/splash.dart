import 'package:flutter/material.dart';
import 'package:moe_client/constants/colors.dart';
import 'package:moe_client/constants/logotext.dart';
import 'package:moe_client/screens/select/select.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((onValue) =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Select())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hotPink,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
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
                          color: darkBlue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset("lib/assets/logo.png"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    LogoText(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width,
              bottom: -1,
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(darkBlue),
              ))
        ],
      ),
    );
  }
}
