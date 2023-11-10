import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  final String ciclo;
  final int idMusculo;

  Exercise({
    required this.idExercicio,
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.tempoS,
    required this.intensidade,
    required this.imageUrl,
    required this.ciclo,
    required this.idMusculo,
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
      ciclo: json['ciclo'] ?? '',
      idMusculo: json['idMusculo'] ?? 0,
    );
  }
}

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  late List<Exercise> exercises = [];

  Future<List<Exercise>?> fetchExercises() async {
    final response = await http.get(Uri.parse('http://localhost:3000/exercicio/get'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
        final exercises = <Exercise>[];
        for (var exerciseJson in jsonResponse[0]) {
          if (exerciseJson is Map<String, dynamic>) {
            exercises.add(Exercise.fromJson(exerciseJson));
          }
        }
        return exercises;
      } else {
        return null;
      }
    } else {
      throw Exception('Falha para carregar os exercícios da API');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchExercises().then((exercises) {
      if (exercises != null) {
        setState(() {
          this.exercises = exercises;
        });
      }
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
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TreinoDetalhes(
                      nomeExercicio:exercises[index].nomeExercicio.toString(),
                      imageUrl: exercises[index].imageUrl,
                      series: exercises[index].series.toString(),
                      repeticoes: exercises[index].repeticoes.toString(),
                      tempo: exercises[index].tempoS.toString(),
                      intensidade: exercises[index].intensidade.toString(),
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.network(
                    exercises[index].imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red); 
                    },
                  )
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercises[index].nomeExercicio,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        if (exercises[index].series > 0) Text(
                          'Séries: ${exercises[index].series}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (exercises[index].repeticoes > 0) Text(
                          'Repetições: ${exercises[index].repeticoes}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (exercises[index].tempoS > 0) Text(
                          'Duração: ${exercises[index].tempoS}',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Intensidade: ${exercises[index].intensidade}',
                          style: TextStyle(color: Colors.grey),
                        ),
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
