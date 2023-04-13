import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}


class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Cadastro'),
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
                if (value!.isEmpty) {
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
                if (value!.isEmpty) {
                  return 'Por favor, insira sua senha.';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // if (_formKey.currentState.validate()) {
                //   // Aqui você pode adicionar a lógica para criar uma nova conta
                // }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF78F259),
                minimumSize: Size(200, 50), // define o tamanho mínimo do botão
              ),
              child: Text('Cadastrar', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    ),
  );
}
}
