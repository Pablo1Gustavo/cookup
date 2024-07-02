import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:front/components/LogoutButton.dart';
import 'package:front/components/NomeUsuarioCard.dart';
import 'package:front/components/RecipeListCard.dart';
import 'package:front/components/Username.dart';
import 'package:front/models/post.dart';
import 'package:front/models/receita.dart';
import 'package:front/services/auth_service.dart';
import 'package:front/utils/constants.dart';
import 'package:front/views/HomePage.dart';
import 'package:front/views/MissionPage.dart';
import 'package:front/views/RecipeList.dart';
import 'package:provider/provider.dart';
import '../components/BottomNavigation.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
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

  void changeUserProfile(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NomeUsuarioCard(
          onSubmit: (username, descricaoPerfil, fotoPerfil) async {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await context.read<AuthService>().updateUserData(
                user.uid,
                username: username,
                descricaoPerfil: descricaoPerfil,
                fotoPerfil: fotoPerfil,
              );
              Navigator.of(context).pop(); // Fechar o diálogo após salvar
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authService = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.13,
            color: primaryColor,
            child: LogoutButton(),
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
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: authService.fotoPerfil ?? '',
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.network('https://i.pinimg.com/564x/57/e4/60/57e4605cc710914108c49482bdda1366.jpg'),
                          fit: BoxFit.cover,
                          width: screenHeight * 0.1,
                          height: screenHeight * 0.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    UserProfile(),
                    SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.03,
                      child: ElevatedButton(
                        onPressed: () {
                          changeUserProfile(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        child: const Text('Editar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('${authService.pontos}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Pontos'),
                          ],
                        ),
                        Container(
                          height: 60.0,
                          child: VerticalDivider(
                            color: black200, 
                            width: 1.0, 
                            thickness: 2.0, 
                            indent: 10.0, 
                            endIndent: 10.0, 
                          ),    
                        ),                    
                        Column(
                          children: [
                            Text('400',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Receitas'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      '${authService.descricaoPerfil}',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                tabs: const [
                  Tab(icon: Icon(Icons.photo_library), text: "Feed"),
                  Tab(icon: Icon(Icons.book), text: "Receitas Criadas"),
                  Tab(icon: Icon(Icons.star), text: "Conquistas"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FeedTab(userId: authService.usuario?.uid ?? ''),
                    SavedRecipesTab(userId: authService.usuario?.uid ?? ''),
                    AchievementsTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class AchievementsTab extends StatelessWidget {
  const AchievementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
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
  final String userId;

  const FeedTab({Key? key, required this.userId}) : super(key: key);

  Future<List<Post>> fetchPosts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('postagens')
        .where('receita_ref', isNull: true)
        .where('usuario_ref', isEqualTo: FirebaseFirestore.instance.doc('/usuarios/$userId'))
        .get();


    return querySnapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar postagens'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhuma postagem encontrada'));
        } else {
          final posts = snapshot.data!;
          return GridView.count(
            crossAxisCount: 3,
            children: List.generate(posts.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: CachedNetworkImage(
                  imageUrl: posts[index].imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: black200,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: white,
                    child: Icon(Icons.error_outline_outlined, color: black200,),
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}

class SavedRecipesTab extends StatelessWidget {
  final String userId;

  const SavedRecipesTab({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<Receita>>(
      future: fetchRecipes(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar receitas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhuma receita encontrada'));
        } else {
          final receitas = snapshot.data!;
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
      },
    );
  }

  Future<List<Receita>> fetchRecipes(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('receitas')
        .where('usuario_ref', isEqualTo: FirebaseFirestore.instance.doc('/usuarios/$userId'))
        .get();

    return querySnapshot.docs.map((doc) => Receita.fromDocument(doc)).toList();
  }
}

class SavedRecipeCategory extends StatelessWidget {
  final String title;
  final List<SavedRecipeItem> recipes;

  const SavedRecipeCategory(
      {super.key, required this.title, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
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

  const SavedRecipeItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.index,
      required this.totalItems});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (totalItems - index - 1) * 100.0,
      child: Container(
        width: 120,
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(imageUrl,
                  fit: BoxFit.cover, height: 250, width: 420),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black
                    .withOpacity(0.6), // Semi-transparent background
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
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

  const AchievementItem(
      {super.key,
      required this.title,
      required this.date,
      required this.points,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(points,
          style: const TextStyle(color: Colors.orange, fontSize: 14)),
    );
  }
}
