import 'package:flutter/material.dart';
import 'package:front/utils/constants.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String date;
  final String time;
  final String imageUrl;
  final String title;
  final String description;

  PostCard({
    required this.username,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.title,
    required this.description,
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
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2014/03/25/16/54/user-297566_640.png'),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$date • $time'),
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
                    imageUrl,
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Row (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 24.0),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          CustomIconButton(
                            onPressed: () => {

                            },
                          ),
                        ]
                          
                      )
                    ),
                  ),
                ],
              ),
            ),   
            SizedBox(height: 10.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomIconButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
        child: IconButton(
          icon: Icon(Icons.bookmark_add_outlined, size: 30.0),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}