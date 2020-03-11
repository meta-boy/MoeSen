import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moe_client/constants/colors.dart';
import 'package:moe_client/models/socketdata.dart';

class Player extends StatefulWidget {
  Player({this.data, this.album});
  final SocketData data;
  final Album album;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    print(widget.album.image);
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      widget.album.image == null
                          ? "https://listen.moe/_nuxt/img/248c1f3.png"
                          : "https://cdn.listen.moe/covers/" + widget.album.image,
                      fit: BoxFit.cover,
                    ))),
            Positioned(
                right: -1,
                left: -1,
                bottom: -1,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                         
                          colors: [hotPink, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                      borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(16),
                          bottomEnd: Radius.circular(16))),
                  child: Center(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.data.d.song.title,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600)),
                            TextSpan(
                                text: "\n" +
                                    widget.album.name +
                                    " | " +
                                    widget.data.d.song.artists[0].name + " | " +
                                    widget.data.d.song.artists[0].nameRomaji,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ))
                          ]))),
                ))
          ],
        ));
  }
}
