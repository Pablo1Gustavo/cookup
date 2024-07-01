import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Receita {
  final String nome;
  final String imagemUrl;
  final int pontuacao;
  final int tempoPreparo;
  final List<String> listaIngredientes;
  final List<String> ordemPreparo;
  final DocumentReference<Map<String, dynamic>>? usuarioRef;

  Receita({
    required this.nome,
    required this.imagemUrl,
    required this.pontuacao,
    required this.tempoPreparo,
    required this.listaIngredientes,
    required this.ordemPreparo,
    required this.usuarioRef,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'image_url': imagemUrl,
      'pontuacao': pontuacao,
      'minutos_preparo': tempoPreparo,
      'ingredientes': listaIngredientes,
      'preparo': ordemPreparo,
      'usuario_ref': usuarioRef != null ? usuarioRef! : null,
    };
  }

  factory Receita.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Receita(
      nome: data['nome'],
      imagemUrl: data['image_url'],
      pontuacao: data['pontuacao'],
      tempoPreparo: data['minutos_preparo'],
      listaIngredientes: List<String>.from(data['ingredientes']),
      ordemPreparo: List<String>.from(data['preparo']),
      usuarioRef: data['usuario_ref']
    );
  }
}
