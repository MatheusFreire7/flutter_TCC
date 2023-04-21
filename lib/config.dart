import 'package:flutter/material.dart';
import 'package:flutter_login/infoObri.dart';

class ConfiguracoesPage extends StatefulWidget {
  @override
  _ConfiguracoesPageState createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
   bool _notificacoesAtivas = true;
  ThemeData _themeData = ThemeData.light(); // Tema padrão é o Modo Claro

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Aplicação',
      theme: _themeData, // Define o tema atual da aplicação
      home: Scaffold(
        appBar: AppBar(
          title: Text('Configurações'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              //leading: Icon(Icons),
              title: Text('Informações Pessoais'),
              //trailing: Icon(Icons.arrow_forward_ios),
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
              leading: Icon(Icons.notifications),
              title: Text('Notificações'),
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
              leading: Icon(Icons.color_lens),
              title: Text('Tema'),
              trailing: DropdownButton<String>(
                value: 'Modo Claro', // Valor do tema atual
                onChanged: (value) {
                  setState(() {
                    // Atualizar o valor do tema e a cor da aplicação
                    if (value == 'Modo Claro') {
                      _themeData = ThemeData.light();
                    } else if (value == 'Modo Escuro') {
                      _themeData = ThemeData.dark();
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
          ],
        ),
      ),
    );
  }
}