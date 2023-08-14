import 'package:flutter/material.dart';
import 'package:flutter_login/settings/theme.dart';

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
              color: AppTheme.iconColor, //Deixa a cor do texto dinâmica de acordo com o tema selecionando
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
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Fazer alguma coisa com os dados do formulário
        }
      },
      style: ElevatedButton.styleFrom(
         backgroundColor: const Color(0xFF78F259),
         minimumSize: const Size(30, 55),
         padding: const EdgeInsets.symmetric(horizontal: 12),
         shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(16.0),
         ),
      ),
      child: const Text('Pronto', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
    );
  }
}
