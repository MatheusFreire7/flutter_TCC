import 'package:flutter/material.dart';
import 'package:flutter_login/settings/theme.dart';

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
    required this.repeticoes,
  });

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

  String getIntensityLabel(String intensidade) {
    switch (intensidade) {
      case '1':
        return 'Baixa';
      case '2':
        return 'Intermediária';
      case '3':
        return 'Alta';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detalhes do: ${nomeExercicio}'), 
          centerTitle: true,
          iconTheme: IconThemeData(color: AppTheme.iconColor),
          backgroundColor: AppTheme.appBarColor,
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
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TabelaInformacoes(
                labels: ['Séries', 'Repetições', 'Duração', 'Intensidade'],
                valores: [
                  series,
                  '$repeticoes Vezes',
                  convertToMinutes(int.parse(tempo)) != '0'
                      ? '${convertToMinutes(int.parse(tempo))}'
                      : '',
                  getIntensityLabel(intensidade),
                ],
              ),
              const SizedBox(height: 16.0),
             ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 3.0,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Voltar',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabelaInformacoes extends StatelessWidget {
  final List<String> labels;
  final List<String> valores;

  TabelaInformacoes({
    required this.labels,
    required this.valores,
  });

  int? extractNumber(String value) {
    final cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanedValue);
  }

  String getIntensityLabel(String intensidade) {
    switch (intensidade) {
      case '1':
        return 'Baixa';
      case '2':
        return 'Intermediária';
      case '3':
        return 'Alta';
      default:
        return intensidade; // Retorna a intensidade como String original se não for 1, 2 ou 3
    }
  }

  List<TableRow> buildTableRows() {
    List<TableRow> rows = [];

    for (int index = 0; index < labels.length; index++) {
      final value = valores[index];
      final isIntensityLabel = index == 3;

      if (isIntensityLabel) {
        // Use getIntensityLabel diretamente
        final intensityLabel = getIntensityLabel(value);
        if (intensityLabel.isNotEmpty) {
          rows.add(
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.blue[100],
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.blue[100],
                    child: Text(
                      intensityLabel,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        final numericValue = extractNumber(value);

        if (numericValue != null && numericValue != 0) {
          rows.add(
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: index.isEven ? Colors.blue[100] : Colors.blue[50],
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: index.isEven ? Colors.blue[100] : Colors.blue[50],
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.transparent),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: buildTableRows(),
    );
  }
}
