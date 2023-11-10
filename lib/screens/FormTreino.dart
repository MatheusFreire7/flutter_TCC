import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login/service/sharedUser.dart';
import 'SelectPlanoTreino.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _age;
  late double _height;
  late double _weight;
  String idUsuario = "";
  String _gender = "Masculino";
  String _restricao = 'Nenhuma';
  String _meta = 'Hipertrofia';
  late String previsao_ia = "";
  bool _isLoading = false;
  Future<void>? _previsaoFuture;


  Future<List<dynamic>> getPlano(String classificacaoPlano) async {
    List<int> idPlanos = [];

    if (classificacaoPlano != " ") {
      if (classificacaoPlano == "intensivo") {
        idPlanos.add(1);
      } else if (classificacaoPlano == "intermediário") {
        idPlanos.add(2);
        idPlanos.add(4);
      } else if (classificacaoPlano == "menos_intensivo") {
        idPlanos.add(3);
        idPlanos.add(5);
      }

      final urlBase = 'http://localhost:3000/planoTreino/get';

      List<dynamic> planos = [];

      for (int id in idPlanos) {
        final url = Uri.parse('$urlBase/$id'); // Adiciona o ID à URL aqui
        final response = await http.get(url);

        if (response.statusCode == 200) {
          // Apenas decodifique e adicione o plano se a resposta for bem-sucedida (código 200)
          var plano = json.decode(response.body);
          planos.add(plano);
        }
      }

      return planos;
    }

    return []; // Retorna uma lista vazia se a classificação do plano for inválida ou em branco
  }


  Future<void> prever() async {
    final nome = _name.toString().trim();
    final idade = _age.toString().trim();
    final altura = _height.toString().trim();
    final peso = _weight.toString().trim();
    final genero = _gender;
    final restricao = _restricao;
    final meta = _meta;

    if (nome.isNotEmpty && idade.isNotEmpty && altura.isNotEmpty && peso.isNotEmpty && genero.isNotEmpty && restricao.isNotEmpty && meta.isNotEmpty) {
      try {
        final url = Uri.parse('http://localhost:3030/previsao');
        final response = await http.post(
          url,
          body: jsonEncode({
            "genero": genero.toLowerCase(),
            "idade": idade,
            "peso": peso,
            "altura": altura,
            "meta": meta.toLowerCase(),
            "restricao": restricao.toLowerCase()
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
         final userData = await SharedUser.getUserData();
         
          if (userData != null) {
            if (userData.usuario == " " || userData.idade == 0 || userData.altura == 0 || userData.peso == 0 || userData.genero == "") {
                  if (userData.usuario == " ") {
                    userData.usuario = _name;
                  }

                  if (userData.idade == 0) {
                    userData.idade = _age;  
                  }

                  if (userData.altura == 0) {
                    userData.altura = _height;  
                  }

                  if (userData.peso == 0) {
                    userData.peso = _weight;  
                  }

                  if (userData.genero == "") {
                    userData.genero = _gender;  
                  }

                  await SharedUser.saveUserData(userData);
            }
          }

          print(response.body);
          final previsaoIa = json.decode(response.body);
          previsao_ia = previsaoIa['previsao'];
        } else {
          final error = response.body;
          print(error);
           // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: const Text(
                  'Erro',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                content:  const Text(
                  'Falha ao Montar Plano. Verifique as Credencias e Tente Novamente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      } catch (e) {
        print('Erro: $e');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: const Text(
                  'Erro de Conexão com o Servidor',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                content: const Text(
                  'Ocorreu um erro ao processar a solicitação. Por favor, tente novamente mais tarde.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
    } else {
       showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text(
              'Erro de Cadastro',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            content: const Text(
              'Preencha todas as credenciais e tente novamente.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
     }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppTheme.iconColor),
          backgroundColor: AppTheme.appBarColor,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
        alignment: Alignment.center,
         children: [ SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      height: 100.0,
                      width: 200.0,
                      child: const Text(
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
                  const SizedBox(height: 3.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Idade'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira sua idade';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _age = int.parse(value!);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Altura (cm)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira sua altura';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _height = double.parse(value!);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira seu peso';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _weight = double.parse(value!);
                    },
                  ),
                  const SizedBox(height: 16),
                     DropdownButtonFormField(
                    value: _gender,
                    items: ['Masculino','Feminino']
                          .map<DropdownMenuItem<String>>((String value){
                             return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                         decoration: const InputDecoration(
                        labelText: 'Gênero',
                         enabledBorder: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      icon: const Padding( 
                        padding: EdgeInsets.only(left:20),
                        child: Icon(Icons.arrow_circle_down_sharp)
                      ), 
                     isExpanded: true, 
                      onChanged: (String? newValue) {
                        setState(() {
                          _gender = newValue!;
                        });
                      },
                  ),     
                   const SizedBox(height: 16),
                    DropdownButtonFormField(
                    value: _meta,
                    items: ['Hipertrofia','Emagrecimento']
                          .map<DropdownMenuItem<String>>((String value){
                             return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                         decoration: const InputDecoration(
                        labelText: 'Meta',
                         enabledBorder: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      icon: const Padding( 
                        padding: EdgeInsets.only(left:20),
                        child: Icon(Icons.arrow_circle_down_sharp)
                      ), 
                     isExpanded: true, 
                      onChanged: (String? newValue) {
                        setState(() {
                          _meta = newValue!;
                        });
                      },
                  ),     
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: _restricao,
                    items: ['Nenhuma','Diabetes','Doença Respiratória','Problema Físico','Outro']
                          .map<DropdownMenuItem<String>>((String value){
                             return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                         decoration: const InputDecoration(
                        labelText: 'Restrição',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      icon: const Padding( 
                        padding: EdgeInsets.only(left:20),
                        child:Icon(Icons.arrow_circle_down_sharp)
                      ), 
                     isExpanded: true, 
                      onChanged: (String? newValue) {
                        setState(() {
                          _restricao = newValue!;
                        });
                      },
                  ),     
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: const LinearGradient(
                          colors: [Colors.cyan, Colors.blue],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                   child: ElevatedButton(
                    onPressed: _isLoading
                      ? null // Desabilitar o botão enquanto isLoading for verdadeiro
                      : () async {
                          if (_formKey.currentState!.validate() && _isLoading != true) {
                            _formKey.currentState?.save();
                            setState(() {
                              _isLoading = true; // Ativa o indicador de progresso
                              _previsaoFuture = prever(); // Inicia a função prever
                            });

                            // Espere a conclusão da função prever
                            await _previsaoFuture;

                            // Após a conclusão, desative o indicador de progresso
                            setState(() {
                              _isLoading = false;
                            });

                            print('Classificação: $previsao_ia');
                          }
                        if (previsao_ia != "") {
                            List<dynamic> planosTreino = await getPlano(previsao_ia);
                            print(planosTreino);

                            if (planosTreino.isNotEmpty) {
                              for (var planoSelecionado in planosTreino) {
                                final title = planoSelecionado[0]["nomePlanoTreino"];
                                const imageUrl = "";
                                const name = "nome"; 

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlanoTreinoDetalhes(
                                      title: title,
                                      imageUrl: imageUrl,
                                      name: name,
                                      planosTreino: planosTreino, 
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                    child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Montar Plano de Treino', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      minimumSize: Size(double.infinity, 60.0),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      shadowColor: Colors.transparent,
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        )
        ]
        ),
      ),
    );
  }
}
