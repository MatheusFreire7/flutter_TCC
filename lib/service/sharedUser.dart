import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class UserData {
  final int idUsuario;
  final String usuario;
  final String email;
  final String genero;
  final double altura;
  final double peso;
  final double imc;
  final int idPlanoTreino;
  final int idPlanoAlimentacao;

  UserData({
    required this.idUsuario,
    required this.usuario,
    required this.email,
    required this.genero,
    required this.altura,
    required this.peso,
    required this.imc,
    required this.idPlanoTreino,
    required this.idPlanoAlimentacao,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      idUsuario: json['idUsuario'] ?? 0,
      usuario: json['usuario'] ?? '',
      email: json['email'] ?? '',
      genero: json['genero'] ?? '',
      altura: json['altura'] ?? 0.0,
      peso: json['peso'] ?? 0.0,
      imc: json['imc'] ?? 0.0,
      idPlanoTreino: json['idPlanoTreino'] ?? 0,
      idPlanoAlimentacao: json['idPlanoAlimentacao'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'usuario': usuario,
      'email': email,
      'genero': genero,
      'altura': altura,
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
