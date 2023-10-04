import 'package:flutter/material.dart';
import 'package:flutter_login/screens/Cadastro.dart';
import 'package:flutter_login/screens/TelaInicio.dart';
import 'package:flutter_login/settings/Config.dart';
import 'package:flutter_login/screens/FormPlano.dart';
import 'package:flutter_login/screens/InfoObri.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:flutter_login/widgets/AlimentSaudavel.dart';
import 'package:flutter_login/widgets/PlanoAlimentacao.dart';
import 'package:flutter_login/widgets/treino.dart';
import 'package:localstorage/localstorage.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  final LocalStorage localStorage;

  LoginApp() : localStorage = LocalStorage('my_app');

  Future<void> initializeLocalStorage() async {
    // Aguarde a inicialização do LocalStorage
    await localStorage.ready;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeLocalStorage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'FitLife',
            theme: AppTheme.themeData,
            debugShowCheckedModeBanner: false,
            initialRoute: "inicio",
            routes: {
              "inicio": (context) => FitnessAppHomeScreen(),
              "login": (context) => LoginPage(),
              "cadastro": (context) => CadastroPage(),
              "inicial": (context) => TelaInicial(),
              "form": (context) => FormScreen(),
              "info": (context) => PersonalInfoForm(),
              "config": (context) => ConfiguracoesPage(),
              "planoAlimentacao": (context) => Diet(),
              "alimento": (context) => AlimentacaoSaudavel(),
            },
          );
        } else {
          return CircularProgressIndicator(); 
        }
      },
    );
  }
}
