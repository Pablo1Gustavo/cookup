import 'package:flutter/material.dart';
import 'package:front/models/receita.dart';
import 'package:front/services/auth_service.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/RecipeList.dart';
import 'package:provider/provider.dart';

class RecipeFinished extends StatefulWidget {
  final int totalTimeInSeconds;
  final Receita receita;

  const RecipeFinished({
    required this.totalTimeInSeconds,
    required this.receita,
    Key? key,
  }) : super(key: key);

  @override
  _RecipeFinishedState createState() => _RecipeFinishedState();
}

class _RecipeFinishedState extends State<RecipeFinished> {
  late String message = "";
  late int score = 0;

  @override
  void initState() {
    super.initState();

    int tempoPreparoEmSegundos = widget.receita.tempoPreparo * 60;

    if (widget.totalTimeInSeconds < tempoPreparoEmSegundos) {
      message = "Você é muito rápido!";
      score = (widget.receita.pontuacao * 1.1).round();
    } else if (widget.totalTimeInSeconds == tempoPreparoEmSegundos) {
      message = "Você terminou exatamente no tempo!";
      score = widget.receita.pontuacao; 
    } else {
      message = "Você demorou um pouco mais!";
      score = (widget.receita.pontuacao * 0.9).round();
    }
    context.read<AuthService>().adicionarPontosPorReceita(score);
  }



  void _publishRecipe() {
    // Implementar ação de publicar receita
  }

  void _jumpPublish() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int minutes = widget.totalTimeInSeconds ~/ 60;
    int seconds = widget.totalTimeInSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita.nome),
        backgroundColor: customBackgroundColor,
      ),
      backgroundColor: customBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message,
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Você conseguiu concluir esse prato em um tempo de',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$minutes',
                      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold ,color: Colors.orange),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'minutos',
                      style: TextStyle(fontSize: 24.0, color: Colors.orange),
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$seconds',
                      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold ,color: Colors.orange),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'segundos',
                      style: TextStyle(fontSize: 24.0, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Center(
              child: Image.asset(
                'assets/finished.gif', 
                width: 250.0,
                height: 250.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32.0),
            Center( 
              child: Text(
                '+$score XP',
                style: TextStyle(fontSize: 56.0, color: Colors.orange, fontWeight: FontWeight.bold),
              )
            ),
                
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onPublish: _publishRecipe,
        onJump: _jumpPublish,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final VoidCallback onPublish;
  final VoidCallback onJump;

  const CustomBottomNavigationBar({
    required this.onPublish,
    required this.onJump,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPublish,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: primaryColor,
              ),
              label: Text(
                'Quero Compartilhar minha conquista!',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onJump,
            child: Text(
              'Pular essa etapa',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
