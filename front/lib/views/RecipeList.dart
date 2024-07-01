import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front/models/receita.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/HomePage.dart';
import 'package:front/views/MissionPage.dart';
import 'package:front/views/NewRecipe.dart';
import 'package:front/views/RecipeDetails.dart';
import '../components/BottomNavigation.dart';
import 'Profile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

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
              child: ButtonCreate(onPressed: () => {}),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('receitas').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Ocorreu um erro ao carregar as receitas.'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final receitas = snapshot.data!.docs.map((doc) => Receita.fromDocument(doc)).toList();
                  return ListaReceitas(receitas: receitas);
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

class ButtonCreate extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonCreate({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewRecipe(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: primaryColor400,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 24,
            color: backgroundColor,
          ),
          SizedBox(height: 4),
          Text(
            'CRIAR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: backgroundColor,
            ),
          ),
        ],
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
        return RecipeCard(receita: receita);
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Receita receita;

  const RecipeCard({required this.receita});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(receita: receita),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.network(
                receita.imagemUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '+ ${receita.pontuacao} XP',
                          style: TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          receita.nome,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: CustomIconButton(
                  onPressed: () {
                    // ação do botão
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomIconButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 12.0, left: 16.0, right: 8.0),
        child: IconButton(
          icon: SvgPicture.asset(
            'assets/book_check.svg',
            width: 30.0,
            height: 30.0,
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
