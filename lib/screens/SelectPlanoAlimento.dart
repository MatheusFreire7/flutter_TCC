import 'package:flutter/material.dart';
import 'package:flutter_login/screens/Telainicial.dart';
import '../service/SharedUser.dart';
import '../settings/theme.dart';
import '../widgets/Square.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginUser.dart';

class PlanoAlimentoDetalhes extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String name;
  final List<dynamic> planosAlimentos;

  PlanoAlimentoDetalhes({
    this.title = '',
    this.imageUrl = '',
    this.name = '',
    this.planosAlimentos = const [],
  });

  @override
  _PlanoAlimentoDetalhesState createState() => _PlanoAlimentoDetalhesState();
}

class _PlanoAlimentoDetalhesState extends State<PlanoAlimentoDetalhes> {
  int selectPlanIndex = -1;
  List<dynamic> planosAlimentos = [];
  int selectedPlanId = -1; 

  @override
  void initState() {
    super.initState();
    getPlanosAlimento();
  }

  Future<void> getPlanosAlimento() async {
    const urlBase = 'http://localhost:3000/planoAlimentacao/get/';
    final response = await http.get(Uri.parse(urlBase));

    if (response.statusCode == 200) {
      final planos = json.decode(response.body);

      for (var plano in planos) {
          planosAlimentos.add(plano);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.iconColor,
          ),
          backgroundColor: AppTheme.appBarColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    child: const Text(
                      "Selecione um dos Planos de Alimentação:",
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Planos de Alimentação:",
                  style: TextStyle(fontSize: 25, color: Colors.red),
                ),
                const SizedBox(height: 8.0),
                for (int index = 0; index < planosAlimentos.length; index++)
                  Column(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: selectPlanIndex == index
                              ? Colors.red
                              : Colors.white,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectPlanIndex = index;
                              selectedPlanId = planosAlimentos[index]["idPlanoAlimentacao"];
                              print('ID do plano selecionado: ${selectedPlanId}');
                            });
                          },
                          child: MySquare(
                            child: planosAlimentos[index]["nomePlanoAlimentacao"],
                            intensidade: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0), // Espaço entre os planos não recomendados
                    ],
                  ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    minimumSize: Size(double.infinity, 50.0),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    print(selectedPlanId);
                    final userData = await SharedUser.getUserData();
         
                      if (userData != null) {
                          if(userData.idPlanoAlimentacao == 0){
                              userData.idPlanoAlimentacao = selectedPlanId;
                              await SharedUser.saveUserData(userData); // Atualize o objeto userData com o novo idPlanoAlimentacao

                              // Envie o novo idPlanoTreino para a API
                              final apiUrl ='http://localhost:3000/usuarioAlimentacao/cadastro';
                              final requestBody = {
                                'idUsuario': userData.idUsuario,
                                'idPlanoAlimentacao': selectedPlanId,
                              };

                              try {
                                final response = await http.post(
                                  Uri.parse(apiUrl),
                                  body: jsonEncode(requestBody),
                                  headers: {'Content-Type': 'application/json'},
                                );

                                if (response.statusCode == 201) {
                                  // O recurso foi criado com sucesso na API
                                  print('Plano adicionado com sucesso!');
                                } else {
                                  // Handle outros códigos de status, se necessário
                                  print(
                                      'Erro ao adicionar o plano. Código de status: ${response.statusCode}');
                                }
                              } catch (e) {
                                // Handle erros de conexão
                                print('Erro de conexão: $e');
                              }
                          }
                      }
                      
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaInicial()
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.blue],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 120.0,
                      ),
                      child: Text(
                        'Tela Inicial',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
