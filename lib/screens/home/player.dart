import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:moe_client/models/socketdata.dart';

class Player extends StatefulWidget {
  Player({this.data, this.album, this.accentColor});
  final SocketData data;
  final Album album;
  final Color accentColor;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  String getImage(Album album) {
    String image;
    try {
      image = album.image;
    } catch (e) {
      image = null;
    }
    return image;
  }

  String album, name, nameRomaji;
  Color textColor;

  void setValues() {
    album = widget.album != null ? widget.album.name + " | " : "Unknown";
    name = widget.data.d.song.artists[0].name != null
        ? widget.data.d.song.artists[0].name + " | "
        : "Unknown";
    nameRomaji = widget.data.d.song.artists[0].nameRomaji != null
        ? widget.data.d.song.artists[0].nameRomaji
        : "Unknown";
  }

  @override
  void initState() {
    setValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setValues();
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: widget.accentColor.computeLuminance() > 0.5
                  ? Colors.black.withOpacity(0.1)
                  : Colors.white.withOpacity(0.4),
              offset: Offset(0, 5),
              spreadRadius: 10,
              blurRadius: 30)
        ]),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: getImage(widget.album) != null
                        ? Image.network(
                            "https://cdn.listen.moe/covers/" +
                                widget.album.image,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.black,
                            child: Image.network(
                              "https://listen.moe/_nuxt/img/248c1f3.png",
                            )))),
            Positioned(
                right: -1,
                left: -1,
                bottom: -1,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                          colors: [widget.accentColor, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                      borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(16),
                          bottomEnd: Radius.circular(16))),
                  child: Center(
                      child: RichText(
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.data.d.song.title + "\n",
                                style: TextStyle(
                                    color:
                                        widget.accentColor.computeLuminance() >
                                                0.5
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text: album + name + nameRomaji,
                                style: TextStyle(
                                  color: widget.accentColor.computeLuminance() >
                                          0.5
                                      ? Colors.black
                                      : Colors.white,
                                  fontStyle: FontStyle.italic,
                                ))
                          ]))),
                )),
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      // color: widget.accentColor.computeLuminance() > 0.5
                      //     ? Colors.black
                      //     : Colors.white,
                      color: widget.accentColor),
                  borderRadius: BorderRadius.circular(16)),
            ))
          ],
        ));
  }
}
