import 'package:flutter/material.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:flutter_login/widgets/treino.dart';

class PlanoTreinoPage extends StatefulWidget {
  @override
  _PlanoTreinoPageState createState() => _PlanoTreinoPageState();
}

class _PlanoTreinoPageState extends State<PlanoTreinoPage> {
  
  String _selectedDay = ''; // Inicialmente vazio, será preenchido com o dia atual

     @override
  void initState() {
    super.initState();
    // Obtenha o dia da semana atual e atribua à variável _selectedDay
    _selectedDay = _getCurrentDayOfWeek();
  }

  String _getCurrentDayOfWeek() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday; // Retorna um número de 1 (segunda-feira) a 7 (domingo)
    
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
          // Imagem em destaque do plano de treino
          // Image.asset(
          //   'caminho_da_imagem',
          //   height: 200,
          //   fit: BoxFit.cover,
          // ),
          const SizedBox(height: 16.0),
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
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              //    nomeExercicio: nomeExercicio,
              // imageUrl: imageUrl,
              // series: series,
              // tempo: tempo,
              // intensidade: intensidade,
              // repeticoes: repeticoes,
              children: [
                if (_selectedDay == 'Segunda-feira')
                  _buildWeekDaySection('Segunda-feira', [
                    _buildExerciseTile('Exercício 1', 'caminho_da_imagem',
                        '3 séries', '10 min', '3 Repetições','Médio'),
                    _buildExerciseTile('Exercício 2', 'caminho_da_imagem',
                        '4 séries', '15 min', '2 Repetições','Alta'),
                  ]),
                if (_selectedDay == 'Terça-feira')
                  _buildWeekDaySection('Terça-feira', [
                    _buildExerciseTile('Exercício 3', 'caminho_da_imagem',
                        '2 séries', '8 min', '4 Repetições','Baixa'),
                    _buildExerciseTile('Exercício 4', 'caminho_da_imagem',
                        '3 séries', '12 min', '4 Repetições','Baixa'),
                    _buildExerciseTile('Exercício 5', 'caminho_da_imagem',
                        '3 séries', '10 min', '3 Repetições','Médio'),
                  ]),
                // Adicione seções para cada dia da semana
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildWeekDaySection(String day, List<Widget> exercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Column(children: exercises),
      ],
    );
  }


  Widget _buildExerciseTile(String nomeExercicio, String imageUrl, String series,
      String tempo, String intensidade, String repeticoes){
    return ListTile(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TreinoDetalhes(
              nomeExercicio: nomeExercicio,
              imageUrl: imageUrl,
              series: series,
              tempo: tempo,
              repeticoes: repeticoes,
              intensidade: intensidade,
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
      leading: const Text('image'),
      title: Text(nomeExercicio),
      subtitle: Text('$series - $series'),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
