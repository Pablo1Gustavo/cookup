import 'package:flutter/material.dart';
import 'package:front/components/SaveUnsaveRecipeButton.dart';
import 'package:front/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  PostCard({
    required this.post,
  });
  

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.transparent,
      elevation: 0, 
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2014/03/25/16/54/user-297566_640.png'),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'username',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('date • time'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.network(
                    post.imageUrl,
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
                          end: Alignment.topCenter
                        ),
                      ),
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 18.0, top: 18.0, left: 24.0, right: 0),
                          child: Text(
                            'title',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SaveUnsaveRecipeButton(
                          borderRadius: BorderRadius.only( topLeft: Radius.circular(50.0), ),
                          padding: EdgeInsets.only( top: 12.0, bottom: 8.0, left: 18.0, right: 8.0),  
                          receitaUID: post.receitaRef?.id ?? "",
                        ),
                      ],
                    ),
                  )
                ),
                ],
              ),
            ),   
            SizedBox(height: 10.0),
            Text(
              post.descricao,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}