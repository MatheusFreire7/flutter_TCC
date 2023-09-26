import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {

  final String child;

  MySquare({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        color: Colors.deepPurple[100],
        child: Center(
          child: Text(child, style: const TextStyle(
            fontSize: 40
            )
          ),
        ),
      ),
    );
  }
}
