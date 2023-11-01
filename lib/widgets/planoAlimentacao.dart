import 'package:flutter/material.dart';
import '../screens/telainicial.dart';
import '../settings/theme.dart';

class Diet extends StatefulWidget {
  @override
  _DietState createState() => _DietState();
}

class _DietState extends State<Diet> {
  final List<String> daysOfWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  String _selectedDay = ''; // Inicialmente vazio, será preenchido com o dia atual

     @override
  void initState() {
    super.initState();
    // Obtenha o dia da semana atual e atribua à variável _selectedDay
    _selectedDay = _getCurrentDayOfWeek();
  }

  String _getCurrentDayOfWeek() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday; // Retorna um número de 1 (segunda-feira) a 7 (domingo)
    
    switch (dayOfWeek) {
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: DefaultTabController(
          length: 3,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeData,
            home: DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: AppTheme.iconColor,
                  ),
                  backgroundColor: AppTheme.appBarColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaInicial(),
                        ),
                      );
                    },
                  ),
                  bottom: PreferredSize(
                    preferredSize:
                        const Size.fromHeight(100), // Aumente a altura para acomodar o seletor de dia da semana
                    child: Column(
                      children: [
                        DropdownButton<String>(
                          value: _selectedDay,
                          items: daysOfWeek.map((String day) {
                            return DropdownMenuItem<String>(
                              value: day,
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? day) {
                            setState(() {
                              _selectedDay = day!;
                            });
                          },
                          elevation: 0, 
                        ),
                        TabBar(
                          tabs: const <Widget>[
                            Tab(
                              child: Text('Café da Manhã',style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Tab(
                              child: Text('Almoço', style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Tab(
                              child: Text('Janta',style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ],
                          labelColor: Colors.black87,
                          unselectedLabelColor: Colors.grey[400],
                          indicatorWeight: 4.0,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor:const Color.fromRGBO(215, 225, 255, 1.0),
                          isScrollable: true, 
                        ),
                      ],
                    ),
                  ),
                  title: const Text("Plano de Alimentação", style: TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.w700,)),
                  centerTitle: true, // Centralizar o título
                ),
                body: TabBarView(
                    children: [
                    // Exemplos de refeições para cada aba
                    _buildMealExample('Café da Manhã', [
                      MealItem('Omelete de espinafre', '1 porção'),
                      MealItem('Aveia com banana', '1 tigela'),
                      MealItem('Suco de laranja', '1 copo'),
                    ]),
                    _buildMealExample('Almoço', [
                      MealItem('Frango grelhado', '150g'),
                      MealItem('Arroz integral', '1 xícara'),
                      MealItem('Brócolis cozido', '1 porção'),
                    ]),
                    _buildMealExample('Janta', [
                      MealItem('Salmão assado', '150g'),
                      MealItem('Quinua cozida', '1 xícara'),
                      MealItem('Abobrinha refogada', '1 porção'),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

Widget _buildMealExample(String mealName, List<MealItem> mealItems) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: mealItems.map((mealItem) {
            return ListTile(
              leading: const Icon(Icons.fastfood), // Ícone de comida
              title: Text(
                mealItem.food,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              subtitle: Text(
                'Quantidade: ${mealItem.quantity}',
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

class MealItem {
  final String food;
  final String quantity;

  MealItem(this.food, this.quantity);
}
