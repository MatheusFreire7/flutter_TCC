import 'package:flutter/material.dart';

class PlanoTreinoDetalhes extends StatelessWidget {
  final String nomePlano;
  final String descricao;
  final String imageUrl;

  PlanoTreinoDetalhes({
    required this.nomePlano,
    required this.descricao,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Plano de Treino'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(imageUrl),
                  SizedBox(height: 16.0),
                  Text(
                    nomePlano,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(descricao),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar'),
            ),
          ),
        ],
      ),
    );
  }
}

