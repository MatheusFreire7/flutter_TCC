import 'package:flutter/material.dart';
import 'package:flutter_login/config.dart';
import 'package:flutter_login/infoObri.dart';
import 'package:flutter_login/login.dart';
import 'package:flutter_login/promotionBanner.dart';
import 'package:flutter_login/testeApi.dart';

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
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    TelaInicial(),
    ConfiguracoesPage(),
    LoginPage(),
    const ExerciseList()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _screens[_selectedIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial - FitLife'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Nome do usuário"),
              accountEmail: Text("email_do_usuario@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/user_profile_picture.jpg'),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Informações Pessoais'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => PersonalInfoForm()),
                );
              },
            ),
            ListTile(
              title: const Text('Plano de Exercicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Plano de Dieta'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Lista de Exercícios'),
              onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      // ignore: prefer_const_constructors
                      builder: (context) => ExerciseList()),
                );
              },
            ),
            ListTile(
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Suporte'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
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
      body: Column(
        children: [
           PromotionBanner(
            imageUrl: 'assets/images/banner.jpg',
            text: 'Seja bem Vindo ao FitLife!',
          ),
    
          Row(
            children: [
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
                          // ignore: prefer_const_constructors
                          builder: (context) => ExerciseList()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.blueGrey,
            label: 'Início',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            backgroundColor: Colors.blueGrey,
            label: 'Configurações',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.blueGrey,
            label: 'Login',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercícios',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
