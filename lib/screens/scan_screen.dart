import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'device_screen.dart';
import '../utils/snackbar.dart';
import '../utils/extra.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<ScanResult> _smartGlassesDevices = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  // Smart glasses service UUID
  final String _smartGlassesServiceUUID =
      '4fafc201-1fb5-459e-8fcc-c5c9c331914b';

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        if (mounted) {
          // Filter devices that advertise the smart glasses service UUID
          List<ScanResult> filteredResults = results.where((result) {
            return result.advertisementData.serviceUuids.any(
              (uuid) =>
                  uuid.str.toLowerCase() ==
                  _smartGlassesServiceUUID.toLowerCase(),
            );
          }).toList();

          setState(() => _smartGlassesDevices = filteredResults);
        }
      },
      onError: (e) {
        Snackbar.show(
          ABC.b,
          prettyException("Smart Glasses Scan Error:", e),
          success: false,
        );
      },
    );

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      if (mounted) {
        setState(() => _isScanning = state);
      }
    });

    // Start scanning automatically
    _startSmartGlassesScan();
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future _startSmartGlassesScan() async {
    try {
      await FlutterBluePlus.startScan(
        timeout: const Duration(
          seconds: 30,
        ), // Longer timeout for smart glasses
        withServices: [
          Guid(_smartGlassesServiceUUID),
        ], // Filter by specific service UUID
      );
    } catch (e, backtrace) {
      Snackbar.show(
        ABC.b,
        prettyException("Smart Glasses Scan Error:", e),
        success: false,
      );
      print(e);
      print("backtrace: $backtrace");
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e, backtrace) {
      Snackbar.show(
        ABC.b,
        prettyException("Stop Scan Error:", e),
        success: false,
      );
      print(e);
      print("backtrace: $backtrace");
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(
        ABC.c,
        prettyException("Connect Error:", e),
        success: false,
      );
    });
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => DeviceScreen(device: device),
      settings: RouteSettings(name: '/DeviceScreen'),
    );
    Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      _startSmartGlassesScan();
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton() {
    return Row(
      children: [
        if (FlutterBluePlus.isScanningNow)
          Text("Scanning...")
        else
          TextButton(
            onPressed: _startSmartGlassesScan,
            child: Text("Scan for Smart Glasses"),
          ),
      ],
    );
  }

  List<Widget> _buildSmartGlassesTiles() {
    if (_smartGlassesDevices.isEmpty) {
      return [
        Container(
          child: Center(
            child: Column(
              children: [
                Text(
                  _isScanning
                      ? 'Scanning for Smart Glasses...'
                      : 'No Smart Glasses Found',
                ),
                if (!_isScanning)
                  Text(
                    'Looking for devices with service UUID: ${_smartGlassesServiceUUID}',
                  ),
              ],
            ),
          ),
        ),
      ];
    }

    return _smartGlassesDevices
        .map(
          (result) => Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.device.platformName.isNotEmpty
                      ? result.device.platformName
                      : 'Solari Smart Glasses',
                ),
                Text('MAC: ${result.device.remoteId}'),
                Text('RSSI: ${result.rssi} dBm'),
                Text('Service: ${_smartGlassesServiceUUID}'),
                TextButton(
                  onPressed: () => onConnectPressed(result.device),
                  child: Text('Connect'),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Solari - Smart Glasses Scanner'),
          actions: [buildScanButton()],
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(children: _buildSmartGlassesTiles()),
        ),
      ),
    );
  }
}
