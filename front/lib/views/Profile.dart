import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:front/utils/constants.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
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
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.13,
            color: primaryColor,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    CircleAvatar(
                      radius: screenHeight * 0.05,
                      backgroundImage: NetworkImage('https://i.pinimg.com/564x/57/e4/60/57e4605cc710914108c49482bdda1366.jpg'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Marcos D. Pedro',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.03,
                      child: ElevatedButton(
                        onPressed: () {
                          // Ação ao clicar no botão Editar
                        },
                        child: Text('Editar',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('200', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Pontos'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('400', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Receitas'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('200', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Seguidores'),
                          ],
                        ),
                        Column(
                          children: [
                            Text('200', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Seguindo'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Fazedor de miojo na semana e chef nos feriados.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_pin, color: Colors.red),
                        Text('De Natal, Brasil', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 5),
                        CountryFlag.fromCountryCode(
                          'BR',
                          height: 24,
                          width: 24,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                tabs: [
                  Tab(icon: Icon(Icons.photo_library), text: "Feed"),
                  Tab(icon: Icon(Icons.book), text: "Receitas Salvas"),
                  Tab(icon: Icon(Icons.star), text: "Conquistas"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FeedTab(),
                    SavedRecipesTab(),
                    AchievementsTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        items: [
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

class AchievementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AchievementItem(
          title: 'Fez o primeiro sushi',
          date: '20/04/2023',
          points: '+10XP',
          icon: Icons.check_circle,
        ),
        AchievementItem(
          title: 'Comida Brasileira Nível 1',
          date: '20/04/2023',
          points: '+30XP',
          icon: Icons.check_circle,
        ),
        AchievementItem(
          title: 'Missão Nordestina Concluída',
          date: '20/04/2023',
          points: '+450XP',
          icon: Icons.check_circle,
        ),
      ],
    );
  }
}

class FeedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(10, (index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.network('https://i.pinimg.com/564x/8d/71/c2/8d71c2cb56287e22643f20f53a2cac81.jpg', fit: BoxFit.cover),
        );
      }),
    );
  }
}

class SavedRecipesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SavedRecipeCategory(
          title: 'Japonesas',
          recipes: List.generate(3, (index) {
            return SavedRecipeItem(
              title: 'Sushi',
              imageUrl: 'https://img.freepik.com/free-photo/maki-roll-with-cucumber-served-with-sauce-sesame-seeds_141793-790.jpg?t=st=1717690607~exp=1717694207~hmac=daa02204027a98f82a4f2156d615db3093825d5dce198adf2f461d3ce18d1fc6&w=740',
              index: index,
              totalItems: 3,
            );
          }),
        ),
        SavedRecipeCategory(
          title: 'Italianas',
          recipes: List.generate(3, (index) {
            return SavedRecipeItem(
              title: 'Pizza',
              imageUrl: 'https://img.freepik.com/free-photo/slice-crispy-pizza-with-meat-cheese_140725-6974.jpg?t=st=1717690586~exp=1717694186~hmac=7718023e64f9a62503a096c37a26115a68bf743c48ccd7ab37945142eda5ccc9&w=740',
              index: index,
              totalItems: 3,
            );
          }),
        ),
        SavedRecipeCategory(
          title: 'Brasileiras',
          recipes: List.generate(3, (index) {
            return SavedRecipeItem(
              title: 'Cuixcuix',
              imageUrl: 'https://img.freepik.com/premium-photo/cuscuz-with-cheese-typical-northeastern-food-white-plate-wooden-table_66339-373.jpg?w=996',
              index: index,
              totalItems: 3,
            );
          }),
        ),
      ],
    );
  }
}

class SavedRecipeCategory extends StatelessWidget {
  final String title;
  final List<SavedRecipeItem> recipes;

  SavedRecipeCategory({required this.title, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: recipes,
            ),
          ),
        ],
      ),
    );
  }
}

class SavedRecipeItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int index;
  final int totalItems;

  SavedRecipeItem({required this.title, required this.imageUrl, required this.index, required this.totalItems});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (totalItems - index - 1) * 100.0,
      child: Container(
        width: 120,
        margin: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(imageUrl, fit: BoxFit.cover, height: 250, width: 420),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.6), // Semi-transparent background
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementItem extends StatelessWidget {
  final String title;
  final String date;
  final String points;
  final IconData icon;

  AchievementItem({required this.title, required this.date, required this.points, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(points, style: TextStyle(color: Colors.orange, fontSize: 14)),
    );
  }
}
