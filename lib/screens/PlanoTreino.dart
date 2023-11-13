import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../service/sharedUser.dart';
import '../widgets/TreinoDetalhes.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

enum IntensidadeFiltro { Baixa, Intermediaria, Alta }

class Exercise {
  Exercise({
    required this.idExercicio,
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.tempoS,
    required this.intensidade,
    required this.ciclo,
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
      ciclo: json['ciclo'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  final String ciclo;
  final int idExercicio;
  final String imageUrl;
  final int intensidade;
  final String nomeExercicio;
  final int repeticoes;
  final int series;
  final int tempoS;

  IntensidadeFiltro get intensidadeFiltro {
    switch (intensidade) {
      case 1:
        return IntensidadeFiltro.Baixa;
      case 2:
        return IntensidadeFiltro.Intermediaria;
      case 3:
        return IntensidadeFiltro.Alta;
      default:
        return IntensidadeFiltro.Baixa; // ou outro valor padrão
    }
  }

  int get tempoMinutos => tempoS ~/ 60;
}

class PlanoTreinoPage extends StatefulWidget {
  @override
  _PlanoTreinoPageState createState() => _PlanoTreinoPageState();
}

String convertToMinutes(int seconds) {
  if (seconds >= 60) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    if (remainingSeconds > 0) {
      return '$minutes Minutos e $remainingSeconds Segundos';
    } else {
      return '$minutes Minutos';
    }
  } else {
    return '$seconds Segundos';
  }
}

String intensidadeText(int intensidade) {
  if (intensidade == 1) {
    return "Baixa";
  } else if (intensidade == 2) {
    return "Intermediária";
  } else if (intensidade == 3) {
    return "Alta";
  }
  return "Desconhecida";
}

class _PlanoTreinoPageState extends State<PlanoTreinoPage> {
  late List<Exercise> exercises = [];
  late TextEditingController searchController = TextEditingController();
  // late String selectedDay = capitalize(DateFormat('EEEE', 'pt_BR')
  //     .format(DateTime.now())); // Inicializa com o dia da semana atual
  late String selectedDay = "A";
  IntensidadeFiltro? selectedIntensidadeFiltro;

  @override
  void initState() {
    super.initState();
    try {
      initializeDateFormatting('pt_BR', null);
    } catch (e) {
      print('Erro na inicialização da localização: $e');
    }
    fetchExercisesForPlano();
  }

  String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<void> fetchExercisesForPlano() async {
    final userData = await SharedUser.getUserData();
    if (userData != null) {
      final idPlano = userData.idPlanoTreino;
      final response = await http
          .get(Uri.parse('http://localhost:3000/treinoExercicio/get/$idPlano'));

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
      final response = await http.get(
          Uri.parse('http://localhost:3000/exercicio/get/id/$idExercicio'));

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

    final filteredExercises = exercises.where((exercise) {
      if (exercise.ciclo == 'A' &&
          (selectedDay == 'A' ||
              selectedDay == 'Quinta-feira' ||
              selectedDay == 'Domingo')) {
        if (selectedIntensidadeFiltro != null &&
            exercise.intensidadeFiltro != selectedIntensidadeFiltro) {
          return false; // Filtrar por intensidade
        }
        return true;
      } else if (exercise.ciclo == 'B' &&
          (selectedDay == 'B' || selectedDay == 'Sexta-feira')) {
        if (selectedIntensidadeFiltro != null &&
            exercise.intensidadeFiltro != selectedIntensidadeFiltro) {
          return false; // Filtrar por intensidade
        }
        return true;
      } else if (exercise.ciclo == 'C' &&
          (selectedDay == 'C' || selectedDay == 'Sábado')) {
        if (selectedIntensidadeFiltro != null &&
            exercise.intensidadeFiltro != selectedIntensidadeFiltro) {
          return false; // Filtrar por intensidade
        }
        return true;
      }
      return false;
    }).toList();

    setState(() {
      this.exercises = filteredExercises;
    });
  }

  Widget _buildDaySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton<String>(
          value: selectedDay,
          items: [
              "A",
              "B",
              "C"
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedDay = capitalize(newValue!);
              fetchExercisesForPlano();
            });
          },
          underline: Container(),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
        ),
      ),
    );
  }

  Widget _buildIntensidadeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filtrar por Intensidade:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<IntensidadeFiltro>(
              value: selectedIntensidadeFiltro,
              items: IntensidadeFiltro.values.map((IntensidadeFiltro value) {
                return DropdownMenuItem<IntensidadeFiltro>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
              onChanged: (IntensidadeFiltro? newValue) {
                setState(() {
                  selectedIntensidadeFiltro = newValue;
                  fetchExercisesForPlano();
                });
              },
              underline: Container(),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseTile(String nomeExercicio, String imageUrl,
      String series, String tempo, String intensidade, String repeticoes) {
    return Card(
      elevation: 5,
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
            const SizedBox(height: 8),
            Text(
              nomeExercicio,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (int.parse(series) > 0)
              Text('Séries: $series', style: TextStyle(fontSize: 12)),
            if (int.parse(tempo) > 0)
              Text('Tempo: ${convertToMinutes(int.parse(tempo))}',
                  style: TextStyle(fontSize: 12)),
            if (int.parse(intensidade) > 0)
              Text('Intensidade: ${intensidadeText(int.parse(intensidade))}',
                  style: TextStyle(fontSize: 12)),
            if (int.parse(repeticoes) > 0)
              Text('Repetições: $repeticoes', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
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
          title: const Text(
            'Plano de Treino',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Adicionar funcionalidade de busca
                showSearch(
                  context: context,
                  delegate: ExerciseSearchDelegate(exercises),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Exercícios para $selectedDay',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDaySelector(),
                  SizedBox(height: 16),
                  _buildIntensidadeFilter(),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
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
}

class ExerciseSearchDelegate extends SearchDelegate<Exercise> {
  ExerciseSearchDelegate(this.exercises);

  final List<Exercise> exercises;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Corrigir para fechar a tela de pesquisa sem retornar um resultado
        close(
          context,
          Exercise(
            idExercicio: 0,
            nomeExercicio: '',
            series: 0,
            repeticoes: 0,
            tempoS: 0,
            intensidade: 0,
            ciclo: '',
            imageUrl: '',
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implementar a exibição dos resultados da pesquisa
    final filteredExercises = exercises
        .where((exercise) =>
            exercise.nomeExercicio.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(filteredExercises);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implementar sugestões enquanto o usuário digita
    final filteredExercises = exercises
        .where((exercise) =>
            exercise.nomeExercicio.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(filteredExercises);
  }

  Widget _buildSearchResults(List<Exercise> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        final exercise = results[index];
        return ListTile(
          title: Text(exercise.nomeExercicio),
          onTap: () {
            // Corrigir para retornar o resultado da pesquisa
            close(context, exercise);
          },
        );
      },
    );
  }
}
