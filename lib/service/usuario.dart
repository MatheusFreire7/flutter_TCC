import 'package:flutter/foundation.dart';

class Usuario with ChangeNotifier {
   int idUsuario = 0;
   String email = "";
   String usuario = "";
   String genero = "";
   int idade = 0;
   double peso = 0.0;
   double altura = 0.0;
   double imc = 0.0;
   int idPlanoTreino = 0;
   int idPlanoAlimentacao = 0;

  // Construtor com todas as informações do usuário
  Usuario.fullUserInfo(
      int idUsuarioNovo,
      String usuarioNovo,
      String emailNovo,
      String generoNovo,
      int idadeNovo,
      double pesoNovo,
      double alturaNovo,
      double imcNovo,
      int idPlanoTreinoNovo,
      int idPlanoAlimentacaoNovo) {
    if (idUsuarioNovo < 0) throw ArgumentError("ID de usuário não pode ser negativo");
    if (usuarioNovo.isEmpty) throw ArgumentError("Nome de usuário não pode estar vazio");
    if (emailNovo.isEmpty) throw ArgumentError("Email não pode estar vazio");

    this.idUsuario = idUsuarioNovo;
    this.usuario = usuarioNovo;
    this.email = emailNovo;
    this.genero = generoNovo;
    this.idade = idadeNovo;
    this.peso = pesoNovo;
    this.altura = alturaNovo;
    this.idPlanoTreino = idPlanoTreinoNovo;
    this.idPlanoAlimentacao = idPlanoAlimentacaoNovo;
    this.imc = imcNovo;
  }

  // Construtor de cadastro inicial
  Usuario(int idUsuarioNovo, String emailNovo, String usuarioNovo) {
    if (idUsuarioNovo < 0) throw ArgumentError("ID de usuário não pode ser negativo");
    if (usuarioNovo.isEmpty) throw ArgumentError("Nome de usuário não pode estar vazio");
    if (emailNovo.isEmpty) throw ArgumentError("Email não pode estar vazio");

    this.idUsuario = idUsuarioNovo;
    this.email = emailNovo;
    this.usuario = usuarioNovo;
  }

  // Getters and Setters

  int getIdUsuario() {
    return idUsuario;
  }

  void setIdUsuario(int idUsuario) {
    if (idUsuario < 0) throw ArgumentError("ID de usuário não pode ser negativo");
    this.idUsuario = idUsuario;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    if (email.isEmpty) throw ArgumentError("Email não pode estar vazio");
    this.email = email;
  }

  String getUsuario() {
    return usuario;
  }

  void setUsuario(String usuario) {
    if (usuario.isEmpty) throw ArgumentError("Nome de usuário não pode estar vazio");
    this.usuario = usuario;
  }

  double getImc() {
    return imc;
  }

  void setImc(double imc) {
    this.imc = imc;
  }

  int getPlanoTreino() {
    return idPlanoTreino;
  }

  void setIdPlanoTreino(int idPlanoTreino) {
    this.idPlanoTreino = idPlanoTreino;
  }

  int getPlanoAlimentacao() {
    return idPlanoAlimentacao;
  }

  void setIdPlanoAlimentacao(int idPlanoAlimentacao) {
    this.idPlanoAlimentacao = idPlanoAlimentacao;
  }

  Usuario.vazio(){}

  void login(String userName, String email) {
    usuario = userName;
    email = email;
    notifyListeners();
  }

  void logout() {
    usuario = "";
    email = "";
    notifyListeners();
  }
}
