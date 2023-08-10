import 'package:flutter/material.dart';
import 'package:flutter_login/screens/cadastro.dart';
import 'package:flutter_login/settings/config.dart';
import 'package:flutter_login/screens/formTreino.dart';
import 'package:flutter_login/screens/infoObri.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/settings/theme.dart';
import 'screens/login.dart';


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

