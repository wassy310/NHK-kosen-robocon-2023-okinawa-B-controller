import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  scanAndConnectToDevice();
}

void scanAndConnectToDevice() async {
  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;

  List<ScanResult> scanResults =
      await flutterBluePlus.scan(timeout: const Duration(seconds: 4)).toList();

  for (var result in scanResults) {
    if (result.device.name == 'ESP32') {
      await result.device.connect(autoConnect: false);

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
          print('read: $value');

          await characteristic.write([0x01, 0x02, 0x03]);
          print('write complete');
        }
      }
    }
  }
}
