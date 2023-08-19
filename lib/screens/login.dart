import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login/screens/cadastro.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/service/localNotification.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    localNotification.initilize(flutterLocalNotificationsPlugin);
  }

  Future<void> login(String usuario, String email, String password) async {
      print(jsonEncode( {'nomeUsuario': usuario, 'emailUsuario': email, 'senhaUsuario': password}));
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        body: jsonEncode({
          'nomeUsuario': usuario,
          'emailUsuario': email,
          'senhaUsuario': password
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print(jsonEncode( {'nomeUsuario': usuario, 'emailUsuario': email, 'senhaUsuario': password}));
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
            content: Text(
                'Login inválido. Verifique suas credenciais e tente novamente.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Captura e mostra qualquer exceção lançada durante a execução do código
      print('Ocorreu uma exceção: $e');
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void dispose() {
    _usuarioController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                        onPressed: () {
                            final usuario = _usuarioController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        login(usuario, email, password);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => TelaInicial()),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF78F259),
                          minimumSize: const Size(30, 55),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: const Text('Entrar',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "Não tem Conta?",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF78F259),
                        minimumSize: const Size(30, 55),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text(
                        "Cadastre-se",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                      onPressed: () {
                        localNotification.showBigTextNotification(title: "teste", body: "mensagem", flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
