import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                            title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () => {

                          },
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
        padding: EdgeInsets.only( top: 12.0, bottom: 8.0, left: 18.0, right: 8.0),        
        child: IconButton(
            icon: SvgPicture.asset(
              'assets/book_plus.svg',
              width: 30.0,
              height: 30.0,
              fit: BoxFit.cover,
            ),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}