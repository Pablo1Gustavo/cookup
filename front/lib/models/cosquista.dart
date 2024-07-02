class Conquista
{
  final String uid;
  final String descricao;
  final int pontuacao;

  Conquista({
    required this.uid,
    required this.descricao,
    required this.pontuacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'pontuacao': pontuacao,
    };
  }
}