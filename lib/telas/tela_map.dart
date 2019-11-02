import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class Tela_Maps extends StatefulWidget {
  @override
  _Tela_MapsState createState() => _Tela_MapsState();
}

class _Tela_MapsState extends State<Tela_Maps> {


  @override
  Widget build(BuildContext context) {
    return homeMapa();
  }
}

homeMapa() {
  return  FlutterMap(
      options: new MapOptions(
        center: LatLng(-22.999571, -43.356111),
        zoom: 18.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiYWxhbndpbGxpYW4iLCJhIjoiY2syMHU5emkyMDBjdDNkczlwenVqa2k0eiJ9.JRqbkxD6eQigj4RcLsyhYg',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(-22.999571, -43.356111),
              builder: (ctx) =>
              new Container(
                child: new Icon(Icons.location_on, color: Colors.indigo, size: 50,),
              ),
            ),
          ],
        ),
      ],
    );
  }