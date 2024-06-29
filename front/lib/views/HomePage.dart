import 'package:flutter/material.dart';
import 'package:front/components/BottomNavigation.dart';
import 'package:front/models/post.dart';
import 'package:front/components/PostCard.dart';
import 'package:front/views/Profile.dart';
import 'package:front/views/RecipeList.dart';
import 'package:front/views/Mission_page.dart';
import 'package:front/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Post> posts = [
    Post(
      username: 'Pedro Calafange',
      date: '14/04/2024',
      time: '22:10',
      imageUrl: 'https://www.minhareceita.com.br/app/uploads/2022/12/pizza-de-pepperoni-caseira-portal-minha-receita.jpg',
      title: 'Pizza de Frango',
      description:
          'Boa noite gente, hoje saiu essa linda pizza. Para quem também quiser fazer eu cadastrei a receita!',
    ),
    Post(
      username: 'Pablo Silva',
      date: '14/04/2024',
      time: '22:10',
      imageUrl: 'https://img.band.uol.com.br/image/2023/09/25/salada-1549_800x450.webp',
      title: 'Salada',
      description:
          'Deliciosa salada com morangos e nozes. Super saudável e fácil de fazer!',
    ),
  ];

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
            NewPostCard(),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    username: posts[index].username,
                    date: posts[index].date,
                    time: posts[index].time,
                    imageUrl: posts[index].imageUrl,
                    title: posts[index].title,
                    description: posts[index].description,
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

class NewPostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, 
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá Marcos',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'O que vai compartilhar hoje?',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                
              },
              icon: Icon(Icons.add),
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                iconColor: white,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), 
                alignment: Alignment.center 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
