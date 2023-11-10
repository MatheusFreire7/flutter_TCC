import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'telainicial.dart';
import '../settings/theme.dart';

class FoodList extends StatefulWidget {
  @override
  _FoodListState createState() => _FoodListState();
}

enum Ordenacao {
  calorias,
  proteinas,
  gorduras,
  carboidratos,
}

class _FoodListState extends State<FoodList> {
  List<Alimento> alimentos = [];
  Ordenacao _ordenacaoAtual = Ordenacao.calorias;
  bool _ordemCrescente = true;

  @override
  void initState() {
    super.initState();
    fetchAlimentos();
  }

Future<void> fetchAlimentos() async {
  try{
      final response = await http.get(Uri.parse('http://localhost:3000/alimentos'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          alimentos = data.map((item) => Alimento.fromJson(item)).toList();
        });
      } else {
        print('Erro ao carregar os alimentos: ${response.statusCode}');
      }
  }catch(e){
        print('Erro ao carregar os alimentos: ${e}');
  }
  
}

  void _ordenarAlimentos(Ordenacao novaOrdenacao) {
    setState(() {
      if (_ordenacaoAtual == novaOrdenacao) {
        _ordemCrescente = !_ordemCrescente;
      } else {
        _ordenacaoAtual = novaOrdenacao;
        _ordemCrescente = true;
      }

      alimentos.sort((a, b) {
        double valorA, valorB;

        switch (_ordenacaoAtual) {
          case Ordenacao.calorias:
            valorA = a.calorias;
            valorB = b.calorias;
            break;
          case Ordenacao.proteinas:
            valorA = a.proteinas;
            valorB = b.proteinas;
            break;
          case Ordenacao.gorduras:
            valorA = a.gorduras;
            valorB = b.gorduras;
            break;
          case Ordenacao.carboidratos:
            valorA = a.carboidratos;
            valorB = b.carboidratos;
            break;
          default:
            valorA = 0;
            valorB = 0;
        }

        return _ordemCrescente
            ? valorA.compareTo(valorB)
            : valorB.compareTo(valorA);
      });
    });
  }

  String _textoOrdenacao(Ordenacao ordenacao) {
    switch (ordenacao) {
      case Ordenacao.calorias:
        return 'Calorias';
      case Ordenacao.proteinas:
        return 'Proteínas';
      case Ordenacao.gorduras:
        return 'Gorduras';
      case Ordenacao.carboidratos:
        return 'Carboidratos';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppTheme.iconColor),
          backgroundColor: AppTheme.appBarColor,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: AppTheme.iconColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaInicial(),
                  ),
                );
              },
            ),
           actions: [
            DropdownButton<Ordenacao>(
              value: _ordenacaoAtual,
              onChanged: (novaOrdenacao) {
                _ordenarAlimentos(novaOrdenacao!);
              },
              elevation: 0,
              items: Ordenacao.values.map((ordenacao) {
                return DropdownMenuItem<Ordenacao>(
                  value: ordenacao,
                  child: Text(_textoOrdenacao(ordenacao), style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.blue),),
                );
              }).toList(),
              dropdownColor: Colors.white, 
            ),
            IconButton(
              icon: Icon(
                _ordemCrescente ? Icons.arrow_upward : Icons.arrow_downward,
                color: AppTheme.iconColor,
              ),
              color: Colors.black,
              onPressed: () {
                _ordenarAlimentos(_ordenacaoAtual);
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: alimentos.length,
          itemBuilder: (context, index) {
            final alimento = alimentos[index];
            return Card(
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      child: Image.network(
                        alimento.imagem,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alimento.nome,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                              'Calorias: ${alimento.calorias.toStringAsFixed(2)}'),
                          Text(
                              'Proteínas: ${alimento.proteinas.toStringAsFixed(2)}'),
                          Text(
                              'Gorduras: ${alimento.gorduras.toStringAsFixed(2)}'),
                          Text(
                              'Carboidratos: ${alimento.carboidratos.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
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
  final String imagem;

  Alimento({
    required this.nome,
    required this.calorias,
    required this.proteinas,
    required this.gorduras,
    required this.carboidratos,
    required this.imagem,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    final nome = json['nome'] ?? '';
    final calorias = json['calorias']?.toDouble() ?? 0.0;
    final proteinas = json['proteinas']?.toDouble() ?? 0.0;
    final gorduras = json['gorduras']?.toDouble() ?? 0.0;
    final carboidratos = json['carboidratos']?.toDouble() ?? 0.0;
    final imagem = json['imagem'] ?? '';

    return Alimento(
        nome: nome,
        calorias: calorias,
        proteinas: proteinas,
        gorduras: gorduras,
        carboidratos: carboidratos,
        imagem: imagem);
  }

  @override
  String toString() {
    return 'Alimento: $nome, Calorias: $calorias, Proteínas: $proteinas, Gorduras: $gorduras, Carboidratos: $carboidratos';
  }
}