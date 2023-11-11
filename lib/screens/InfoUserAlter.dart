import 'package:flutter/material.dart';
import 'package:flutter_login/screens/telainicial.dart';
import 'package:flutter_login/service/sharedUser.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;

class PersonalInfoAlterForm extends StatefulWidget {
  @override
  _PersonalInfoAlterFormState createState() => _PersonalInfoAlterFormState();
}

class _PersonalInfoAlterFormState extends State<PersonalInfoAlterForm> {
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
    } else {
      genero = "F";
    }

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

      double pesoValue = double.parse(weight);
      double alturaValue = double.parse(height) / 100.0; // Convert altura to meter

       final imc = alturaValue != 0 ? pesoValue / (alturaValue * alturaValue) : 0.0;

      userData?.imc = imc;

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
                title: const Text('Dados Foram Atualizados'),
                content: const Text(
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
