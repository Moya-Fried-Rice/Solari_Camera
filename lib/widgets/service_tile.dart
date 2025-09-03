import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "characteristic_tile.dart";

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({
    super.key,
    required this.service,
    required this.characteristicTiles,
  });

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${service.uuid.str.toUpperCase()}';
    return Text(uuid);
  }

  @override
  Widget build(BuildContext context) {
    return characteristicTiles.isNotEmpty
        ? ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text('Service'), buildUuid(context)],
            ),
            children: characteristicTiles,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Service'), buildUuid(context)],
          );
  }
}
