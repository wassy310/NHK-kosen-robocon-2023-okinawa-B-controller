import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'UI/button/emergency_stop.dart';
import 'UI/status/connection.dart';
import 'UI/status/mode.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<BluetoothCharacteristic> getCharacteristic() async {
    final FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;
    final Completer<BluetoothCharacteristic> completer = Completer();

    flutterBluePlus
        .scan(timeout: const Duration(seconds: 4))
        .listen((scanResult) async {
      if (scanResult.device.name == 'ESP32') {
        await scanResult.device.connect();
        final services = await scanResult.device.discoverServices();
        for (BluetoothService service in services) {
          for (BluetoothCharacteristic char in service.characteristics) {
            if (char.uuid == Guid('characteristic UUID')) {
              completer.complete(char);
              return;
            }
          }
        }
      }
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final BluetoothCharacteristic characteristic = getCharacteristic();
    final SignalHandler signalHandler = SignalHandler(characteristic);

    return FutureBuilder(
      initialData: 'loading',
      builder: (BuildContext context, AsyncSnapshot<dynamic> text) {
        return MaterialApp(
          title: 'Robot controller/to check status',
          home: MyHomePage(signalHandler: signalHandler),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final SignalHandler signalHandler;

  const MyHomePage({super.key, required this.signalHandler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: StatusDisplayWidget(isManual: signalHandler.isManual),
            ),
          ),
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: EmergencyStop(
                onPressed: () {
                  debugPrint('pushed');
                },
              ),
            ),
          ),
          const Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Center(
              child: ConnectionStatusWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusDisplayWidget extends StatelessWidget {
  const StatusDisplayWidget({super.key, required this.isManual});
  final bool isManual;

  @override
  Widget build(BuildContext context) {
    String status = isManual ? '手動' : '自動';

    return Text(
      'Status: $status',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
