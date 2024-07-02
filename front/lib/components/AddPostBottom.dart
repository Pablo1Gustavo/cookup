import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/utils/constants.dart';
import 'package:front/models/post.dart';
import 'package:front/views/HomePage.dart';

class AddPostBottom extends StatelessWidget {
  final String? receitaUID;

  const AddPostBottom({Key? key, required this.receitaUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController itemController = TextEditingController();

    void createPost(String descricao) async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Post post = Post(
          curtidas: 0,
          descricao: descricao,
          receitaRef: FirebaseFirestore.instance.doc('/receitas/$receitaUID'),
          usuarioRef: FirebaseFirestore.instance.doc('/usuarios/${user.uid}'),
          dataPostagem: Timestamp.now(),
        );

        await FirebaseFirestore.instance.collection('postagens').add(post.toMap());

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
