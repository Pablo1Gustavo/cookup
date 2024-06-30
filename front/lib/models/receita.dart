class Receita {
  final String nome;
  final String imagemUrl;
  final int pontuacao;
  final int tempoPreparo;
  final List<String> listaIngredientes;
  final List<String> ordemPreparo;
  final String usuarioCriadorId;

  Receita({
    required this.nome,
    required this.imagemUrl,
    required this.pontuacao,
    required this.tempoPreparo,
    required this.listaIngredientes,
    required this.ordemPreparo,
    required this.usuarioCriadorId,
  });
}