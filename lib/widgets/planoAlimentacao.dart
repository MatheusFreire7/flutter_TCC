import 'package:flutter/material.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:flutter_login/widgets/treino.dart';

class PlanoAlimentacaoPage extends StatefulWidget {
  @override
  _PlanoAlimentacaoPageState createState() => _PlanoAlimentacaoPageState();
}

class _PlanoAlimentacaoPageState extends State<PlanoAlimentacaoPage> {
  String _selectedDay = 'Segunda-feira';

  List<Map<String, dynamic>> planoAlimentacao = [
    {
      'dia': 'Segunda-feira',
      'refeicoes': [
        {'refeicao': 'Café da manhã', 'alimentos': [
          {'nome': 'Arroz', 'quantidade': '100g'},
          {'nome': 'Frango grelhado', 'quantidade': '150g'},
        ]},
        {'refeicao': 'Almoço', 'alimentos': [
          {'nome': 'Salada', 'quantidade': '200g'},
          {'nome': 'Peixe grelhado', 'quantidade': '200g'},
        ]},
         {'refeicao': 'Janta', 'alimentos': [
          {'nome': 'Salada', 'quantidade': '200g'},
          {'nome': 'Peixe grelhado', 'quantidade': '200g'},
        ]},
      ],
    },
    {
      'dia': 'Terça-feira',
      'refeicoes': [
        {'refeicao': 'Café da manhã', 'alimentos': [
          {'nome': 'Aveia', 'quantidade': '50g'},
          {'nome': 'Iogurte', 'quantidade': '200g'},
        ]},
        {'refeicao': 'Almoço', 'alimentos': [
          {'nome': 'Salada de frutas', 'quantidade': '150g'},
          {'nome': 'Peito de frango grelhado', 'quantidade': '150g'},
        ]},
         {'refeicao': 'Janta', 'alimentos': [
          {'nome': 'Salada de frutas', 'quantidade': '150g'},
          {'nome': 'Peito de frango grelhado', 'quantidade': '150g'},
        ]},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppTheme.iconColor),
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
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _selectedDay,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDay = newValue!;
                });
              },
              items: [
                'Segunda-feira',
                'Terça-feira',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: planoAlimentacao.length,
                itemBuilder: (BuildContext context, int index) {
                  final planoDia = planoAlimentacao[index];
                  if (planoDia['dia'] == _selectedDay) {
                    return _buildPlanoDia(planoDia);
                  }
                  return SizedBox.shrink(); // Oculta os dias não selecionados
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanoDia(Map<String, dynamic> planoDia) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Plano de Alimentação para ${planoDia['dia']}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Column(
          children: [
            for (var refeicao in planoDia['refeicoes']) ...[
              Text(
                refeicao['refeicao'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Column(
                children: [
                  for (var alimento in refeicao['alimentos'])
                    _buildAlimentoTile(
                      alimento['nome'],
                      alimento['quantidade'],
                    ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAlimentoTile(String? nome, String? quantidade) {
    return ListTile(
      onTap: () {
        // Implemente a ação desejada ao tocar em um alimento
      },
      title: Text(nome ?? ''),
      subtitle: Text('Quantidade: $quantidade'),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
