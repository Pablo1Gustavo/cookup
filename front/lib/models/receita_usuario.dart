import 'package:front/models/receita.dart';
import 'package:front/models/usuario.dart';

class ReceitaUsuario {
  final int receitaId;
  final int usuarioId;
  final bool receitaRealizada;
  final String dataRealizacao;
  final int tempoRealizacao;

  ReceitaUsuario({
    required this.receitaId,
    required this.usuarioId,
    this.receitaRealizada = false, 
    this.dataRealizacao = '',     
    this.tempoRealizacao = 0,    
  });
}