import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:front/utils/constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Marcos Pedro',
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
              Expanded(
                child: ListView(
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
