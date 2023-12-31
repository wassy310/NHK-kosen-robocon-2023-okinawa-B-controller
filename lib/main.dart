import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'UI/button/emergency_stop.dart';
import 'UI/status/connection.dart';

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

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Robot controller/to check status',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(),
          EmergencyStop(
            onPressed: () {
              debugPrint('pushed');
            },
          ),
          const ConnectionStatusWidget(),
        ],
      ),
    );
  }
}
