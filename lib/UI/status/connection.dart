import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectionStatusWidget extends StatefulWidget {
  const ConnectionStatusWidget({super.key});

  @override
  ConnectionStatusWidgetState createState() => ConnectionStatusWidgetState();
}

class ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  BluetoothDevice? device;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    scanAndConnectToDevice();
  }

  @override
  void dispose() {
    device?.disconnect();
    super.dispose();
  }

  void scanAndConnectToDevice() async {
    FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;

    List<ScanResult> scanResults = await flutterBluePlus
        .scan(timeout: const Duration(seconds: 4))
        .toList();

    for (var result in scanResults) {
      if (result.device.name == 'ESP32') {
        await result.device.connect(autoConnect: false);
        setState(() {
          device = result.device;
        });
        discoverServices(result.device);
        break;
      }
    }
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();

    for (var service in services) {
      if (service.uuid == Guid('service UUID')) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (var characteristic in characteristics) {
          if (characteristic.uuid == Guid('characteristic UUID')) {
            List<int> value = await characteristic.read();
            debugPrint('read: $value');

            await characteristic.write([0x01, 0x02, 0x03]);
            debugPrint('write complete');

            setState(() {
              connected = true;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 70,
      child: Text(
        connected ? 'Connected' : 'Not Connected',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
