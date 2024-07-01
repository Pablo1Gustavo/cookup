import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front/components/EditableList.dart';
import 'package:front/views/RecipeList.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front/components/AddItemBottomSheet.dart';
import 'package:front/components/AddStepBottomSheet.dart';
import 'package:front/components/ImagePickerComponent.dart';
import 'package:front/utils/constants.dart';
import 'package:front/models/receita.dart';

class NewRecipe extends StatefulWidget {
  const NewRecipe({super.key});

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _pontuacaoController = TextEditingController();
  final TextEditingController _tempoPreparoController = TextEditingController();

  XFile? selectedImage;

  List<String> passos = [];
  List<String> ingredients = [];

  Future<void> _showAddItemBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      builder: (context) {
        return AddItemBottomSheet(
          onItemAdded: (newItem) {
            setState(() {
              ingredients.add(newItem);
            });
          },
        );
      },
    );
  }

  Future<void> _showAddStepBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      builder: (context) {
        return AddStepBottomSheet(
          onStepAdded: (newStep) {
            setState(() {
              passos.add(newStep);
            });
          },
        );
      },
    );
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void _removePasso(int index) {
    setState(() {
      passos.removeAt(index);
    });
  }

  void _onFinish() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && selectedImage != null) {
        String userId = user.uid;
        Reference imagemStorageRef = FirebaseStorage.instance.ref().child('receitas/${_tituloController.text}');
        UploadTask uploadTask = imagemStorageRef.putFile(File(selectedImage!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        Receita receita = Receita(
          nome: _tituloController.text,
          imagemUrl: imageUrl,
          pontuacao: int.parse(_pontuacaoController.text),
          tempoPreparo: int.parse(_tempoPreparoController.text),
          listaIngredientes: ingredients,
          ordemPreparo: passos,
          usuarioRef: FirebaseFirestore.instance.doc('/usuarios/$userId'),
        );

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('receitas').add(receita.toMap()).then((docRef) {
          print("Documento adicionado com ID: ${docRef.id}");
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeList()
            ),
          );
        }).catchError((error) {
          print("Erro ao adicionar documento: $error");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Receita'),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ImagePickerComponent(
                  onImagePicked: (image) {
                    setState(() {
                      selectedImage = image;
                    });
                  },
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Insira o título da receita',
                    hintStyle: const TextStyle(color: black200),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o título da receita';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _pontuacaoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Insira a pontuação',
                    hintStyle: const TextStyle(color: black200),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a pontuação';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _tempoPreparoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Insira o tempo de preparo (minutos)',
                    hintStyle: const TextStyle(color: black200),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tempo de preparo';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                EditableList(
                  list: ingredients,
                  nameOfList: 'Ingrediente',
                  onAdd: _showAddItemBottomSheet,
                  onRemove: (index) => _removeIngredient(index),
                ),
                const SizedBox(height: 10.0),
                Divider(),
                EditableList(
                  list: passos,
                  nameOfList: 'Passo',
                  onAdd: _showAddStepBottomSheet,
                  onRemove: (index) => _removePasso(index),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CustomBottomNavigationBar(onFinish: _onFinish),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final VoidCallback onFinish;

  const CustomBottomNavigationBar({
    required this.onFinish,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: ElevatedButton.icon(
        onPressed: onFinish,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: primaryColor,
        ),
        icon: Icon(Icons.check, color: Colors.white),
        label: Text(
          'Finalizar Criação',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
