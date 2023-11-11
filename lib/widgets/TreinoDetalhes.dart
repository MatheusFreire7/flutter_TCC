import 'package:flutter/material.dart';
import '../settings/theme.dart';

class TreinoDetalhes extends StatelessWidget {
  final String nomeExercicio;
  final String imageUrl;
  final String series;
  final String tempo;
  final String intensidade;
  final String repeticoes;

  TreinoDetalhes(
      {required this.nomeExercicio,
      required this.imageUrl,
      required this.series,
      required this.tempo,
      required this.intensidade,
      required this.repeticoes});

  String convertToMinutes(int seconds) {
    if (seconds >= 60) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      if (remainingSeconds > 0) {
        return '$minutes Minutos e $remainingSeconds Segundos';
      } else {
        return '$minutes Minutos';
      }
    } else {
      return '$seconds Segundos';
    }
  }


  String? convertIntensidade(int intensidade) {
    if (intensidade == 1) {
      return "Baixa";
    }

    if (intensidade == 2) {
      return "Intermediária";
    }

    if (intensidade == 3) {
      return "Alta";
    }

    return null; // Retorna null quando não houver intensidade
  }

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
              _buildInfoRow('Repetições', "${repeticoes} Vezes"),
              _buildInfoRow(
                  'Duração',
                  convertToMinutes(int.parse(tempo)) != 0
                      ? '${convertToMinutes(int.parse(tempo))}'
                      : null),
              _buildInfoRow('Intensidade', '${convertIntensidade(int.parse(intensidade))}'),
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

  Widget _buildInfoRow(String label, String? value) {
    if (value != null &&
        int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) != 0) {
      return Column(
        children: [
          Text('$label: $value',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
        ],
      );
    } else {
      return SizedBox.shrink(); // Não exibe nada se o valor for '0' ou nulo
    }
  }
}
