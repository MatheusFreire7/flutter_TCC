import 'package:flutter/material.dart';
import '../settings/theme.dart';
import '../widgets/square.dart';

class PlanoTreinoDetalhes extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String name;

  PlanoTreinoDetalhes({
    required this.title,
    required this.imageUrl,
    required this.name,
  });

  final _formKey = GlobalKey<FormState>();
  final List<String> _listPlano = ['Plano1', 'Plano2', 'Plano3'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.iconColor,
          ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      child: const Text(
                        "Selecione um dos Planos de Treino Abaixo:",
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  for (String plano in _listPlano)
                    MySquare(
                      child: plano,
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
