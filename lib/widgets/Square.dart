import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {
  final String child;
  final int intensidade;

  String? ConvertIntensidade(int intensidade) {
    if (intensidade == 1) {
      return "Intensidade: Baixa";
    }

    if (intensidade == 2) {
      return "Intensidade: Intermediária";
    }

    if (intensidade == 3) {
      return "Intensidade: Alta";
    }

    return null; // Retorna null quando não houver intensidade
  }

  MySquare({required this.child, required this.intensidade});

  @override
  Widget build(BuildContext context) {
    String? intensidadeText = ConvertIntensidade(intensidade);

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
              if (intensidadeText != null) // Verifica se há texto de intensidade
                const SizedBox(height: 3.0),
              if (intensidadeText != null)
                Text(
                  intensidadeText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
