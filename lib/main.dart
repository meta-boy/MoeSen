import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe_client/constants/colors.dart';
import 'package:moe_client/screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'listen.moe',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: hotPink,
        primarySwatch: Colors.pink,
      ),
      home: Splash(),
    );
  }
}
