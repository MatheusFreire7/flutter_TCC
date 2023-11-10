import 'package:flutter/material.dart';
import '../settings/theme.dart';

class TreinoDetalhes extends StatelessWidget {
  final String nomeExercicio;
  final String imageUrl;
  final String series;
  final String tempo;
  final String intensidade;
  final String repeticoes;

  TreinoDetalhes({
    required this.nomeExercicio,
    required this.imageUrl,
    required this.series,
    required this.tempo,
    required this.intensidade,
    required this.repeticoes
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
              Center(
                child: Image.network(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 100.0, color: Colors.red); 
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Text(
                  nomeExercicio,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildInfoRow('Séries', series),
              _buildInfoRow('Repetições', repeticoes),
              _buildInfoRow('Duração', tempo),
              _buildInfoRow('Intensidade', intensidade),
              //Center(child: Text('Intensidade: $intensidade')),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, 
                  onPrimary: Colors.white, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value != '0') {
      return Column(
        children: [
          Text('$label: $value', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
        ],
      );
    } else {
      return SizedBox.shrink(); // Não exibe nada se o valor for '0'
    }
  }
}
