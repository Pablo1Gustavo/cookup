import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/components/RecipeListCard.dart';
import 'package:front/models/receita.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/HomePage.dart';
import 'package:front/views/MissionPage.dart';
import 'package:front/views/RecipeList.dart';
import '../components/BottomNavigation.dart';
import 'Profile.dart';

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({Key? key});

  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Widget> _pages = [
    HomePage(),
    Profile(),
    RecipeList(),
    MissoesPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

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

  Future<List<String>> getSavedRecipeIds() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('receitas_salvas')
        .where('usuario_ref', isEqualTo: FirebaseFirestore.instance.doc('/usuarios/${user.uid}'))
        .get();

    return snapshot.docs.map((doc) {
      DocumentReference receitaRef = doc['receita_ref'];
      return receitaRef.id;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Receitas'),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: FutureBuilder<List<String>>(
        future: getSavedRecipeIds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro ao carregar as receitas.'));
          }

          final savedRecipeIds = snapshot.data ?? [];

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('receitas').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Ocorreu um erro ao carregar as receitas.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final allReceitas = snapshot.data!.docs.map((doc) => Receita.fromDocument(doc)).toList();
              final nonSavedReceitas = allReceitas.where((receita) => !savedRecipeIds.contains(receita.uid)).toList();

              return ListaReceitas(receitas: nonSavedReceitas);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class ListaReceitas extends StatelessWidget {
  final List<Receita> receitas;

  const ListaReceitas({required this.receitas});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: receitas.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final receita = receitas[index];
        return RecipeListCard(receita: receita);
      },
    );
  }
}
