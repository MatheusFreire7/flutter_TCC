import 'package:flutter/material.dart';
import 'package:flutter_login/telainicial.dart';
import 'package:flutter_login/theme.dart';

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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      height: 100.0,
                      width: 200.0,
                      child: Text(
                        "FitLife",
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 64,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Sexo'),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Idade'),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Altura (cm)'),
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
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
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
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        // Chamar método para montar o treino
                        print('Nome: $_name');
                        print('Sexo: $_sex');
                        print('Idade: $_age');
                        print('Altura: $_height');
                        print('Peso: $_weight');
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaInicial(),
                        ),
                      );
                    },
                    child: Text('Montar Treino', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF78F259),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
