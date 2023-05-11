import 'package:flutter/material.dart';
import 'package:flutter_login/cadastro.dart';
import 'package:flutter_login/config.dart';
import 'package:flutter_login/formTreino.dart';
import 'package:flutter_login/infoObri.dart';
import 'package:flutter_login/telainicial.dart';
import 'package:flutter_login/theme.dart';
import 'login.dart';


void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLife',
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
       initialRoute: "login",
      routes: {
        "login":(context) =>  LoginPage(),
        "cadastro":(context) => CadastroPage(),
        "inicial":(context) => TelaInicial(),
        "form":(context) => FormScreen(),
        "info":(context) => PersonalInfoForm(),
        "config":(context) => ConfiguracoesPage()
      },
    );
  }
}

