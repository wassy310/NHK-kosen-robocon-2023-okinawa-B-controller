import 'package:flutter/material.dart';

class EmergencyStop extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyStop({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 + 30,
      right: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.yellow,
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
