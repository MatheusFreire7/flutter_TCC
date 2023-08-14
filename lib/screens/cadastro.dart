import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;
import 'formTreino.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _cadastrar() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final url = Uri.parse('http://localhost:3000/cadastro');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Cadastro realizado com sucesso
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormScreen(),
          ),
        );
      } else {
        // Erro ao realizar cadastro
        final error = response.body;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text(error),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Lidar com a exceção aqui
      print('Erro: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao realizar o cadastro.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        home: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: AppTheme.iconColor), // Define a cor do ícone na app bar
            backgroundColor: AppTheme.appBarColor,
            //title: const Text('Cadastro'),
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
                        height: 100.0,
                        width: 200.0,
                        child: const Text("FitLife",
                            style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 64,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira seu email.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira sua senha.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, confirme sua senha.';
                        } else if (value != _passwordController.text) {
                          return 'As senhas não correspondem.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        //_cadastrar();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF78F259),
                        minimumSize: const Size(30, 55), // define o tamanho mínimo do botão
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text('Cadastrar',
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
