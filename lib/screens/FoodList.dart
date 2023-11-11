import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/AlimentoDetalhes.dart';
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
  sodio,
}

class _FoodListState extends State<FoodList> {
  List<Cardapio> cardapios = [];
  Ordenacao _ordenacaoAtual = Ordenacao.calorias;
  bool _ordemCrescente = true;

  @override
  void initState() {
    super.initState();
    fetchCardapios();
  }

  Future<void> fetchCardapios() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/cardapio/get'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Verifique se a lista tem pelo menos um elemento
        if (data.isNotEmpty && data[0] is List<dynamic>) {
          final List<dynamic> cardapiosData = data[0];

          setState(() {
            cardapios =
                cardapiosData.map((item) => Cardapio.fromJson(item)).toList();
          });
        } else {
          print('Erro: Resposta inesperada');
        }
      } else {
        print('Erro ao carregar os cardápios: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar os cardápios: $e');
    }
  }

  void _ordenarCardapios(Ordenacao novaOrdenacao) {
    setState(() {
      if (_ordenacaoAtual == novaOrdenacao) {
        _ordemCrescente = !_ordemCrescente;
      } else {
        _ordenacaoAtual = novaOrdenacao;
        _ordemCrescente = true;
      }

      cardapios.sort((a, b) {
        double valorA, valorB;

        switch (_ordenacaoAtual) {
          case Ordenacao.calorias:
            valorA = a.valorEnergetico;
            valorB = b.valorEnergetico;
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
            valorA = a.carb;
            valorB = b.carb;
            break;
          case Ordenacao.sodio:
            valorA = a.sodio;
            valorB = b.sodio;
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
      case Ordenacao.sodio:
        return 'Sódio';
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
                _ordenarCardapios(novaOrdenacao!);
              },
              elevation: 0,
              items: Ordenacao.values.map((ordenacao) {
                return DropdownMenuItem<Ordenacao>(
                  value: ordenacao,
                  child: Text(
                    _textoOrdenacao(ordenacao),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
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
                _ordenarCardapios(_ordenacaoAtual);
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: cardapios.length,
          itemBuilder: (context, index) {
            final cardapio = cardapios[index];
            return GestureDetector(
              onTap: () {
                // Navegue para a tela de detalhes ao clicar no item
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlimentoDetalhes(
                      nome: cardapio.nomeCardapio,
                      carboidrato: cardapio.carb.toStringAsFixed(2),
                      gordura: cardapio.gorduras.toStringAsFixed(2),
                      proteina: cardapio.proteinas.toStringAsFixed(2),
                      calorias: cardapio.valorEnergetico.toStringAsFixed(2),
                      sodio: cardapio.sodio.toStringAsFixed(2),
                      imageUrl: cardapio.imageUrl,
                    ),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: Image.network(
                          cardapio.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cardapio.nomeCardapio,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Calorias: ${cardapio.valorEnergetico.toStringAsFixed(2)}'),
                            Text(
                                'Proteínas: ${cardapio.proteinas.toStringAsFixed(2)}'),
                            Text(
                                'Gorduras: ${cardapio.gorduras.toStringAsFixed(2)}'),
                            Text(
                                'Carboidratos: ${cardapio.carb.toStringAsFixed(2)}'),
                            Text(
                                'Sódio: ${cardapio.sodio.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Cardapio {
  final int idCardapio;
  final String nomeCardapio;
  final double valorEnergetico;
  final double carb;
  final double proteinas;
  final double gorduras;
  final double sodio;
  final int periodo;
  final String imageUrl;

  Cardapio({
    required this.idCardapio,
    required this.nomeCardapio,
    required this.valorEnergetico,
    required this.carb,
    required this.proteinas,
    required this.gorduras,
    required this.sodio,
    required this.periodo,
    required this.imageUrl,
  });

  factory Cardapio.fromJson(Map<String, dynamic> json) {
    return Cardapio(
      idCardapio: json['idCardapio'],
      nomeCardapio: json['nomeCardapio'],
      valorEnergetico: json['valorEnergetico']?.toDouble() ?? 0.0,
      carb: json['carb']?.toDouble() ?? 0.0,
      proteinas: json['proteinas']?.toDouble() ?? 0.0,
      gorduras: json['gorduras']?.toDouble() ?? 0.0,
      sodio: json['sodio']?.toDouble() ?? 0.0,
      periodo: json['periodo'],
      imageUrl: json['imageUrl'],
    );
  }
}
