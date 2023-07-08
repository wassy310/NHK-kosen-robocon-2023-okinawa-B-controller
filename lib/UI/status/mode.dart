import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SignalHandler {
  final BluetoothCharacteristic characteristic;
  bool isManual = true;

  SignalHandler(this.characteristic) {
    _startListening();
  }

  void _startListening() {
    characteristic.setNotifyValue(true);
    characteristic.value.listen((value) {
      isManual = (value[0] == 1); // 1が手動、0が自動のフラグと仮定
    });
  }
}
