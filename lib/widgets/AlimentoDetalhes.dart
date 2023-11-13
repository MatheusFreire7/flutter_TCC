import 'package:flutter/material.dart';
import '../settings/theme.dart';

class AlimentoDetalhes extends StatelessWidget {
  final String nome;
  final String carboidrato;
  final String gordura;
  final String proteina;
  final String calorias;
  final String imageUrl;
  final String sodio;

  AlimentoDetalhes({
    required this.nome,
    required this.carboidrato,
    required this.gordura,
    required this.proteina,
    required this.calorias,
    required this.sodio,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.iconColor,
          ),
          backgroundColor: AppTheme.appBarColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do alimento com tamanho grande
            Container(
              height: 300, // Ajuste a altura conforme necessário
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TabelaInformacoes(
                    labels: const [
                      'Carboidrato (g)',
                      'Gordura (g)',
                      'Proteína (g)',
                      'Calorias (kcal)',
                      'Sodio (mg)'
                    ],
                    valores: [carboidrato, gordura, proteina, calorias, sodio],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Cor de fundo
                  onPrimary: Colors.white, // Cor do texto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Borda arredondada
                  ),
                  elevation: 3.0, // Elevação
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Voltar',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.transparent),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: List.generate(
        labels.length,
        (index) => TableRow(
          children: [
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: index % 2 == 0 ? Colors.indigo[100] : Colors.indigo[50],
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[700],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                color: index % 2 == 0 ? Colors.indigo[100] : Colors.indigo[50],
                child: Text(
                  valores[index],
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
