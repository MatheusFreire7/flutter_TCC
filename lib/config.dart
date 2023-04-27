import 'package:flutter/material.dart';
import 'package:flutter_login/infoObri.dart';
import 'package:flutter_login/login.dart';

class ConfiguracoesPage extends StatefulWidget {
  @override
  _ConfiguracoesPageState createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
   bool _notificacoesAtivas = true;
  ThemeData _themeData = ThemeData.light(); // Tema padrão é o Modo Claro
  Color _appBarColor = Colors.white;
   Color _iconColor = Colors.black; // Cor padrão do ícone na app bar

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Aplicação',
      theme: _themeData, // Define o tema atual da aplicação
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: _iconColor), // Define a cor do ícone na app bar
          backgroundColor:_appBarColor,
          //title: const Text('Configurações'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Informações Pessoais'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalInfoForm(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificações'),
              trailing: Switch(
                value: _notificacoesAtivas, // Valor da configuração de notificações
                onChanged: (value) {
                  setState(() {
                    _notificacoesAtivas = value; // Atualizar o valor da configuração de notificações
                  });
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Tema'),
              trailing: DropdownButton<String>(
                value: 'Modo Claro', // Valor do tema atual
                onChanged: (value) {
                  setState(() {
                    // Atualizar o valor do tema e a cor da aplicação
                    if (value == 'Modo Claro') {
                      _themeData = ThemeData.light();
                       _appBarColor = Colors.white;   // Atualiza a cor de fundo da AppBar
                        _iconColor = Colors.black;
                    } else if (value == 'Modo Escuro') {
                      _themeData = ThemeData.dark();
                       _appBarColor = Colors.black;  // Atualiza a cor de fundo da AppBar
                        _iconColor = Colors.white;
                    }
                  });
                },
                items: <String>['Modo Claro', 'Modo Escuro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
             ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Sair'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}