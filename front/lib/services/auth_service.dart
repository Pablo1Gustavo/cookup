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
  int? pontos;
  String? descricaoPerfil;
  String? fotoPerfil;
  List<DateTime>? checkInDates;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      if (user != null) {
        _loadUserData();
      }
      isLoading = false;
      notifyListeners();
    });
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
      checkInDates = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (usuario != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('usuarios').doc(usuario!.uid).get();
        print("Documento do usuário: ${userDoc.data()}");
        if (userDoc.exists) {
          username = userDoc['username'];
          pontos = userDoc['pontos'];
          descricaoPerfil = userDoc['descricaoPerfil'];
          fotoPerfil = userDoc['fotoPerfil'];
          checkInDates = (userDoc['checkInDates'] as List<dynamic>?)
              ?.map((timestamp) => (timestamp as Timestamp).toDate())
              .toList();
          print("Dados do usuário carregados: $username, $pontos, $descricaoPerfil, $fotoPerfil");
        } else {
          print("Documento do usuário não encontrado");
          username = null;
          pontos = null;
          descricaoPerfil = null;
          fotoPerfil = null;
          checkInDates = null;
        }
      } catch (e) {
        print("Erro ao carregar dados do usuário: $e");
        username = null;
        pontos = null;
        descricaoPerfil = null;
        fotoPerfil = null;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData(String uid, {String? username, int? pontos, String? descricaoPerfil, String? fotoPerfil, List<DateTime>? checkInDates}) async {
    Map<String, dynamic> data = {};
    if (username != null) data['username'] = username;
    if (pontos != null) data['pontos'] = pontos;
    if (descricaoPerfil != null) data['descricaoPerfil'] = descricaoPerfil;
    if (fotoPerfil != null) data['fotoPerfil'] = fotoPerfil;
    if (checkInDates != null) data['checkInDates'] = checkInDates;

    await _firestore.collection('usuarios').doc(uid).set(data, SetOptions(merge: true));
    if (username != null) this.username = username;
    if (pontos != null) this.pontos = pontos;
    if (descricaoPerfil != null) this.descricaoPerfil = descricaoPerfil;
    if (fotoPerfil != null) this.fotoPerfil = fotoPerfil;
    if (checkInDates != null) this.checkInDates = checkInDates;
    notifyListeners();
  }

  Future<void> registrarCheckInDiario() async {
    if (usuario != null) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      if (checkInDates == null) {
        checkInDates = [];
      }

      bool alreadyCheckedInToday = checkInDates!.any((date) => date.isAtSameMomentAs(today));

      if (!alreadyCheckedInToday) {
        int newPontos = (pontos ?? 0) + 2; // Adiciona 2 pontos por check-in diário
        checkInDates!.add(today);
        await updateUserData(usuario!.uid, pontos: newPontos, checkInDates: checkInDates);
      }
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
    pontos = null;
    descricaoPerfil = null;
    fotoPerfil = null;
    checkInDates = null;
    _getUser();
  }

  Future<void> adicionarPontosPorReceita(int pontosRecebidos) async {
    if (usuario != null) {
      int novosPontos = (pontos ?? 0) + pontosRecebidos;
      await updateUserData(usuario!.uid, pontos: novosPontos);
    }
  }
}
