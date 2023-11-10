import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../service/sharedUser.dart';
import '../widgets/TreinoDetalhes.dart';
import '../settings/Theme.dart';

class Exercise {
  final int idExercicio;
  final String nomeExercicio;
  final int series;
  final int repeticoes;
  final int tempoS;
  final int intensidade;
  final String imageUrl;

  Exercise({
    required this.idExercicio,
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.tempoS,
    required this.intensidade,
    required this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      idExercicio: json['idExercicio'] ?? 0,
      nomeExercicio: json['nomeExercicio'] ?? '',
      series: json['series'] ?? 0,
      repeticoes: json['repeticoes'] ?? 0,
      tempoS: json['tempoS'] ?? 0,
      intensidade: json['intensidade'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class PlanoTreinoPage extends StatefulWidget {
  @override
  _PlanoTreinoPageState createState() => _PlanoTreinoPageState();
}

class _PlanoTreinoPageState extends State<PlanoTreinoPage> {
  late List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    fetchExercisesForPlano();
  }

  Future<void> fetchExercisesForPlano() async {
    final userData = await SharedUser.getUserData();
    if (userData != null) {
      final idPlano = userData.idPlanoTreino;
      final response = await http.get(Uri.parse('http://localhost:3000/treinoExercicio/get/$idPlano'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List<dynamic>;
        final exerciseIds =
            jsonResponse.map((item) => item['idExercicio'] as int).toList();
        await fetchExercises(exerciseIds);
      }
    }
  }

  Future<void> fetchExercises(List<int> exerciseIds) async {
    final List<Exercise> exercises = [];

    for (final idExercicio in exerciseIds) {
      final response = await http.get(Uri.parse('http://localhost:3000/exercicio/get/id/$idExercicio'));

      if (response.statusCode == 200) {
        final List<dynamic> exerciseJson = json.decode(response.body);
        for (var item in exerciseJson) {
          if (item is Map<String, dynamic>) {
            final exercise = Exercise.fromJson(item);
            exercises.add(exercise);
          }
        }
      }
    }

    setState(() {
      this.exercises = exercises;
    });
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
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
       body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Plano de Treino',
              style: TextStyle(
                fontSize: 32,  
                fontWeight: FontWeight.bold,  
                color: Colors.blue,  
                shadows: [
                  Shadow(
                    blurRadius: 5,  
                    color: Colors.black,  
                    offset: Offset(2, 2), 
                  ),
                ],
               fontFamily: 'Roboto'
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: exercises.length,
              itemBuilder: (BuildContext context, int index) {
                final exercise = exercises[index];
                return _buildExerciseTile(
                  exercise.nomeExercicio,
                  exercise.imageUrl,
                  exercise.series.toString(),
                  exercise.tempoS.toString(),
                  exercise.intensidade.toString(),
                  exercise.repeticoes.toString(),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildExerciseTile(String nomeExercicio, String imageUrl, String series, String tempo, String intensidade, String repeticoes) {
  return Card(
    child: InkWell(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, color: Colors.red);
            },
          ),
          Text(nomeExercicio, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (int.parse(series) > 0) Text('Séries: $series', style: TextStyle(fontSize: 10)),
          if (int.parse(tempo) > 0) Text('Tempo: $tempo', style: TextStyle(fontSize: 10)),
          if (int.parse(intensidade) > 0) Text('Intensidade: $intensidade', style: TextStyle(fontSize: 10)),
          if (int.parse(repeticoes) > 0) Text('Repetições: $repeticoes', style: TextStyle(fontSize: 10)),
        ],
      ),
    ),
  );
}

}
