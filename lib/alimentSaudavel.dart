import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlimentacaoSaudavel extends StatefulWidget {
  @override
  _AlimentacaoSaudavelState createState() => _AlimentacaoSaudavelState();
}

class _AlimentacaoSaudavelState extends State<AlimentacaoSaudavel> {
  List<Receita> receitas = [];

  @override
  void initState() {
    super.initState();
    fetchReceitas();
  }

  Future<void> fetchReceitas() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Vegetarian'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        receitas = List<Receita>.from(data['meals'].map((meal) => Receita.fromJson(meal)));
      });
    } else {
      // Tratar erro ao carregar as receitas
      print('Erro ao carregar as receitas: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alimentação Saudável'),
      ),
      body: ListView.builder(
        itemCount: receitas.length,
        itemBuilder: (context, index) {
          final receita = receitas[index];
          return ListTile(
            leading: Image.network(
              receita.imagemUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(receita.nome),
            subtitle: Text(receita.descricao),
          );
        },
      ),
    );
  }
}

class Receita {
  final String nome;
  final String descricao;
  final String imagemUrl;

  Receita({
    required this.nome,
    required this.descricao,
    required this.imagemUrl,
  });

 factory Receita.fromJson(Map<String, dynamic> json) {
  final nome = json['strMeal'] ?? '';
  final descricao = json['strInstructions'] ?? '';
  final imagemUrl = json['strMealThumb'] ?? '';

  return Receita(
    nome: nome,
    descricao: descricao,
    imagemUrl: imagemUrl,
  );
}

}
