import 'package:flutter/material.dart';
import 'package:flutter_login/telainicial.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _sex;
  late int _age;
  late double _height;
  late double _weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Treino'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Sexo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu sexo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sex = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira sua idade';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira sua altura';
                  }
                  return null;
                },
                onSaved: (value) {
                  _height = double.parse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu peso';
                  }
                  return null;
                },
                onSaved: (value) {
                  _weight = double.parse(value!);
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  //   _formKey.currentState?.save();
                  //   // Chamar método para montar o treino
                  //   print('Nome: $_name');
                  //   print('Sexo: $_sex');
                  //   print('Idade: $_age');
                  //   print('Altura: $_height');
                  //   print('Peso: $_weight');
                  // }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaInicial(),
                    ),
                  );
                },
                child: Text('Montar Treino', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF78F259),
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


