import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {
  final String child;
  final int intensidade; 

  String ConvertIntensidade(int intensidade) { 
    if (intensidade == 1) {
      return "Intensidade: Baixa";
    }

    if (intensidade == 2) {
      return "Intensidade: Intermediária";
    }

    if (intensidade == 3) {
      return "Intensidade: Alta";
    }

    return "Intensidade Desconhecida"; // Caso nenhum dos valores correspondentes seja encontrado
  }

  MySquare({required this.child, required this.intensidade});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        color: Colors.deepPurple[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(child, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 3.0),
              Text(
                ConvertIntensidade(intensidade), 
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
