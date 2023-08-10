import 'package:flutter/material.dart';

class TreinoDetalhes extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String series;
  final String duration;
  final String description;

  TreinoDetalhes({
    required this.title,
    required this.imageUrl,
    required this.series,
    required this.duration,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Exercício: $title' ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Image.network(imageUrl),
                  Text(imageUrl),
                  SizedBox(height: 16.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(series),
                  SizedBox(height: 8.0),
                  Text(duration),
                  SizedBox(height: 8.0),
                  Text(description),
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
