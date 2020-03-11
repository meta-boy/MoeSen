import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moe_client/api/functions.dart';
import 'package:moe_client/constants/colors.dart';
import 'package:moe_client/models/socketdata.dart';
import 'package:web_socket_channel/io.dart';
import 'player.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String url = 'wss://listen.moe/kpop/gateway_v2';
  Color backgroundColor;
  IOWebSocketChannel channel;
  int heartbeat;
  Stream<dynamic> stream;
  SocketData data;

  Future<void> sendPings(IOWebSocketChannel channel, int heartbeat) async {
    await Future.delayed(Duration(milliseconds: heartbeat), () {
      channel.sink.add(jsonEncode({"op": 9}));
    });
  }

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.play_arrow),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.search),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.library_music), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings), onPressed: () {})
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
            }),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
