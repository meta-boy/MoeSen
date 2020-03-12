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

  String getImage(){
    String image;
    try {
      image = widget.album.image;
    } catch (e) {
      image = null;
    }
    // print("got image" + image);
    return image;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // print(widget.album.image);
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: getImage() != null ? Image.network("https://cdn.listen.moe/covers/" + widget.album.image, fit: BoxFit.cover,) : Container(
                      color: Colors.black,
                      child: Image.network("https://listen.moe/_nuxt/img/248c1f3.png",))
                    )),
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
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.data.d.song.title + "\n",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600)),
                            TextSpan(
                                text: 
                                    widget.album != null ?  widget.album.name : "Unknown" +
                                    " | " +
                                    widget.data.d.song.artists[0].name != null ? widget.data.d.song.artists[0].name : "Unknown" + " | " +
                                    widget.data.d.song.artists[0].nameRomaji != null ? widget.data.d.song.artists[0].nameRomaji : "Unknown",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ))
                          ]))),
                ))
          ],
        ));
  }
}
