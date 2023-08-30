import 'package:flutter/material.dart';
import 'package:flutter_login/service/usuario.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PersonalInfoForm extends StatefulWidget {
  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = 'Masculino';


  // Função para fazer a solicitação à API externa
  Future<void> _updateUserData() async {
    final age = _ageController.text;
    final weight = _weightController.text;
    final height = _heightController.text;
    final gender = _gender;

    final apiUrl = 'https://localhost:3000/infouser/atualizar/:idUsuario';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'idade': age,
          'peso': weight,
          'altura': height,
          'genero': gender,
        },
      );

      // Verifique a resposta da API e lide com ela conforme necessário.
      if (response.statusCode == 200) {
        // Dados atualizados com sucesso.
        print('Dados atualizados com sucesso!');
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
                _buildTextField("Idade", _ageController),
                const SizedBox(height: 12.0),
                _buildTextField("Peso (kg)", _weightController),
                const SizedBox(height: 12.0),
                _buildTextField("Altura (cm)", _heightController),
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
        gradient: LinearGradient(
          colors: [Colors.cyan, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          final usuario = Provider.of<Usuario>(context, listen: false);
          print(usuario.email); // Acessa o atributo email do usuário
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: const Text(
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
        gradient: LinearGradient(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: const Text(
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
