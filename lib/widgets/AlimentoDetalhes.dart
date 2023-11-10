import 'package:flutter/material.dart';
import '../settings/theme.dart';

class AlimentoDetalhes extends StatelessWidget {
  final String nome;
  final String carboidrato;
  final String gordura;
  final String proteina;
  final String calorias;

  AlimentoDetalhes({
    required this.nome,
    required this.carboidrato,
    required this.gordura,
    required this.proteina,
    required this.calorias,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
          color: AppTheme.iconColor),
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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(carboidrato),
                    const SizedBox(height: 16.0),
                    Text(
                      nome,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(gordura),
                    const SizedBox(height: 8.0),
                    Text(proteina),
                    const SizedBox(height: 8.0),
                    Text(calorias),
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
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
