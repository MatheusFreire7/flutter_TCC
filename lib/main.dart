import 'package:flutter/material.dart';
import 'package:flutter_login/screens/Cadastro.dart';
import 'package:flutter_login/screens/SelectPlanoTreino.dart';
import 'package:flutter_login/screens/TelaInicio.dart';
import 'package:flutter_login/service/NoticationPage.dart';
import 'package:flutter_login/service/NotificationService.dart';
import 'package:flutter_login/settings/Config.dart';
import 'package:flutter_login/screens/FormPlano.dart';
import 'package:flutter_login/screens/InfoObri.dart';
import 'package:flutter_login/screens/Telainicial.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:flutter_login/widgets/AlimentSaudavel.dart';
import 'package:flutter_login/widgets/PlanoAlimentacao.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'screens/Login.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // showWaterReminderNotification();
  // // Define um timer para mostrar as próximas notificações a cada 2 horas
  // const duration = Duration(hours: 2);
  // Timer.periodic(duration, (Timer t) {
  //   showWaterReminderNotification();
  // });
  runApp(
    MultiProvider(providers: [
      Provider<NotificationService>(create: (context) => NotificationService()),
    ],child: LoginApp()
    ),
  );  
}

void showWaterReminderNotification() {
  if (html.Notification.supported) {
    html.Notification.requestPermission().then((permission) {
      if (permission == 'granted') {
        final notification = html.Notification('Hora de beber água!', body: 'Lembre-se de beber um copo de água.');
        notification.onClick.listen((_) {
          // Ação a ser executada quando o usuário clicar na notificação
          // Você pode adicionar uma ação personalizada aqui, se necessário
        });
      } else {
        // Lidar com o caso em que a permissão não é concedida
        print('Permissão para notificações não concedida');
        showErrorNotification('Erro de Permissão', 'Você não concedeu permissão para notificações.');
      }
    }).catchError((error) {
      // Lidar com erros na solicitação de permissão
      print('Erro na solicitação de permissão: $error');
      showErrorNotification('Erro de Solicitação de Permissão', 'Houve um erro ao solicitar permissão para notificações.');
    });
  } else {
    // Lidar com o caso em que as notificações não são suportadas
    print('Notificações não são suportadas neste navegador');
    showErrorNotification('Notificações Não Suportadas', 'Este navegador não suporta notificações.');
  }
}

void showErrorNotification(String title, String message) {
  final notification = html.Notification(title, body: message);
  notification.onClick.listen((_) {
    // Ação a ser executada quando o usuário clicar na notificação de erro
    // Você pode adicionar uma ação personalizada aqui, se necessário
  });
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
              "notificacao": (context) => NotificacaoPage(),
              "select": (context) => PlanoTreinoDetalhes(imageUrl: '', name: '', title: '', planosTreino: [])
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
