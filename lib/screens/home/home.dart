import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:moe_client/api/functions.dart';
import 'package:moe_client/constants/colors.dart';
import 'package:moe_client/models/socketdata.dart';
import 'package:moe_client/screens/select/select.dart';

import 'package:web_socket_channel/io.dart';
import 'player.dart';

class Home extends StatefulWidget {
  Home(
      {this.socketUrl: "wss://listen.moe/kpop/gateway_v2",
      this.musicStream: "https://listen.moe/kpop/fallback"});
  final String socketUrl, musicStream;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  String status;
  String url;
  String music;
  Color backgroundColor;
  IOWebSocketChannel channel;
  int heartbeat;
  Stream<dynamic> stream;
  SocketData data;

  AnimationController _animationController;
  final GlobalKey imageKey = GlobalKey();

  bool _isPlaying = false;
  Future<void> _pause() async {
    await FlutterRadio.pause(url: music);
  }

  Future<void> _stop() async {
    await FlutterRadio.stop();
  }

  Future<void> _play() async {
    await FlutterRadio.play(url: music);
  }

  Future<void> sendPings(IOWebSocketChannel channel, int heartbeat) async {
    await Future.delayed(Duration(milliseconds: heartbeat), () {
      try {
        channel.sink.add(jsonEncode({"op": 9}));
        print("pong~");
      } catch (e) {
        connect();
        print("new connection");
      }
    });
  }

  void connect() {
    channel = IOWebSocketChannel.connect(url);
    stream = channel.stream.asBroadcastStream();
    stream.listen((event) {
      var data = jsonDecode(event);
      if (data['op'] == 0) {
        heartbeat = data['d']['heartbeat'];
      } else {
        heartbeat = 45000;
      }
      sendPings(channel, heartbeat).then((value) => {});
    });
  }

  Color accentColor = hotPink;

  String getImage(Album album) {
    String image;
    try {
      image = album.image;
    } catch (e) {
      image = null;
    }
    return image;
  }

  Future<void> setColor(SocketData data) async {
    Album album = getImageUrl(data);
    String url = getImage(album) != null
        ? "https://cdn.listen.moe/covers/" + album.image
        : "https://listen.moe/_nuxt/img/248c1f3.png";

    accentColor = await getColor(url);
    setState(() {});
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
  }

  @override
  void initState() {
    url = widget.socketUrl;
    music = widget.musicStream;
    // status = "pause";
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    connect();
    audioStart();
    setColor(data);
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: FloatingActionButton(
            foregroundColor: accentColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
            elevation: 8,
            backgroundColor: accentColor == hotPink ? darkBlue : accentColor,
            onPressed: () async {
              if (_isPlaying) {
                await _pause();
              } else {
                await _play();
              }
              setState(() {
                _isPlaying = !_isPlaying;
                _isPlaying ? _animationController.reverse() : _animationController.forward();
              });
            },
            child: AnimatedIcon(icon: AnimatedIcons.pause_play, progress: _animationController),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: accentColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.search),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.library_music),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Select()));
              }),
          IconButton(icon: Icon(Icons.settings), onPressed: () {})
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              try {
                if (snapshot.hasData) {
                  if (snapshot.connectionState.index == 0) {
                    connect();
                  }

                  var d = jsonDecode(snapshot.data);
                  var op = d['op'];
                  switch (op) {
                    case 0:
                      break;
                    case 1:
                      if (d['t'] != 'TRACK_UPDATE' &&
                          d['t'] != 'TRACK_UPDATE_REQUEST' &&
                          d['t'] != 'QUEUE_UPDATE' &&
                          d['t'] != 'NOTIFICATION') break;
                      data = SocketData.fromJson(d);
                      setColor(data).then((value) => null);
                      print("changing song");
                      break;
                    case 9:
                      sendPings(channel, heartbeat).then((value) => {});
                      break;
                    default:
                  }
                }

                return data != null
                    ? Player(
                        data: data,
                        album: getImageUrl(data),
                        accentColor: accentColor,
                      )
                    : Center(child: Center(child: CircularProgressIndicator()));
              } catch (e) {
                return Center(
                    child: Center(child: CircularProgressIndicator()));
              }
            }),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    _stop();
    super.dispose();
  }
}
