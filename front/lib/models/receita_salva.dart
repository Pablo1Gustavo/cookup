import 'package:cloud_firestore/cloud_firestore.dart';

class ReceitaSalva {
  final DocumentReference<Map<String, dynamic>>? receitaRef;
  final DocumentReference<Map<String, dynamic>>? usuarioRef;
  final Timestamp? dataRealizacao;
  final int tempoPreparo;

  ReceitaSalva({
    required this.receitaRef,
    required this.usuarioRef,
    this.dataRealizacao,     
    this.tempoPreparo = 0,    
  });

  Map<String, dynamic> toMap() {
    return {
      'data_realizacao': dataRealizacao,
      'receita_ref': receitaRef != null ? receitaRef! : null,
      'usuario_ref': usuarioRef != null ? usuarioRef! : null,
      'tempo_preparo': tempoPreparo,
    };
  }

  factory ReceitaSalva.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ReceitaSalva(
      dataRealizacao: data['nome'],
      receitaRef: data['receita_ref'],
      usuarioRef: data['usuario_ref'],
      tempoPreparo: data['tempo_preparo']
    );
  }
}