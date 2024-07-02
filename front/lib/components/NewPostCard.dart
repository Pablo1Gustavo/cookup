import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:front/components/AddPostImageBottom.dart';
import 'package:front/components/Username.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';
import 'dart:io';

class NewPostCard extends StatefulWidget {
  @override
  _NewPostCardState createState() => _NewPostCardState();
}

class _NewPostCardState extends State<NewPostCard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  bool _isUploading = false;
  String? _errorMessage;

  Future<void> _newPost() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      builder: (context) {
        return AddPostImageBottom();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: _isUploading
            ? Center(child: CircularProgressIndicator())
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Olá ',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            UserProfile(),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'O que vai compartilhar hoje?',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _newPost,
                    icon: Icon(Icons.camera_alt),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0)),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
      ),
    );
  }
}
