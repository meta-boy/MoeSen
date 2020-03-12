import 'package:flutter/material.dart';
import 'package:moe_client/screens/home/home.dart';

class RadioCard extends StatefulWidget {
  RadioCard({this.uri, this.text, this.musicStream, this.socketUrl});
  final String uri, text, musicStream, socketUrl;
  @override
  _RadioCardState createState() => _RadioCardState();
}

class _RadioCardState extends State<RadioCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(
            musicStream: widget.musicStream,
            socketUrl: widget.socketUrl,
          )));
      },
          child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.uri,
                      fit: BoxFit.cover,
                    ))),
            Positioned.fill(child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Center(child: Text(widget.text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 50),)),
            ))
          ],
        ),
      ),
    );
  }
}
