import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class UserData {
  int idUsuario;
  String usuario;
  String email;
  String genero;
  double altura;
  double peso;
  double imc;
  int idade;
  int idPlanoTreino;
  int idPlanoAlimentacao;

  UserData( {
    required this.idUsuario,
    required this.usuario,
    required this.email,
    required this.genero,
    required this.altura,
    required this.idade,
    required this.peso,
    required this.imc,
    required this.idPlanoTreino,
    required this.idPlanoAlimentacao,
  });
  

factory UserData.fromJson(Map<String, dynamic> json) {
  return UserData(
    idUsuario: json['idUsuario'] as int,
    usuario: json['usuario'] as String,
    email: json['email'] as String,
    genero: json['genero'] as String,
    altura: (json['altura'] as num).toDouble(),
    idade: (json['idade'] as num).toInt(),
    peso: (json['peso'] as num).toDouble(),
    imc: (json['imc'] as num).toDouble(),
    idPlanoTreino: json['idPlanoTreino'] as int,
    idPlanoAlimentacao: json['idPlanoAlimentacao'] as int,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'usuario': usuario,
      'email': email,
      'genero': genero,
      'altura': altura,
      'idade': idade,
      'peso': peso,
      'imc': imc,
      'idPlanoTreino': idPlanoTreino,
      'idPlanoAlimentacao': idPlanoAlimentacao,
    };
  }
}

class SharedUser {
  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<UserData?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      return UserData.fromJson(Map<String, dynamic>.from(json.decode(userDataJson)));
    }
    return null;
  }

  static Future<void> saveUserData(UserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', json.encode(userData.toJson()));
  }

  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  static Future<bool> isLoggedIn() async {
    final userData = await getUserData();
    return userData != null;
  }
}
