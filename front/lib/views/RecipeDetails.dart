import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/components/CountDownCircle.dart';
import 'package:front/models/receita.dart';
import 'package:front/utils/constants.dart';
import 'dart:async';

import 'package:front/views/RecipeFinished.dart';

class RecipeDetails extends StatefulWidget {
  final Receita receita;

  const RecipeDetails({required this.receita, Key? key}) : super(key: key);

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  bool _started = false;
  Timer _timer = Timer(Duration.zero, () {});  late int _secondsRemaining;
  late int _totalTimeInMinutes; 
  int _timeSpentInSeconds = 0;

  @override
  void initState() {
    super.initState();
    _totalTimeInMinutes = widget.receita.tempoPreparo;
    _secondsRemaining = _totalTimeInMinutes * 60;
  }

  void _startRecipe() {
    setState(() {
      _started = true;
    });

    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (mounted) {
        setState(() {
          _secondsRemaining--;
        });

        if (_secondsRemaining <= 0) {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _finishRecipe() async {
    setState(() {
      _started = false;
      _timeSpentInSeconds = _totalTimeInMinutes * 60 - _secondsRemaining;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshots = await FirebaseFirestore.instance
          .collection('receitas_salvas')
          .where('receita_ref', isEqualTo: FirebaseFirestore.instance.doc('/receitas/${widget.receita.uid}'))
          .where('usuario_ref', isEqualTo: FirebaseFirestore.instance.doc('/usuarios/${user.uid}'))
          .get();

      if (snapshots.docs.isNotEmpty) {
        var docId = snapshots.docs.first.id;
        await FirebaseFirestore.instance.collection('receitas_salvas').doc(docId).update({
          'tempo_preparo': _timeSpentInSeconds,
          'data_realizacao': Timestamp.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection('receitas_salvas').add({
          'receita_ref': FirebaseFirestore.instance.doc('/receitas/${widget.receita.uid}'),
          'usuario_ref': FirebaseFirestore.instance.doc('/usuarios/${user.uid}'),
          'tempo_preparo': _timeSpentInSeconds,
          'data_realizacao': Timestamp.now(),
        });
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeFinished(
          receita: widget.receita,
          totalTimeInSeconds: _timeSpentInSeconds,
        ),
      ),
    );
    print('Time spent preparing recipe: $_timeSpentInSeconds seconds');
  }

  @override
  void dispose() {
    _timer.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receita.nome),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _started
                ? CircularCountDown(
                    totalMinutes: _totalTimeInMinutes,
                  )
                : CardImage(
                    imageUrl: widget.receita.imagemUrl,
                    pontuacao: widget.receita.pontuacao,
                    tempoPreparo: widget.receita.tempoPreparo,
                  ),
            const SizedBox(height: 32.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/recipe_list.svg',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.cover,
                  color: black500,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Ingredientes',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: black500),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...widget.receita.listaIngredientes
                .map((ingrediente) => Column(
                      children: [
                        Text(
                          '• $ingrediente',
                          style: const TextStyle(
                              fontSize: 16.0, color: black400),
                        ),
                        const SizedBox(height: 4.0),
                      ],
                    ))
                .toList(),
            const SizedBox(height: 32.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/pot.svg',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.cover,
                  color: black500,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Modo de Preparo',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: black500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...widget.receita.ordemPreparo
                .asMap()
                .entries
                .map((entry) => Column(
                      children: [
                        Text(
                          '${entry.key + 1}. ${entry.value}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: black400,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        started: _started,
        onStart: _startRecipe,
        onFinish: _finishRecipe,
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  final String imageUrl;
  final int pontuacao;
  final int tempoPreparo;

  const CardImage({
    required this.imageUrl,
    required this.pontuacao,
    required this.tempoPreparo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
                width: double.infinity,
                height: 200,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '+ ${pontuacao} XP',
                            style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${tempoPreparo} minutos de preparo',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ))),
          ],
        ));
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final bool started;
  final VoidCallback onStart;
  final VoidCallback onFinish;

  const CustomBottomNavigationBar({
    required this.started,
    required this.onStart,
    required this.onFinish,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton.icon(
        onPressed: started ? onFinish : onStart,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: primaryColor,
        ),
        icon: Icon(
          started ? Icons.check : Icons.play_arrow,
          color: Colors.white,
        ),
        label: Text(
          started ? 'Finalizar Receita' : 'Iniciar Receita',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
