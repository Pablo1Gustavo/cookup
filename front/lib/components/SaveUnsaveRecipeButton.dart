import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/models/receita_salva.dart';
import 'package:front/utils/constants.dart';

class SaveUnsaveRecipeButton extends StatefulWidget {
  final BorderRadius borderRadius;
  final String receitaUID;  
  final EdgeInsets padding; 

  SaveUnsaveRecipeButton({
    required this.borderRadius,
    required this.receitaUID,
    required this.padding,
  });

  @override
  _SaveUnsaveRecipeButtonState createState() => _SaveUnsaveRecipeButtonState();
}

class _SaveUnsaveRecipeButtonState extends State<SaveUnsaveRecipeButton> {
  bool isSaved = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSaved ? primaryColor100 : primaryColor,
        borderRadius: widget.borderRadius,
      ),
      child: Padding(
        padding: widget.padding,
        child: IconButton(
          icon: SvgPicture.asset(
            isSaved ? 'assets/book_check.svg' : 'assets/book_plus.svg',
            width: 30.0,
            height: 30.0,
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          onPressed: () async {
            setState(() {
              isSaved = !isSaved;
            });
            if (isSaved) {
              await saveRecipe();
            } else {
              await unsaveRecipe();
            }
          },
        ),
      ),
    );
  }

  Future<void> saveRecipe() async {
    User? user = _auth.currentUser;
    if (user != null) {
      ReceitaSalva receitaSalva = ReceitaSalva(
        receitaRef: FirebaseFirestore.instance.doc('/receitas/${widget.receitaUID}'),
        usuarioRef: FirebaseFirestore.instance.doc('/usuarios/${user.uid}'),
      );

      await FirebaseFirestore.instance
          .collection('receitas_salvas')
          .add(receitaSalva.toMap());
    }
  }

  Future<void> unsaveRecipe() async {
  User? user = _auth.currentUser;
  if (user != null) {
    var snapshots = await FirebaseFirestore.instance
        .collection('receitas_salvas')
        .where('receita_ref', isEqualTo: FirebaseFirestore.instance.doc('/receitas/${widget.receitaUID}'))
        .where('usuario_ref', isEqualTo: FirebaseFirestore.instance.doc('/usuarios/${user.uid}'))
        .get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}
}
