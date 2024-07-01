import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final int curtidas;
  final String descricao;
  final String imageUrl;
  final DocumentReference<Map<String, dynamic>>? receitaRef;
  final DocumentReference<Map<String, dynamic>>? usuarioRef;

  Post({
    required this.curtidas,
    required this.descricao,
    this.imageUrl = "",
    required this.receitaRef,
    required this.usuarioRef,
  }) : assert(receitaRef == null || imageUrl.isNotEmpty,
              'Image URL is required when receitaRef is provided.');

  Map<String, dynamic> toMap() {
    return {
      'curtidas': curtidas,
      'descricao': descricao,
      'image_url': imageUrl,
      'receita_ref': receitaRef != null ? receitaRef! : null,
      'usuario_ref': usuarioRef != null ? usuarioRef! : null,
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
    );
  }
}
