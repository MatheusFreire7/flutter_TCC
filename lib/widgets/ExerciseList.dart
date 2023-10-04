import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Treino.dart';
import '../settings/theme.dart';

class Exercise {
  final String title;
  final String description;
  final String imageUrl;
  final String series;
  final String duration;

  Exercise({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.series,
    required this.duration,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      series: json['series'],
      duration: json['duration'],
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

  Future<List<Exercise>> fetchExercises() async {
    final response =
        await http.get(Uri.parse('http://localhost:3001/exercicios'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((exercise) => Exercise.fromJson(exercise))
          .toList();
    } else {
      throw Exception('Falha para carregar os exercícios da API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExercises().then((exercises) {
      setState(() {
        this.exercises = exercises;
      });
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
                        title: exercises[index].title,
                        imageUrl: exercises[index].imageUrl,
                        series: exercises[index].series,
                        duration: exercises[index].duration,
                        description: exercises[index].description,
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
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercises[index].title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            exercises[index].description,
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Séries: ${exercises[index].series}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Duração: ${exercises[index].duration}',
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
