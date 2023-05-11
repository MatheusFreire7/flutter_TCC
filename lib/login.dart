import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/cadastro.dart';
import 'package:flutter_login/telainicial.dart';
import 'package:flutter_login/theme.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      print(jsonEncode({'email': email, 'password': password}));
      print(response.body);

      if (response.statusCode == 200) {
        // Se o login foi bem sucedido, navegue para a tela inicial
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaInicial()),
        );
      } else {
        // Se o login falhar, mostre uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text(
                'Login inválido. Verifique suas credenciais e tente novamente.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Captura e mostra qualquer exceção lançada durante a execução do código
      print('Ocorreu uma exceção: $e');
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      theme:AppTheme.themeData,

     home : Scaffold(
      appBar: AppBar(
       iconTheme: IconThemeData(color: AppTheme.iconColor), // Define a cor do ícone na app bar
       backgroundColor: AppTheme.appBarColor,
        //title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
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
                  child: Text(
                    "FitLife", 
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 64,
                    fontStyle: FontStyle.italic,
                   fontWeight: FontWeight.bold,
                     )
                  ),
                ),
              ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaInicial()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF78F259),
                    minimumSize: const Size(30, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Entrar', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Não tem Conta?",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: const Color(0xFF78F259),
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF78F259),
                  ),
                  child: const Text(
                    "Cadastre-se",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
