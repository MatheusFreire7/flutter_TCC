import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Exercise {
  final String title;
  final String description;
  final String imageUrl;

  Exercise({required this.title, required this.description, required this.imageUrl});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class ExerciseList extends StatefulWidget {
  const ExerciseList({Key? key}) : super(key: key);

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  late List<Exercise> exercises;
  
  Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse('http://localhost:3000/exercicios'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((exercise) => Exercise.fromJson(exercise)).toList();
    } else {
      throw Exception('Falha para carregar os exercicios da API');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Exercícios'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: exercises == null ? 0 : exercises.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(exercises[index].description),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

