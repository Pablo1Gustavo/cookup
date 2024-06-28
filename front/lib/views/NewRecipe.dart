import 'package:flutter/material.dart';
import 'package:front/components/AddItemBottomSheet.dart';
import 'package:front/components/ImagePickerComponent.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/RecipeList.dart';
import 'package:image_picker/image_picker.dart';

class NewRecipe extends StatefulWidget {
  const NewRecipe({super.key});

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  XFile? selectedImage;
  List<Step> steps = [
    Step(title: 'Passo 1'),
    Step(title: 'Passo 2'),
    Step(title: 'Passo 3'),
  ];
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

  Future<void> _showTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      print('Timer: ${pickedTime.format(context)}');
      // Adicione a lógica para usar o tempo selecionado
    }
  }

  void _addStep() {
    setState(() {
      steps.add(Step(title: 'Passo ${steps.length + 1}'));
    });
  }

  void _removeStep(int index) {
    setState(() {
      steps.removeAt(index);
      for (int i = 0; i < steps.length; i++) {
        steps[i].title = 'Passo ${i + 1}';
      }
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(screenHeight * 0.08), // altura da app bar
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0), // padding superior
          child: AppBar(
            title: const Text(
              'Nova Receita',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: backgroundColor,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: 'Insira o título da receita',
                hintStyle: const TextStyle(color: black200),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Ingredientes',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ingredients[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeIngredient(index),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: _showAddItemBottomSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                padding: const EdgeInsets.all(10.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 24,
                    color: black400,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicionar Ingrediente',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: black400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Divider(),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      Step step = steps[index];
                      return ExpansionTile(
                        title: Text(
                          step.title,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: black400),
                        ),
                        initiallyExpanded: step.isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            step.isExpanded = expanded;
                          });
                        },
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _showAddItemBottomSheet,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: white,
                                          padding: const EdgeInsets.all(10.0),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: 24,
                                              color: black400,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Item',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: black400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _showTimePicker,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: white,
                                          padding: const EdgeInsets.all(10.0),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              size: 24,
                                              color: black400,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Timer',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: black400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeStep(index),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      padding: const EdgeInsets.all(10.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 24,
                          color: black400,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Adicionar Passo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: black400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: backgroundColor,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipeList(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: primaryColor,
          ),
          child: const Text(
            'Finalizar Criação',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class Step {
  String title;
  bool isExpanded;
  Step({required this.title, this.isExpanded = false});
}
