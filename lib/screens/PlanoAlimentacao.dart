import 'package:flutter/material.dart';
import '../screens/telainicial.dart';
import '../service/sharedUser.dart';
import '../settings/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/AlimentoDetalhes.dart';

class Diet extends StatefulWidget {
  @override
  _DietState createState() => _DietState();
}

class _DietState extends State<Diet> {
  List<Cardapio> cardapios = [];
  final List<String> daysOfWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  String _selectedDay = '';
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _getCurrentDayOfWeek();
    fetchFoodsForPlano();
  }

  Future<void> fetchFoodsForPlano() async {
    final userData = await SharedUser.getUserData();
    if (userData != null) {
      final idPlano = userData.idPlanoAlimentacao;
      final response = await http.get(
          Uri.parse('http://localhost:3000/AlimentacaoCardapio/get/$idPlano'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List<dynamic>;

        final foodIds =
            jsonResponse.map((item) => item['idCardapio'] as int).toList();
        await fetchFoods(foodIds);
      }
    }
  }

  Future<void> fetchFoods(List<int> foodIds) async {
    try {
      List<Cardapio> loadedCardapios = [];

      for (int id in foodIds) {
        final response =
            await http.get(Uri.parse('http://localhost:3000/cardapio/get/$id'));

        if (response.statusCode == 200) {
          final dynamic data = jsonDecode(response.body);

          if (data is List<dynamic> && data.isNotEmpty) {
            for (var cardapioData in data) {
              if (cardapioData is Map<String, dynamic>) {
                try {
                  // Certifique-se de que imageUrl não seja nulo
                  String imageUrl = cardapioData['imageUrl'] != null
                      ? cardapioData['imageUrl'].toString()
                      : '';

                  loadedCardapios.add(Cardapio(
                    idCardapio: cardapioData['idCardapio'],
                    nomeCardapio: cardapioData['nomeCardapio'],
                    valorEnergetico: cardapioData['valorEnergetico'],
                    carb: cardapioData['carb'],
                    proteinas: cardapioData['proteinas'],
                    gorduras: cardapioData['gorduras'],
                    sodio: cardapioData['sodio'],
                    periodo: cardapioData['periodo'],
                    imageUrl: imageUrl,
                  ));
                } catch (e) {
                  print('Erro ao processar dados para cardápio $id: $e');
                }
              } else {
                print('Erro: Dados do cardápio $id não são um mapa válido.');
              }
            }
          } else {
            print('Erro: Resposta inesperada para cardápio $id');
          }
        } else {
          print('Erro ao carregar o cardápio $id: ${response.statusCode}');
        }
      }

      setState(() {
        cardapios = loadedCardapios;
      });
    } catch (e) {
      print('Erro ao carregar os cardápios: $e');
    }
  }

  String _getCurrentDayOfWeek() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;

    switch (dayOfWeek) {
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

  Widget _buildMealContent(int period) {
    // Filtra a lista de cardápios com base no dia selecionado e no período
    List<Cardapio> filteredCardapios =
        cardapios.where((cardapio) => cardapio.periodo == period).toList();

    // Verifica se há cardápios para exibir
    if (filteredCardapios.isEmpty) {
      return const Center(
        child: Text('Nenhum cardápio disponível para esta refeição e dia.'),
      );
    }

    // Construoi os widgets para exibir os cardápios
    return ListView.builder(
      itemCount: filteredCardapios.length,
      itemBuilder: (context, index) {
        Cardapio cardapio = filteredCardapios[index];
        return InkWell(
          onTap: () {
            // Navegue para a tela AlimentoDetalhes quando o card for clicado
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlimentoDetalhes(
                  nome: cardapio.nomeCardapio,
                  carboidrato: cardapio.carb.toString(),
                  gordura: cardapio.gorduras.toString(),
                  proteina: cardapio.proteinas.toString(),
                  calorias: cardapio.valorEnergetico.toString(),
                  sodio: cardapio.sodio.toString(),
                  imageUrl: cardapio.imageUrl,
                ),
              ),
            );
          },
          onHover: (isHovered) {
            // Defina a ação que ocorrerá ao passar o mouse sobre o card
            // Por exemplo, você pode alterar a cor de fundo ou adicionar uma sombra
            setState(() {
              _isHovered = isHovered;
            });
          },
          child: Card(
            elevation: _isHovered ? 8 : 4, // Adicione sombra extra ao passar o mouse
            borderOnForeground: _isHovered, // Adicione borda ao passar o mouse
            child: ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(cardapio.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cardapio.nomeCardapio, style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Calorias: ${cardapio.valorEnergetico.toStringAsFixed(2)}'),
                        Text('Proteínas: ${cardapio.proteinas.toStringAsFixed(2)}'),
                        Text('Gorduras: ${cardapio.gorduras.toStringAsFixed(2)}'),
                        Text('Carboidratos: ${cardapio.carb.toStringAsFixed(2)}'),
                        Text('Sódio: ${cardapio.sodio.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          home: Scaffold(
            appBar: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(
                color: AppTheme.iconColor,
              ),
              backgroundColor: AppTheme.appBarColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaInicial(),
                    ),
                  );
                },
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: _selectedDay,
                      items: daysOfWeek.map((String day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? day) {
                        setState(() {
                          _selectedDay = day!;
                        });
                      },
                      elevation: 0,
                    ),
                    TabBar(
                      tabs: const <Widget>[
                        Tab(
                          child: Text('Café da Manhã',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Tab(
                          child: Text('Almoço',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Tab(
                          child: Text('Lanche da Tarde',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Tab(
                          child: Text('Jantar',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey[400],
                      indicatorWeight: 4.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: const Color.fromRGBO(215, 225, 255, 1.0),
                      isScrollable: true,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  ],
                ),
              ),
              title: const Text("Plano de Alimentação",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.red,
                      fontWeight: FontWeight.w700)),
              centerTitle: true,
            ),
            body: TabBarView(
              children: [
                // Café da Manhã
                _buildMealContent(1),
                // Almoço
                _buildMealContent(2),
                // Lanche da Tarde
                _buildMealContent(3),
                // Jantar
                _buildMealContent(4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Cardapio {
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

  final double carb;
  final double gorduras;
  final int idCardapio;
  final String imageUrl;
  final String nomeCardapio;
  final int periodo;
  final double proteinas;
  final double sodio;
  final double valorEnergetico;
}
