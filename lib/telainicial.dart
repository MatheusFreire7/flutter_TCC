import 'package:flutter/material.dart';
import 'package:flutter_login/config.dart';
import 'package:flutter_login/login.dart';
import 'package:flutter_login/treino.dart';

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
                  onTap: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaTreino( title: 'Treino de musculação',
                                                                description:
                                                                    'Este é um treino completo de musculação, incluindo exercícios para peitoral, costas, pernas e braços. É recomendado realizar este treino 3 vezes por semana para obter os melhores resultados.',
                                                                imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyIqYidFja544v8GzJz6A_H7klzwzSOw2gfg&usqp=CAU',),
                            ),
                          );
                      }
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}