import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../settings/theme.dart';

class AlimentacaoSaudavel extends StatefulWidget {
  @override
  _AlimentacaoSaudavelState createState() => _AlimentacaoSaudavelState();
}

class _AlimentacaoSaudavelState extends State<AlimentacaoSaudavel> {
  List<Alimento> alimentos = [];

  @override
  void initState() {
    super.initState();
    fetchAlimentos();
  }

  Future<void> fetchAlimentos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/alimentos'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        alimentos = List<Alimento>.from(data.map((item) => Alimento.fromJson(item)));
      });
    } else {
      print('Erro ao carregar os alimentos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home:Scaffold(
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
      body: ListView.builder(
        itemCount: alimentos.length,
        itemBuilder: (context, index) {
          final alimento = alimentos[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.food_bank),
              title: Text(alimento.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Calorias: ${alimento.calorias.toStringAsFixed(2)}'),
                  Text('Proteínas: ${alimento.proteinas.toStringAsFixed(2)}'),
                  Text('Gorduras: ${alimento.gorduras.toStringAsFixed(2)}'),
                  Text('Carboidratos: ${alimento.carboidratos.toStringAsFixed(2)}'),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
      ),
    ),
    );
  }
}

class Alimento {
  final String nome;
  final double calorias;
  final double proteinas;
  final double gorduras;
  final double carboidratos;

  Alimento({
    required this.nome,
    required this.calorias,
    required this.proteinas,
    required this.gorduras,
    required this.carboidratos,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    final nome = json['nome'] ?? '';
    final calorias = json['calorias']?.toDouble() ?? 0.0;
    final proteinas = json['proteinas']?.toDouble() ?? 0.0;
    final gorduras = json['gorduras']?.toDouble() ?? 0.0;
    final carboidratos = json['carboidratos']?.toDouble() ?? 0.0;

    return Alimento(
      nome: nome,
      calorias: calorias,
      proteinas: proteinas,
      gorduras: gorduras,
      carboidratos: carboidratos,
    );
  }
}
