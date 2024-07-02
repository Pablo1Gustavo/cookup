import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/components/ButtonLarge.dart';
import 'package:front/components/RecipeListCard.dart';
import 'package:front/models/receita.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/HomePage.dart';
import 'package:front/views/Mission_page.dart';
import 'package:front/views/NewRecipe.dart';
import 'package:front/views/SearchRecipe.dart';
import '../components/BottomNavigation.dart';
import 'Profile.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> with SingleTickerProviderStateMixin {
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

  void onCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewRecipe(),
      ),
    );
  }

  void onSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchRecipe(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonLarge(
                      icon: Icons.add,
                      labelTxt: "CRIAR",
                      onPressed: onCreate,
                    )
                  ),
                  SizedBox(width: 16.0,),
                  Expanded (
                    child: ButtonLarge(
                      icon: Icons.search,
                      labelTxt: "BUSCAR",
                      onPressed: onSearch,
                    ),
                  ),
                ],
              )
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                  .collection('receitas_salvas')
                  .where('usuario_ref', isEqualTo: FirebaseFirestore.instance.doc('/usuarios/${_auth.currentUser?.uid}'))
                  .snapshots(),
                builder: (context, savedSnapshot) {
                  if (savedSnapshot.hasError) {
                    return Center(child: Text('Ocorreu um erro ao carregar as receitas salvas.'));
                  }
                  if (savedSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final List<String> savedRecipeIds = savedSnapshot.data!.docs.map((doc) => doc['receita_ref'].id as String).toList();
                  final List<Timestamp?> savedDates = savedSnapshot.data!.docs.map((doc) => doc['data_realizacao'] as Timestamp?).toList();

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection('receitas').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Ocorreu um erro ao carregar as receitas.'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // Filtrando as receitas para exibir apenas as salvas
                      final List<Receita> receitas = snapshot.data!.docs
                        .where((doc) => savedRecipeIds.contains(doc.id))
                        .map((doc) => Receita.fromDocument(doc))
                        .toList();

                      return ListaReceitas(receitas: receitas, datas: savedDates);
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
  final List<Timestamp?> datas;

  const ListaReceitas({required this.receitas, required this.datas});

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
        return RecipeListCard(receita: receita, dataRealizacao: datas[index] );
      },
    );
  }
}