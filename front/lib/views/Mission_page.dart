import 'package:flutter/material.dart';
import 'package:front/views/Profile.dart';
import 'package:front/views/RecipeList.dart';
import 'package:intl/intl.dart';

import '../components/BottomNavigation.dart';
import '../utils/constants.dart';

class MissoesPage extends StatefulWidget {
  const MissoesPage({Key? key}) : super(key: key);

  @override
  _MissoesPageState createState() => _MissoesPageState();
}

class _MissoesPageState extends State<MissoesPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            tabs: [
              Tab(text: 'MISSÕES'),
              Tab(text: 'CONQUISTAS'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MissoesTab(),
            ConquistasTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      ),
    );
  }
}

class MissoesTab extends StatefulWidget {
  const MissoesTab({Key? key}) : super(key: key);

  @override
  _MissoesTabState createState() => _MissoesTabState();
}

class _MissoesTabState extends State<MissoesTab> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Aqui você pode adicionar widgets para as missões
        ExploreMissionsCard(imageUrl: 'assets/cow_cheff.png',),
        SizedBox(height: screenHeight * 0.02),
        CheckInDiarioCard(),
        SizedBox(height: screenHeight * 0.02),
        ReceitaDoDiaCard(imageUrl: 'assets/alfajor.png',rating: 3,recipeName: 'ALFAJOR',xpPoints: 222, )
        // Adicione mais cards conforme necessário
      ],
    );
  }
}

class ConquistasTab extends StatelessWidget {
  const ConquistasTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Achievement(
          icon: Icons.star,
          title: 'Fez o primeiro sushi',
          subtitle: '20/04/2023 - +10XP',
        ),        
        Achievement(
          icon: Icons.star,
          title: 'Comida Brasileira Nível 1',
          subtitle: '20/04/2023 - +30XP',
        ),
        Achievement(
          icon: Icons.star,
          title: 'Missão Nordestina Concluída',
          subtitle: '20/04/2023 - +450XP',
        ),
      ],
    );
  }
}

class Achievement extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const Achievement({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.yellowAccent,),
        title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class CheckInDiarioCard extends StatefulWidget {
  const CheckInDiarioCard({Key? key}) : super(key: key);

  @override
  _CheckInDiarioCardState createState() => _CheckInDiarioCardState();
}

class _CheckInDiarioCardState extends State<CheckInDiarioCard> {
  List<String> _weekDays = [];

  @override
  void initState() {
    super.initState();
    _getCurrentWeek();
  }

  void _getCurrentWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Start of the week (Monday)
    _weekDays = List.generate(7, (index) {
      DateTime day = startOfWeek.add(Duration(days: index));
      return DateFormat('dd/MM').format(day);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[100], // Ajuste a cor conforme necessário
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check-in Diário',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Acumule pontos diariamente e compre novas skins',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: index == 0 ? Colors.green : Colors.grey[300],
                      child: Text(
                        '+${(index + 1) * 2}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _weekDays.isNotEmpty ? _weekDays[index] : '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreMissionsCard extends StatelessWidget {
  final String imageUrl;

  const ExploreMissionsCard({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()), // Substitua NewPage pela sua página de destino
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[100]!, Colors.blue[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.asset(
                  imageUrl,
                  height: 100, // Ajuste o tamanho da imagem conforme necessário
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Explore novas missões',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'E se torne cada vez melhor na cozinha',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReceitaDoDiaCard extends StatelessWidget {
  final String imageUrl;
  final String recipeName;
  final int xpPoints;
  final int rating;

  const ReceitaDoDiaCard({
    Key? key,
    required this.imageUrl,
    required this.recipeName,
    required this.xpPoints,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
      },
      child: Card(
        color: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receita do Dia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '+$xpPoints XP',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  child: Image.asset(
                    imageUrl,
                    height: 200, // Ajuste o tamanho da imagem conforme necessário
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipeName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          backgroundColor: Colors.black12,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 20,
                          );
                        }),
                      ),
                    ],
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