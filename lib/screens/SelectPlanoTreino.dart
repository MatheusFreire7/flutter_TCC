import 'package:flutter/material.dart';
import 'package:flutter_login/screens/SelectPlanoAlimento.dart';
import '../service/SharedUser.dart';
import '../settings/theme.dart';
import '../widgets/Square.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginUser.dart';

class PlanoTreinoDetalhes extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String name;
  final List<dynamic> planosTreino;

  PlanoTreinoDetalhes({
    required this.title,
    required this.imageUrl,
    required this.name,
    required this.planosTreino,
  });

  @override
  _PlanoTreinoDetalhesState createState() => _PlanoTreinoDetalhesState();
}

class _PlanoTreinoDetalhesState extends State<PlanoTreinoDetalhes> {
  int selectedRecomendadoPlanIndex = -1;
  int selectedNaoRecomendadoPlanIndex = -1;
  List<dynamic> planosNaoRecomendados = [];
  int selectedPlanId = -1;

  @override
  void initState() {
    super.initState();
    getPlanosNaoRecomendados();
  }

  Future<void> getPlanosNaoRecomendados() async {
    const urlBase = 'http://localhost:3000/planoTreino/get/';
    final response = await http.get(Uri.parse(urlBase));

    if (response.statusCode == 200) {
      final planos = json.decode(response.body);

      // Filtrar planos que não foram recomendados
      for (var plano in planos) {
        final planoId = plano['idPlanoTreino'];
        if (!foiRecomendado(planoId)) {
          planosNaoRecomendados.add(plano);
        }
      }
    }

    setState(() {});
  }

  bool foiRecomendado(int planoId) {
    for (var planoRecomendado in widget.planosTreino) {
      if (planoRecomendado[0]['idPlanoTreino'] == planoId) {
        return true;
      }
    }
    return false;
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
                      "Selecione um dos Planos de Treino Abaixo:",
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  "Planos de Treino Recomendado:",
                  style: TextStyle(fontSize: 25, color: Colors.green),
                ),
                const SizedBox(height: 5.0),
                for (int index = 0; index < widget.planosTreino.length; index++)
                  Column(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: selectedRecomendadoPlanIndex == index
                              ? Colors.red
                              : Colors.white,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedRecomendadoPlanIndex = index;
                              selectedNaoRecomendadoPlanIndex =
                                  -1; // Limpar a seleção de não recomendados
                              selectedPlanId = widget.planosTreino[index][0][
                                  "idPlanoTreino"]; // Atualize o ID do plano selecionado
                              print(
                                  'ID do plano selecionado: ${selectedPlanId}');
                            });
                          },
                          child: MySquare(
                            child: widget.planosTreino[index][0]
                                ["nomePlanoTreino"],
                            intensidade: widget.planosTreino[index][0]
                                ["intensidade"],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0), // Espaço entre os planos
                    ],
                  ),
                const SizedBox(height: 16.0),
                const Text(
                  "Planos de Treino Não Recomendados:",
                  style: TextStyle(fontSize: 25, color: Colors.red),
                ),
                for (int index = 0;
                    index < planosNaoRecomendados.length;
                    index++)
                  Column(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: selectedNaoRecomendadoPlanIndex == index
                              ? Colors.red
                              : Colors.white,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedNaoRecomendadoPlanIndex = index;
                              selectedRecomendadoPlanIndex =
                                  -1; // Limpar a seleção de recomendados
                              selectedPlanId = planosNaoRecomendados[index][
                                  "idPlanoTreino"]; // Atualize o ID do plano selecionado
                              print(
                                  'ID do plano selecionado: ${selectedPlanId}');
                            });
                          },
                          child: MySquare(
                            child: planosNaoRecomendados[index]
                                ["nomePlanoTreino"],
                            intensidade: planosNaoRecomendados[index]
                                ["intensidade"],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0), // Espaço entre os planos não recomendados
                    ],
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    minimumSize: const Size(double.infinity, 50.0),
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

                    if (userData!.idPlanoTreino == 0) {
                      userData.idPlanoTreino = selectedPlanId;

                      // Atualize o objeto userData com o novo idPlanoTreino localmente
                      await SharedUser.saveUserData(userData);

                      // Envie o novo idPlanoTreino para a API
                      final apiUrl ='http://localhost:3000/usuarioTreino/cadastro';
                      final requestBody = {
                        'idUsuario': userData.idUsuario,
                        'idPlanoTreino': selectedPlanId,
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

                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlanoAlimentoDetalhes()),
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.blue],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 120, minHeight: 50),
                      alignment: Alignment.center,
                      child: const Text(
                        'Seletor de Planos de Alimentação',
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
