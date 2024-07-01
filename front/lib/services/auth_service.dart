import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front/views/HomePage.dart';
import 'package:front/views/Login.dart';
import 'package:provider/provider.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? usuario;
  bool isLoading = true;
  String? username;
  int? pontos;
  String? descricaoPerfil;
  String? fotoPerfil;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = user;
      if (user != null) {
        _loadUserData();
      } else {
        _clearUserData();
      }
      isLoading = false;
      notifyListeners();
    });
  }

    void _clearUserData() {
    usuario = null;
    username = null;
    pontos = null;
    descricaoPerfil = null;
    fotoPerfil = null;
  }

  _getUser() {
    usuario = _auth.currentUser;
    if (usuario != null) {
      _loadUserData();
    } else {
      username = null;
      pontos = null;
      descricaoPerfil = null;
      fotoPerfil = null;
    }
    notifyListeners();
  }

Future<void> _loadUserData() async {
    if (usuario != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(usuario!.uid).get();
        if (userDoc.exists) {
          username = userDoc['username'];
          pontos = userDoc['pontos'];
          descricaoPerfil = userDoc['descricaoPerfil'];
          fotoPerfil = userDoc['fotoPerfil'];
        } else {
          _clearUserData();
        }
      } catch (e) {
        print("Erro ao carregar dados do usuário: $e");
        _clearUserData();
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData(String uid, {String? username, int? pontos, String? descricaoPerfil, String? fotoPerfil}) async {
    Map<String, dynamic> data = {};
    if (username != null) data['username'] = username;
    if (pontos != null) data['pontos'] = pontos;
    if (descricaoPerfil != null) data['descricaoPerfil'] = descricaoPerfil;
    if (fotoPerfil != null) data['fotoPerfil'] = fotoPerfil;

    await _firestore.collection('usuarios').doc(uid).set(data, SetOptions(merge: true));
    if (username != null) this.username = username;
    if (pontos != null) this.pontos = pontos;
    if (descricaoPerfil != null) this.descricaoPerfil = descricaoPerfil;
    if (fotoPerfil != null) this.fotoPerfil = fotoPerfil;
    notifyListeners();
  }


  registrar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('Senha fraca');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Email já cadastrado');
      }
    }
  }


  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        throw AuthException('Email não encontrado. Cadastre-se');
      } else if(e.code == 'wrong-password'){
        throw AuthException('Senha incorreta. tente novamente');
      }
    }
  }

Future<void> logout() async {
  await _auth.signOut();
}


  Future<void> adicionarPontosPorReceita(int pontosRecebidos) async {
    if (usuario != null) {
      int novosPontos = (pontos ?? 0) + pontosRecebidos;
      await updateUserData(usuario!.uid, pontos: novosPontos);
    }
  }
}


class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return Login();
    } else {
      return HomePage();
    }
  }

  Widget loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}