import 'package:flutter/material.dart';
import 'package:flutter_login/treino.dart';

class PlanoTreinoPage extends StatefulWidget {
  @override
  _PlanoTreinoPageState createState() => _PlanoTreinoPageState();
}

class _PlanoTreinoPageState extends State<PlanoTreinoPage> {
  String _selectedDay = 'Segunda-feira';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plano de Treino'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagem em destaque do plano de treino
          // Image.asset(
          //   'caminho_da_imagem',
          //   height: 200,
          //   fit: BoxFit.cover,
          // ),
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
              'Quarta-feira',
              'Quinta-feira',
              'Sexta-feira',
              'Sábado',
              'Domingo',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                if (_selectedDay == 'Segunda-feira')
                  _buildWeekDaySection('Segunda-feira', [
                    _buildExerciseTile('Exercício 1', 'caminho_da_imagem',
                        '3 séries', '10 min', 'Descrição do exercício 1'),
                    _buildExerciseTile('Exercício 2', 'caminho_da_imagem',
                        '4 séries', '15 min', 'Descrição do exercício 2'),
                  ]),
                if (_selectedDay == 'Terça-feira')
                  _buildWeekDaySection('Terça-feira', [
                    _buildExerciseTile('Exercício 3', 'caminho_da_imagem',
                        '2 séries', '8 min', 'Descrição do exercício 3'),
                    _buildExerciseTile('Exercício 4', 'caminho_da_imagem',
                        '3 séries', '12 min', 'Descrição do exercício 4'),
                    _buildExerciseTile('Exercício 5', 'caminho_da_imagem',
                        '3 séries', '10 min', 'Descrição do exercício 5'),
                  ]),
                // Adicione seções para cada dia da semana
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaySection(String day, List<Widget> exercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          day,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Column(children: exercises),
      ],
    );
  }

  Widget _buildExerciseTile(String title, String imagePath, String series,
      String duration, String description) {
    return ListTile(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TreinoDetalhes(
              title: title,
              imageUrl: imagePath,
              series: series,
              duration: duration,
              description: description,
            ),
          ),
        );
      },
      // leading: Image.asset(
      //   imagePath,
      //   width: 80,
      //   height: 80,
      //   fit: BoxFit.cover,
      // ),
      leading: Text('image'),
      title: Text(title),
      subtitle: Text('$series - $duration'),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
