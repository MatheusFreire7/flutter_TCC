import 'package:flutter/material.dart';
import 'package:flutter_login/config.dart';
import 'package:flutter_login/login.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10'
  ];
  
  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial - FitLife'),
         actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
             Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfiguracoesPage(),
                    ),
                  );
            },
          ),
        ],
      ),
      body: Column(
        children: [
            Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
              Expanded(
                child: Image.asset(
                'assets/images/logo.png',
                height: 50,
              ),
            )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}