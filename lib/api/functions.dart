import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:moe_client/constants/defaults.dart';

import 'package:moe_client/models/socketdata.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:web_socket_channel/io.dart';

dynamic getData(IOWebSocketChannel channel, AsyncSnapshot snapshot) {
  final data = jsonDecode(snapshot.data);
  final int op = data['op'];
  switch (op) {
    case 0:
      int hb = int.parse(data['d']['heartbeat']);
      Future.delayed(Duration(milliseconds: hb),
          () => channel.sink.add(json.encode({'op': 9})));
      break;
    case 1:
      if (data['t'] != 'TRACK_UPDATE' &&
          data['t'] != 'TRACK_UPDATE_REQUEST' &&
          data['t'] != 'QUEUE_UPDATE' &&
          data['t'] != 'NOTIFICATION') break;
      return SocketData.fromJson(data);
      break;
    default:
      return null;
    // return SocketData.fromJson(data);
  }
}

Album getImageUrl(SocketData data) {
  Album album;
  final List<Album> all = data.d.song.albums;
  try {
    for (int i = 0; i < all.length; i++) {
    if (all[i].image != null ||
        all[i].name != null ||
        all[i].id != null ||
        all[i].nameRomaji != null ) {
      album = all[i];
      album.image = Uri.decodeFull(Uri.encodeFull(all[i].image));
    } else {
      album = defaultAlbum;
    }
  }
  } catch (e) {
      album = defaultAlbum;
    
  }
  return album;
}




Future<Color> getColor(String url) async{
      Image img = Image.network(url);
      Size imageSize = Size(500, 500);
      Rect region = Offset.zero & imageSize;
    return await _updatePaletteGenerator(region, img, imageSize);

}


Future<Color> _updatePaletteGenerator(Rect newRegion, Image img, Size imageSize) async {
    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      img.image,
      size: imageSize,
      region: newRegion,
      maximumColorCount: 20,
    );
    return paletteGenerator.dominantColor?.color;
  }