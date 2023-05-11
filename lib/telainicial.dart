import 'package:flutter/material.dart';
import 'package:flutter_login/config.dart';
import 'package:flutter_login/infoObri.dart';
import 'package:flutter_login/login.dart';
import 'package:flutter_login/testeApi.dart';
import 'package:flutter_login/theme.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  // ignore: prefer_final_fields
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
              color: Colors.black), // Defina a cor do ícone aqui
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.black,
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
                accountName: Text("Nome do usuário",
                    style: TextStyle(color: Colors.black)),
                accountEmail: Text("email_do_usuario@gmail.com",
                    style: TextStyle(color: Colors.black)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user_profile.png'),
                  backgroundColor: Color(0xFF29B405),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF78F259),
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
                title: const Text('Plano de Treino'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => TelaInicial()),
                  );
                },
              ),
              ListTile(
                title: const Text('Plano de Dieta'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => TelaInicial()),
                  );
                },
              ),
              ListTile(
                title: const Text('Lista de Exercícios'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => TelaInicial()),
                  );
                },
              ),
              ListTile(
                title: const Text('Suporte'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => TelaInicial()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100.0,
                    width: 200.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "FitLife",
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 64,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       // ignore: prefer_const_constructors
                      //       builder: (context) => ExerciseList()),
                      // );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: [
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       backgroundColor: Colors.blueGrey,
        //       label: 'Início',
        //     ),
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       backgroundColor: Colors.blueGrey,
        //       label: 'Configurações',
        //     ),
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       backgroundColor: Colors.blueGrey,
        //       label: 'Login',
        //     ),
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.fitness_center),
        //       label: 'Exercícios',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.blue,
        //   onTap: _onItemTapped,
        // ),
      ),
    );
  }
}
