import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String? uid;
  final String username;
  final int pontos;
  final String descricaoPerfil;
  final String fotoPerfil;

  Usuario({
    this.uid,
    required this.username,
    required this.pontos,
    required this.descricaoPerfil,
    required this.fotoPerfil,
  });

  factory Usuario.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Usuario(
      uid: doc.id,
      descricaoPerfil: data['descricaoPerfil'],
      fotoPerfil: data['fotoPerfil'],
      username: data['username'],
      pontos: data['pontos'],
    );
  }
}
