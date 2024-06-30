import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      if (user != null) {
        _loadUsername();
      }
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    if (usuario != null) {
      _loadUsername();
    }
    notifyListeners();
  }
  Future<void> _loadUsername() async {
    if (usuario != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(usuario!.uid).get();
        print("Documento do usuário: ${userDoc.data()}");
        if (userDoc.exists && userDoc.data() != null) {
          username = userDoc['username'];
          print("Nome de usuário carregado: $username");
        } else {
          print("Documento do usuário não encontrado");
          username = null;
        }
      } catch (e) {
        print("Erro ao carregar nome de usuário: $e");
        username = null;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUsername(String uid, String newUsername) async {
    try {
      await _firestore.collection('usuarios').doc(uid).set({
        'username': newUsername,
      }, SetOptions(merge: true));
      username = newUsername;
      notifyListeners();
    } catch (e) {
      print("Erro ao atualizar nome de usuário: $e");
    }
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
    username = null;
    _getUser();
  }
}
