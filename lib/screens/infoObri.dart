import 'package:flutter/material.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/service/sharedUser.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;


class PersonalInfoForm extends StatefulWidget {
  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String idUsuario = "";
  String _gender = 'Masculino';
  String _userName  = "";
  String _userEmail  = "";
  double _imc = 0.0;
  double _altura = 0.0;
  double _peso = 0.0;
  int _idade = 0;

    Future<void> _loadUserData() async {
    final userData = await SharedUser.getUserData();
    if (userData != null) {
      setState(() {
        _userName = userData.usuario;
        _userEmail = userData.email;
        _imc = userData.imc;
        _altura = userData.altura;
        _idade = userData.idade;
        _peso = userData.peso;
        if(userData.genero == 'M') {
          _gender = 'Masculino';
        } else {
          _gender = 'Feminino';
        }
      });
    }
  }


  Future<void> _createUserData({
    required String idUsuario,
    required String peso,
    required String idade,
    required String genero,
    required String altura,
  }) async {
    final url = Uri.parse('http://localhost:3000/infouser/cadastro');

      final dadosUser = await SharedUser.getUserData();

    if (genero == "Masculino") {
      genero = "M";
    } else {
      genero = "F";
    }

    final novoInfoUser = {
      'idUsuario': idUsuario,
      'peso': peso.toString(),
      'idade': idade.toString(),
      'genero': genero,
      'altura': altura.toString()
    };

    if(dadosUser!.imc == 0.0)
    {
      try {
      final response = await http.post(
        url,
        body: novoInfoUser,
      );

      double peso = 0.0;
      double altura = 0.0;

        peso = double.parse(dadosUser!.peso.toString());
        altura = dadosUser!.altura / 100.0; // Converter altura para metros

      UserData userData = UserData(
        idUsuario: dadosUser!.idUsuario, 
        usuario: dadosUser.usuario,
        email: dadosUser.email, 
        genero: genero, 
        altura: altura, 
        idade: int.parse(idade),
        peso: peso, 
        imc: peso / (altura * altura),
        idPlanoTreino: 0,
        idPlanoAlimentacao: 0);

      await SharedUser.saveUserData(userData);

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
               shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0)),
                  titleTextStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue), 
                title: const Text('Cadastro foi incluído'),
                content: const Text(
                    'Cadastro de informações foi realizado com sucesso!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
      } else {
        print('Erro ao cadastrar usuário. Código de resposta: ${response.statusCode}');
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
               shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0)),
                  titleTextStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red), 
                title: const Text('Erro ao Cadastrar'),
                content: const Text(
                    'Ocorre um Erro ao cadastrar usuário.!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
      }
    } catch (error) {
      // Erro de Conexão
      print('Erro: $error');
    }
    }
    else
    {
       // ignore: use_build_context_synchronously
       showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
               shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0)),
                  titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue), 
                title: const Text('Erro ao Cadastrar'),
                content: const Text(
                    'Você já possui Informações Cadastradas!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
    }
    
  }

  Future<void> _updateUserData() async {
    final age = _ageController.text;
    final weight = _weightController.text;
    final height = _heightController.text;
    final gender = _gender;
    String genero = " ";
    final userData = await SharedUser.getUserData();
    if (userData != null) {
      idUsuario = userData.idUsuario.toString();
    }

    final apiUrl = 'http://localhost:3000/infouser/atualizar/$idUsuario';

    if (gender == "Masculino") {
      genero = "M";
    } else
      genero = "F";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        body: {
          'peso': weight.toString(),
          'idade': age.toString(),
          'genero': genero,
          'altura': height.toString()
        },
      );

      final userData = await SharedUser.getUserData();
      userData?.peso = double.parse(weight);
      userData?.idade = int.parse(age);
      userData?.genero = genero;
      userData?.altura = double.parse(height);

      await SharedUser.saveUserData(userData!);

      // Verifique a resposta da API e lide com ela conforme necessário.
      if (response.statusCode == 201) {
        // Dados atualizados com sucesso.
        print('Dados atualizados com sucesso!');

        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
               shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0)),
                  titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue), 
                title: Text('Dados Foram Atualizados'),
                content: Text(
                    'Dados atualizados com sucesso!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),),
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
      } else {
        // Algo deu errado na solicitação.
        print('Erro ao atualizar dados: ${response.statusCode}');
      }
    } catch (error) {
      // Erro de conexão ou outro erro.
      print('Erro: $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => TelaInicial(),
                ),
              ); 
            },
          ),
          title: Text(
            "Informações Pessoais",
            style: TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme
                  .iconColor, //Deixa a cor do texto dinâmica de acordo com o tema selecionando
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextField("Idade: ${_idade}", _ageController),
                const SizedBox(height: 12.0),
                _buildTextField("Peso (kg): ${_peso}", _weightController),
                const SizedBox(height: 12.0),
                _buildTextField("Altura (cm): ${_altura}", _heightController),
                const SizedBox(height: 12.0),
                _buildGenderDropdown(),
                const SizedBox(height: 24.0),
                _buildSubmitButton(),
                const SizedBox(height: 24.0),
                _buildAlterButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, insira $label.';
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField(
      value: _gender,
      items: ['Masculino', 'Feminino']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Gênero',
        border: OutlineInputBorder(),
      ),
      onChanged: (String? newValue) {
        setState(() {
          _gender = newValue!;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50.0, // Defina a altura desejada aqui
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const LinearGradient(
          colors: [Colors.cyan, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final userData = await SharedUser.getUserData();
            if (userData != null) {
              idUsuario = userData.idUsuario.toString();
            }

            final age = int.tryParse(_ageController.text) ?? 0;
            final weight = double.tryParse(_weightController.text) ?? 0.0;
            final height = double.tryParse(_heightController.text) ?? 0.0;

            _createUserData(
              idUsuario: idUsuario,
              peso: _weightController.text,
              idade: _ageController.text,
              genero: _gender,
              altura: _heightController.text,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Text(
            'Pronto',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlterButton() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: const LinearGradient(
          colors: [Colors.cyan, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _updateUserData(); // Chame a função para atualizar os dados
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Text(
            'Alterar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
