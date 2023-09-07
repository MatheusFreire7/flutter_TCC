import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/cadastro.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/service/usuario.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/sharedUser.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String usuario, String email, String password) async {
    if (usuario.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/user/login'),
          body: jsonEncode({
            'nomeUsuario': usuario,
            'emailUsuario': email,
            'senhaUsuario': password,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);

          final userId = userData['user']['id'];
          final username = userData['user']['username'];
          final userEmail = userData['user']['email'];

          final userDataObject = UserData(
            idUsuario: userId,
            usuario: username,
            email: userEmail,
            genero: '', // Preencha com o valor correto, se disponível no servidor
            altura: 0.0, // Preencha com o valor correto, se disponível no servidor
            peso: 0.0, // Preencha com o valor correto, se disponível no servidor
            imc: 0.0, // Preencha com o valor correto, se disponível no servidor
            idPlanoTreino: 0, // Preencha com o valor correto, se disponível no servidor
            idPlanoAlimentacao:0, // Preencha com o valor correto, se disponível no servidor
          );

          await SharedUser.saveUserData(userDataObject);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaInicial()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Login Falhou'),
                content: Text(
                    'Login inválido. Verifique suas credenciais e tente novamente.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Ocorreu uma exceção: $e');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Falhou'),
            content: Text('Preencha todas as credenciais e tente novamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
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
            //title: const Text('Login'),
            centerTitle: true,
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
                      controller: _usuarioController,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira seu Usuário.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const SizedBox(height: 3.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
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
                    SizedBox(
                      width: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          minimumSize: Size(double.infinity, 50.0),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          final usuario = _usuarioController.text;
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          login(usuario, email, password);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => TelaInicial()),
                          // );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                              colors: [Colors.cyan, Colors.blue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 143.0,
                            ),
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        minimumSize: Size(double.infinity, 50.0),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastroPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: [Colors.cyan, Colors.blue],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 120.0,
                          ),
                          child: Text(
                            'Cadastre-se',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
