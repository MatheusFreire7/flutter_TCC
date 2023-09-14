import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/cadastro.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;
import '../service/sharedUser.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
         final alturaMetros = userDataObject.altura / 100; // Converter altura para metros
         userDataObject.imc = userDataObject.peso / (alturaMetros * alturaMetros); 
          await SharedUser.saveUserData(userDataObject);
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

        
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaInicial()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
               shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0)),
                  titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue), 
                title: Text('Login Falhou'),
                content: Text(
                    'Login inválido. Verifique suas credenciais e tente novamente.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Ocorreu uma exceção: $e');
      }
    } else {
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0)),
            child: Container(
              height: 200,
              width: 300,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                      "Preencha todas as credenciais e tente novamente!",
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color:Colors.blue
                        ),
                      )                    
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
                    decoration: InputDecoration(
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
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
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
                            gradient: LinearGradient(
                              colors: [Colors.cyan, Colors.blue],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: const Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 143.0,
                            ),
                            child:const  Text(
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
          ),
        ),
      ),
    );
  }
}