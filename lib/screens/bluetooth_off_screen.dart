import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/snackbar.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({super.key, this.adapterState});

  final BluetoothAdapterState? adapterState;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return Text('[Bluetooth Off]');
  }

  Widget buildTitle(BuildContext context) {
    String? state = adapterState?.toString().split(".").last;
    return Column(
      children: [
        Text('Solari Smart Glasses Scanner'),
        Text('Bluetooth is ${state ?? 'not available'}'),
        Text('Please enable Bluetooth to scan for smart glasses'),
      ],
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return TextButton(
      child: const Text('Enable Bluetooth'),
      onPressed: () async {
        try {
          if (!kIsWeb && Platform.isAndroid) {
            await FlutterBluePlus.turnOn();
          }
        } catch (e, backtrace) {
          Snackbar.show(
            ABC.a,
            prettyException("Error Turning On:", e),
            success: false,
          );
          print("$e");
          print("backtrace: $backtrace");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyA,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildBluetoothOffIcon(context),
              buildTitle(context),
              if (!kIsWeb && Platform.isAndroid) buildTurnOnButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
