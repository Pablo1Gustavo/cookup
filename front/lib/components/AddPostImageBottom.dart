import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front/models/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/HomePage.dart';
import 'package:front/components/ImagePickerComponent.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddPostImageBottom extends StatefulWidget {
  const AddPostImageBottom({Key? key}) : super(key: key);

  @override
  _AddPostImageBottomState createState() => _AddPostImageBottomState();
}

class _AddPostImageBottomState extends State<AddPostImageBottom> {
  TextEditingController itemController = TextEditingController();
  XFile? selectedImage;

  void createPost(String descricao) async {
    if (selectedImage == null || descricao.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Por favor, selecione uma imagem e insira uma descrição.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String imageUrl = '';

      try {
        // Upload da imagem para o Firebase Storage
        Reference imagemStorageRef = FirebaseStorage.instance.ref().child('postagens/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = imagemStorageRef.putFile(File(selectedImage!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        imageUrl = await taskSnapshot.ref.getDownloadURL();

        Post post = Post(
          curtidas: 0,
          descricao: descricao,
          imageUrl: imageUrl,
          usuarioRef: FirebaseFirestore.instance.doc('/usuarios/${user.uid}'),
          dataPostagem: Timestamp.now(),
        );

        // Verifica se o widget ainda está montado antes de navegar
        if (mounted) {
          await FirebaseFirestore.instance.collection('postagens').add(post.toMap());

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Erro ao publicar a postagem: $e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImagePickerComponent(
              onImagePicked: (image) {
                setState(() {
                  selectedImage = image;
                });
              },
            ),
            TextField(
              controller: itemController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: 'Digite a descrição da publicação',
                hintStyle: const TextStyle(color: black200),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text(
                    'Publicar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                  onPressed: () {
                    createPost(itemController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
