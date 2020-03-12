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
  Home({this.socketUrl: "wss://listen.moe/kpop/gateway_v2", this.musicStream: "https://listen.moe/kpop/fallback"});
  String socketUrl, musicStream;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String status;
  String url;
  String music;
  Color backgroundColor;
  IOWebSocketChannel channel;
  int heartbeat;
  Stream<dynamic> stream;
  SocketData data;
  
  

  bool _isPlaying = false;
  Future<void> _pause() async {
    await FlutterRadio.pause(url: music);
    print("stopping radio");
  }

  Future<void> _stop() async {
    await FlutterRadio.stop();
    print("stopping radio");
  }

  Future<void> _play() async {
    
    await FlutterRadio.play(url: music);
  }

  Future<void> sendPings(IOWebSocketChannel channel, int heartbeat) async {
    await Future.delayed(Duration(milliseconds: heartbeat), () {
      try {
        channel.sink.add(jsonEncode({"op": 9}));
      } catch (e) {
        connect();
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
        print(data);
      } else {
        heartbeat = 45000;
      }
      sendPings(channel, heartbeat).then((value) => {});
    });
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  
  @override
  void initState() {
    url = widget.socketUrl;
    music = widget.musicStream;
    // status = "pause";
    connect();
    audioStart();
    

    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var a = Navigator.of(context);
    return Scaffold(
      floatingActionButton: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: FloatingActionButton(
            onPressed: () async{
              if (_isPlaying){
               await _pause();
              } else {
                await _play();
              }
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
            child: _isPlaying ? Icon(Icons.pause): Icon(Icons.play_arrow),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.search),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.library_music), onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Select()));
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
                  
                  print(snapshot.data);
                  var d = jsonDecode(snapshot.data);
                  var op = d['op'];
                  switch (op) {
                    case 0:
                      print("ok");
                      int hb = d['d']['heartbeat'];

                      break;
                    case 1:
                      if (d['t'] != 'TRACK_UPDATE' &&
                          d['t'] != 'TRACK_UPDATE_REQUEST' &&
                          d['t'] != 'QUEUE_UPDATE' &&
                          d['t'] != 'NOTIFICATION') break;
                      data = SocketData.fromJson(d);
                      
                      break;
                    default:
                      sendPings(channel, heartbeat).then((value) => {});
                  }
                }
                
                return data != null
                    ? Player(data: data, album: getImageUrl(data))
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
    print("dispose");
    super.dispose();
  }
}
