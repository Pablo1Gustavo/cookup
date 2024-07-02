import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final int curtidas;
  final String descricao;
  final String imageUrl;
  final DocumentReference<Map<String, dynamic>>? receitaRef;
  final DocumentReference<Map<String, dynamic>>? usuarioRef;
  final Timestamp dataPostagem;

  Post({
    required this.curtidas,
    required this.descricao,
    this.imageUrl = "",
    this.receitaRef,
    required this.usuarioRef,
    required this.dataPostagem,
  });

  Map<String, dynamic> toMap() {
    return {
      'curtidas': curtidas,
      'descricao': descricao,
      'image_url': imageUrl,
      'receita_ref': receitaRef,
      'usuario_ref': usuarioRef,
      'data_postagem': dataPostagem,
    };
  }

  factory Post.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Post(
      curtidas: data['curtidas'],
      descricao: data['descricao'],
      imageUrl: data['image_url'] ?? "",
      receitaRef: data['receita_ref'],
      usuarioRef: data['usuario_ref'],
      dataPostagem: data['data_postagem'],
    );
  }
}