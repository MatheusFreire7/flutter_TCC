import 'package:flutter/material.dart';
import 'package:flutter_login/screens/cadastro.dart';
import 'package:flutter_login/service/sharedUser.dart';
import 'package:flutter_login/service/usuario.dart';
import 'package:flutter_login/settings/config.dart';
import 'package:flutter_login/screens/formTreino.dart';
import 'package:flutter_login/screens/infoObri.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/settings/theme.dart';
import 'screens/login.dart';
import 'package:provider/provider.dart';

void main() {
  // // Chame a função clearUserData ao sair do aplicativo.
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   SharedUser.clearUserData();
  // });

  runApp(
    ChangeNotifierProvider(
      create: (context) => Usuario.vazio(),
      child: LoginApp(),
    ),
  );
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
        "login": (context) => LoginPage(),
        "cadastro": (context) => CadastroPage(),
        "inicial": (context) => TelaInicial(),
        "form": (context) => FormScreen(),
        "info": (context) => PersonalInfoForm(),
        "config": (context) => ConfiguracoesPage()
      },
    );
  }
}
