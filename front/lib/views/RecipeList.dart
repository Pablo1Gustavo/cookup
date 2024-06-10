import 'package:flutter/material.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/NewRecipe.dart';
import '../components/RecipeCardSet.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(width: 16), 
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                        // Ação ao pressionar o botão
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16), // Espaçamento interno do botão
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Borda arredondada do botão
                        ),
                        backgroundColor: primaryColor400
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Icon(
                            Icons.search, // Ícone do botão
                            size: 24, // Tamanho do ícone
                            color: backgroundColor,
                        ),
                        SizedBox(height: 4), // Espaçamento entre o ícone e o texto
                        Text(
                            'BUSCAR', // Texto do botão
                            style: TextStyle(
                            fontSize: 12, // Tamanho do texto
                            fontWeight: FontWeight.bold, // Estilo do texto
                            color: backgroundColor,
                            ),
                        ),
                        ],
                    ),
                  ),
                ),
                SizedBox(width: 16), 
                Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewRecipe(),
                            ),    
                          );                  
                        },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16), // Espaçamento interno do botão
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Borda arredondada do botão
                          ),
                          backgroundColor: primaryColor400
                      ),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon(
                              Icons.add, // Ícone do botão
                              size: 24, // Tamanho do ícone
                              color: backgroundColor,
                          ),
                          SizedBox(height: 4), // Espaçamento entre o ícone e o texto
                          Text(
                              'CRIAR', // Texto do botão
                              style: TextStyle(
                              fontSize: 12, // Tamanho do texto
                              fontWeight: FontWeight.bold, // Estilo do texto
                              color: backgroundColor,
                              ),
                          ),
                          ],
                      ),
                    ),
                ),
                const SizedBox(width: 16), 
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: primaryColor,), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search , color: primaryColor), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.book, color: primaryColor), label: 'Receitas'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment, color: primaryColor), label: 'Missões'),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: primaryColor), label: 'Perfil'),
        ],
      ),
    );
  }
}

