import 'package:flutter/material.dart';
import 'package:flutter_login/cadastro.dart';
import 'package:flutter_login/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty ) {
                    return 'Por favor, insira seu email.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty ) {
                    return 'Por favor, insira sua senha.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormScreen(),
                    ),
                  );
                  
                },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF78F259),
                minimumSize: Size(200, 50), // define o tamanho mínimo do botão
              ),
                child: Text('Entrar', style: TextStyle(color: Colors.black)),
                
              ),
              SizedBox(
              height: 10,
            ),
            Container(
              color:  Color(0xFF78F259),
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF78F259),
                ),
                child: Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
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
    );
  }
}

