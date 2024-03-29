import 'package:flutter/material.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  final String email = 'fitLife@gmail.com';
  final String phoneNumber = '(19)61253-1212';

  void sendEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await launchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Tratar caso o cliente de e-mail não esteja disponível
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Não foi possível abrir o cliente de e-mail.'),
            actions: <Widget>[
              TextButton(
                child: Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void makePhoneCall(BuildContext context) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      // Tratar caso o telefone não esteja disponível
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Não foi possível realizar a chamada telefônica.'),
            actions: <Widget>[
              TextButton(
                child: Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: AppTheme.iconColor),
          backgroundColor: AppTheme.appBarColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entre em contato conosco',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Se você tiver alguma dúvida ou precisar de suporte, não hesite em entrar em contato conosco. Estamos aqui para ajudar!',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Informações de Contato:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('E-mail: $email'),
              onTap: () {
                sendEmail(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telefone: $phoneNumber'),
              onTap: () {
                makePhoneCall(context);
              },
            ),
          ],
        ),
      ),
    ),
    );
  }
}

