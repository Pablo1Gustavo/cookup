import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> _takePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      print('Image picked: ${imageFile.path}');
      setState(() {
        _isUploading = true;
        _errorMessage = null;
      });
      await _uploadImage(imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      User? user = auth.currentUser;
      if (user == null) {
        print('User is not logged in');
        setState(() {
          _isUploading = false;
          _errorMessage = 'User is not logged in';
        });
        return;
      }

      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref =
          storage.ref().child('users/${user.uid}/feed').child(fileName);

      print('Starting upload...');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      print('Upload complete');

      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print('Download URL: $downloadURL');

      await firestore.collection('usuarios/${user.uid}/feed').add({
        'image_url': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),
        'user_id': user.uid,
      });
      print('Post data saved to Firestore');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Imagem enviada com sucesso!')));
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao enviar imagem: $e')));
      setState(() {
        _errorMessage = 'Erro ao enviar imagem: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
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
                  Column(
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
                  IconButton(
                    onPressed: _takePicture,
                    icon: Icon(Icons.camera_alt),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      iconColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
