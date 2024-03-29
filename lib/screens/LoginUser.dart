import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/CadastroUser.dart';
import 'package:flutter_login/screens/FormTreino.dart';
import 'package:flutter_login/screens/Telainicial.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:flutter_login/screens/InfoUser.dart';
import 'package:http/http.dart' as http;
import '../service/SharedUser.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<int> getIdPlanoTreino(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/usuarioTreino/get/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> jsonDataList =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (jsonDataList.isNotEmpty) {
          final idPlanoTreino = jsonDataList.first['idPlanoTreino'];
          return idPlanoTreino;
        } else {
          // Retorna 0 se o idPlanoTreino não estiver definido
          return 0;
        }
      } else {
        // Lida com outros códigos de status, se necessário
        print(
            'Erro ao obter idPlanoTreino. Código de status: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      // Lida com erros de conexão
      print('Erro de conexão ao obter idPlanoTreino: $e');
      return 0;
    }
  }

  Future<int> getIdPlanoAlimentacao(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/usuarioAlimentacao/get/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> jsonDataList =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        if (jsonDataList.isNotEmpty) {
          final idPlanoAlimentacao = jsonDataList.first['idPlanoAlimentacao'];
          return idPlanoAlimentacao;
        } else {
          // Retorna 0 se o idPlanoAlimentacao não estiver definido
          return 0;
        }
      } else {
        // Lida com outros códigos de status, se necessário
        print(
            'Erro ao obter idPlanoAlimentacao. Código de status: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      // Lida com erros de conexão
      print('Erro de conexão ao obter idPlanoAlimentacao: $e');
      return 0;
    }
  }

  Future<List<UserData>> getDadosUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/infouser/get/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> jsonDataList =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        final List<UserData> userDataList = jsonDataList.map((jsonMap) {
          return UserData(
            idUsuario: jsonMap['idUsuario'],
            usuario: '',
            email: '',
            genero: jsonMap['genero'],
            altura: jsonMap['alturaCM'].toDouble(),
            idade: jsonMap['idade'].toInt(),
            peso: jsonMap['pesoKg'].toDouble(),
            imc: 0.0,
            idPlanoTreino: 0,
            idPlanoAlimentacao: 0,
          );
        }).toList();

        return userDataList;
      } else {
        return []; // Retorna uma lista vazia em caso de erro
      }
    } catch (e) {
      print(e);
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/user/login'),
          body: jsonEncode({
            'emailUsuario': email,
            'senhaUsuario': password,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          final userId = userData['user']['id'];
          final username = userData['user']['username'];
          final userEmail = userData['user']['email'];

          final userDataList = await getDadosUser(userId);

          if (userDataList.isNotEmpty) {
            final userDataObject = userDataList.first;
            userDataObject.usuario = username;
            userDataObject.email = userEmail;
            final alturaMetros = userDataObject.altura / 100;
            userDataObject.imc =
                userDataObject.peso / (alturaMetros * alturaMetros);

            if (userDataObject.idPlanoTreino == 0 ||
                userDataObject.idPlanoAlimentacao == 0) {
              final idPlanoTreinoFromApi = await getIdPlanoTreino(userId);
              final idPlanoAlimentacaoFromApi = await getIdPlanoAlimentacao(userId);

              if (idPlanoTreinoFromApi != 0 || idPlanoAlimentacaoFromApi != 0) {
                print(idPlanoTreinoFromApi);
                print(idPlanoAlimentacaoFromApi);
                userDataObject.idPlanoTreino = idPlanoTreinoFromApi;
                userDataObject.idPlanoAlimentacao = idPlanoAlimentacaoFromApi;
                await SharedUser.saveUserData(userDataObject);
              }

              if (userDataObject.idPlanoTreino == 0 || userDataObject.idPlanoAlimentacao == 0) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoForm()),
                );
                return; // Navegação já realizada, encerra a função.
              }

              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaInicial()),
              );
              return; // Navegação já realizada, encerra a função.
            }
          } else {
            final userDataObjectNew = UserData(
              idUsuario: userId,
              usuario: username,
              email: userEmail,
              genero: '',
              altura: 0.0,
              idade: 0,
              peso: 0.0,
              imc: 0.0,
              idPlanoTreino: 0,
              idPlanoAlimentacao: 0,
            );
            await SharedUser.saveUserData(userDataObjectNew);
          }

          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PersonalInfoForm()),
          );
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: const Text(
                  'Login Falhou',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login inválido. Verifique suas credenciais e tente novamente.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } catch (e) {
        print('Ocorreu uma exceção: $e');
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
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text(
              'Credenciais Inválidas',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Não foi possível fazer login. Preencha todas as suas credenciais e tente novamente.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
          iconTheme: IconThemeData(
            color: AppTheme.iconColor,
          ),
          backgroundColor: AppTheme.appBarColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      // Validação de email aqui
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      // Validação de senha aqui
                    },
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        minimumSize: Size(double.infinity, 50.0),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        final email = _emailController.text;
                        final password = _passwordController.text;
                        login(email, password);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => TelaInicial()),
                        // );
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
                            horizontal: 143.0,
                          ),
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CadastroPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Centraliza horizontalmente
                            children: [
                              const Text(
                                "Não Possui Conta? ",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              const SizedBox(width: 1),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CadastroPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Cadastre-se',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
