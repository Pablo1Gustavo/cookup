import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NomeUsuarioCard extends StatefulWidget {
  final void Function(String, String, String) onSubmit;

  NomeUsuarioCard({required this.onSubmit});

  @override
  _NomeUsuarioCardState createState() => _NomeUsuarioCardState();
}

class _NomeUsuarioCardState extends State<NomeUsuarioCard> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _onFinish() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && _selectedImage != null) {
        String userId = user.uid;
        Reference imagemStorageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles/$userId');
        UploadTask uploadTask = imagemStorageRef.putFile(_selectedImage!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('usuarios').doc(userId).update({
          'username': _usernameController.text.trim(),
          'descricaoPerfil': _descricaoController.text.trim(),
          'fotoPerfil': imageUrl,
          'pontos': 0, // Valor padrão inicial para pontos
        }).then((_) {
          widget.onSubmit(
            _usernameController.text.trim(),
            _descricaoController.text.trim(),
            imageUrl,
          );
          Navigator.of(context).pop();
        }).catchError((error) {
          print("Erro ao atualizar documento: $error");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Digite suas informações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Nome de usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira um nome de usuário';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  hintText: 'Descrição do Perfil',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira uma descrição do perfil';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _selectedImage == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          child: Text('Tirar Foto'),
                        ),
                        ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: Text('Escolher da Galeria'),
                        ),
                      ],
                    )
                  : Image.file(
                      _selectedImage!,
                      height: 150,
                    ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _onFinish,
                    child: Text('Confirmar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
