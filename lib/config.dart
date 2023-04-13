import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
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
            title: Text('Informações Pessoas'),
            //trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
             
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            trailing: Switch(
              value: true, // Valor da configuração de notificações
              onChanged: (value) {
                // Atualizar o valor da configuração de notificações
              },
            ),
          ),
          // Adicione mais configurações aqui...
        ],
      ),
    );
  }
}

