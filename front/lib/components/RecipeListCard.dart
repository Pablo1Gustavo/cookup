import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front/components/SaveUnsaveRecipeButton.dart';
import 'package:front/models/receita.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/RecipeDetails.dart';

class RecipeListCard extends StatelessWidget {
  final Receita receita;
  final Timestamp? dataRealizacao;

  const RecipeListCard({  required this.receita , this.dataRealizacao   });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(receita: receita),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.network(
                receita.imagemUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (dataRealizacao != null)
                            Container(
                              constraints: BoxConstraints(maxWidth: 85.0),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:  Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check, color: white, size: 18.0), 
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Feito',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                              ),
                            ),
                          )
                        else
                          Text(
                            '+ ${receita.pontuacao} XP',
                            style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        SizedBox(height: 8.0),
                        Text(
                          receita.nome,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child:  SaveUnsaveRecipeButton(
                  borderRadius: BorderRadius.only( bottomLeft: Radius.circular(50.0), ),
                  padding: EdgeInsets.only(top: 4.0, bottom: 12.0, left: 16.0, right: 8.0),
                  receitaUID: receita.uid ?? "",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}