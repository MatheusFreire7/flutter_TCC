import 'package:flutter/material.dart';
import 'package:flutter_login/alimentSaudavel.dart';
import 'package:flutter_login/config.dart';
import 'package:flutter_login/infoObri.dart';
import 'package:flutter_login/login.dart';
import 'package:flutter_login/progresso.dart';
import 'package:flutter_login/promotionBanner.dart';
import 'package:flutter_login/suporte.dart';
import 'package:flutter_login/testeApi.dart';
import 'package:flutter_login/theme.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: AppTheme.iconColor),
          backgroundColor: AppTheme.appBarColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: AppTheme.iconColor,
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
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Nome do usuário",
                  style: TextStyle(color: Colors.black),
                ),
                accountEmail: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8), 
                    Text(
                      "email_do_usuario@gmail.com",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 8), 
                    Text(
                      "IMC Atual:",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
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
                      builder: (context) => PersonalInfoForm(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Plano de Treino'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaInicial(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Plano de Dieta'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaInicial(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Lista de Exercícios'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaInicial(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Suporte'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Configurações'),
                onTap: () {
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
            // PromotionBanner(
            //   imageUrl: 'imagem',
            //   text: 'Seja Bem vindo!',
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    CustomCard(
                      title: 'Informações Pessoais',
                      icon: Icons.person,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalInfoForm(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      title: 'Plano de Treino',
                      icon: Icons.fitness_center,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaInicial(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      title: 'Plano de Dieta',
                      icon: Icons.food_bank,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaInicial(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      title: 'Lista de Exercícios',
                      icon: Icons.list_alt,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaInicial(),
                          ),
                        );
                      },
                    ),
                     CustomCard(
                      title: 'Progresso',
                      icon: Icons.trending_up,
                      onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Progresso.withSampleData(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      title: 'Alimentação Saudável',
                      icon: Icons.restaurant_menu,
                      onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlimentacaoSaudavel()
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      title: 'Configurações',
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfiguracoesPage(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      title: 'Suporte',
                      icon: Icons.help_outline,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SupportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       backgroundColor: Colors.blueGrey,
        //       label: 'Início',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       backgroundColor: Colors.blueGrey,
        //       label: 'Configurações',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       backgroundColor: Colors.blueGrey,
        //       label: 'Login',
        //     ),
        //     BottomNavigationBarItem(
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

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CustomCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



