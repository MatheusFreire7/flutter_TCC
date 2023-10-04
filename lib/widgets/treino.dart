import 'package:flutter/material.dart';
import '../settings/theme.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppTheme.iconColor),
          backgroundColor: AppTheme.appBarColor,
          title: Text('Detalhes do Exercício'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(imageUrl),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text('Séries: $series'),
              const SizedBox(height: 8.0),
              Text('Duração: $duration'),
              const SizedBox(height: 8.0),
              Text(description),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
