import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/login.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;
import '../service/sharedUser.dart';
import '../service/usuario.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> cadastrar() async {
    final usuario = _usuarioController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (usuario.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        final url = Uri.parse('http://localhost:3000/user/cadastro');
        final response = await http.post(
          url,
          body: jsonEncode({
            'idUsuario': '0',
            'nomeUsuario': usuario,
            'emailUsuario': email,
            'senhaUsuario': password,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          final username = usuario;
          final userEmail = email;

          final userDataObject = UserData(
            idUsuario: 0,
            usuario: username,
            email: userEmail,
            genero: '',
            altura: 0.0,
            peso: 0.0,
            imc: 0.0,
            idPlanoTreino: 0,
            idPlanoAlimentacao: 0,
          );

          await SharedUser.saveUserData(userDataObject);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        } else {
          final error = response.body;
          print(error);
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
        print('Erro: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro de Cadastro'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro de Cadastro'),
          content:
              const Text('Preencha todas as credenciais. Tente Novamente.'),
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
    _usuarioController.dispose();
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
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _usuarioController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person), // Ícone de usuário
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira seu usuário.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email), // Ícone de email
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
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock), // Ícone de cadeado
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
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock), // Ícone de cadeado
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
                      cadastrar();
                    },
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
                          'Cadastrar',
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
        ),
      ),
    );
  }
}
