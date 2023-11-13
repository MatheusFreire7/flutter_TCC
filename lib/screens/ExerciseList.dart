import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/TreinoDetalhes.dart';
import 'package:flutter_login/settings/theme.dart';

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

String getIntensityLabel(String intensidade) {
  switch (intensidade) {
    case '1':
      return 'Baixa';
    case '2':
      return 'Intermediária';
    case '3':
      return 'Alta';
    default:
      return '';
  }
}

 String getFormattedDuration(int tempoS) {
    int seconds = tempoS;

    if (seconds < 60) {
      return '$seconds Segundos';
    } else {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;

      if (remainingSeconds == 0) {
        return '$minutes Minutos';
      } else {
        return '$minutes Minutos e $remainingSeconds Segundos';
      }
    }
  }

class _ExerciseListState extends State<ExerciseList> {
  late List<Exercise> exercises = [];
  bool isAscending = true;
  String selectedAttribute = 'nomeExercicio';

  Future<List<Exercise>?> fetchExercises() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/exercicio/get'));
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

  void toggleSortOrder() {
    setState(() {
      isAscending = !isAscending;
    });
  }

  void updateSelectedAttribute(String? attribute) {
    if (attribute != null) {
      setState(() {
        selectedAttribute = attribute;
      });
    }
  }

  List<Exercise> getSortedExercises() {
    exercises.sort((a, b) {
      var aValue, bValue;

      switch (selectedAttribute) {
        case 'series':
          aValue = a.series;
          bValue = b.series;
          break;
        case 'repeticoes':
          aValue = a.repeticoes;
          bValue = b.repeticoes;
          break;
        case 'tempoS':
          aValue = a.tempoS;
          bValue = b.tempoS;
          break;
        case 'intensidade':
          aValue = a.intensidade;
          bValue = b.intensidade;
          break;
        default:
          aValue = a.nomeExercicio;
          bValue = b.nomeExercicio;
      }

      return isAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    return exercises;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Scaffold(
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
          actions: [
            IconButton(
              icon:
                  Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
              onPressed: toggleSortOrder,
            ),
            DropdownButton<String>(
              value: selectedAttribute,
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.title, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Nome do Exercício',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  value: 'nomeExercicio',
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.format_list_numbered, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Séries',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  value: 'series',
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.repeat, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Repetições',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  value: 'repeticoes',
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Duração',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  value: 'tempoS',
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.timeline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Intensidade',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  value: 'intensidade',
                ),
              ],
              onChanged: updateSelectedAttribute,
              style: TextStyle(color: Colors.black),
              icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
              elevation: 2,
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (BuildContext context, int index) {
            final sortedExercises = getSortedExercises();

            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TreinoDetalhes(
                        nomeExercicio:
                            sortedExercises[index].nomeExercicio.toString(),
                        imageUrl: sortedExercises[index].imageUrl,
                        series: sortedExercises[index].series.toString(),
                        repeticoes:
                            sortedExercises[index].repeticoes.toString(),
                        tempo: sortedExercises[index].tempoS.toString(),
                        intensidade:
                            sortedExercises[index].intensidade.toString(),
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
                        sortedExercises[index].imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sortedExercises[index].nomeExercicio,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (sortedExercises[index].series > 0)
                            Text(
                              'Séries: ${sortedExercises[index].series}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          if (sortedExercises[index].repeticoes > 0)
                            Text(
                              'Repetições: ${sortedExercises[index].repeticoes}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          if (sortedExercises[index].tempoS > 0)
                            Text(
                              'Duração: ${getFormattedDuration(sortedExercises[index].tempoS)}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          Text(
                            'Intensidade: ${getIntensityLabel(sortedExercises[index].intensidade.toString())}',
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
