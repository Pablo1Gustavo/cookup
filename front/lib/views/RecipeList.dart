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

    List<Receita> receitas = [
      Receita(
        nome: 'Pizza de Frango',
        imagemUrl: 'https://static.itdg.com.br/images/360-240/cf2da6aff0dead381432a891fc23e06e/shutterstock-378226756.jpg',
        pontuacao: 40,
        tempoPreparo: 30,
        listaIngredientes: ['frango', 'queijo', 'massa de pizza', 'molho de tomate'],
        ordemPreparo: ['Prepare a massa', 'Adicione o molho', 'Coloque o frango e o queijo', 'Asse a pizza'],
        usuarioCriadorId: 'usuario1',
      ),
      Receita(
        nome: 'Carbonara',
        imagemUrl: 'https://conteudo.imguol.com.br/c/entretenimento/be/2022/05/09/carbonara---ronald-1652100428622_v2_1x1.jpg',
        pontuacao: 45,
        tempoPreparo: 20,
        listaIngredientes: ['macarrão', 'bacon', 'ovos', 'queijo parmesão'],
        ordemPreparo: ['Cozinhe o macarrão', 'Frite o bacon', 'Misture os ovos e o queijo', 'Combine tudo'],
        usuarioCriadorId: 'usuario2',
      ),
      Receita(
        nome: 'Feijoada',
        imagemUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3_-OkfYJyn8TXddFBCLo_7dgafz5VMOiMqQ&s',
        pontuacao: 60,
        tempoPreparo: 120,
        listaIngredientes: ['feijão preto', 'carne de porco', 'linguiça', 'arroz'],
        ordemPreparo: ['Cozinhe o feijão', 'Prepare as carnes', 'Combine tudo e cozinhe', 'Sirva com arroz'],
        usuarioCriadorId: 'usuario3',
      ),
      Receita(
        nome: 'Salada',
        imagemUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe1DiZXkHWhzjRERsQpWHInCW9e-8bsvnKsw&s',
        pontuacao: 20,
        tempoPreparo: 10,
        listaIngredientes: ['alface', 'tomate', 'cenoura', 'pepino'],
        ordemPreparo: ['Lave os vegetais', 'Corte os vegetais', 'Misture tudo em uma tigela', 'Sirva com molho de sua preferência'],
        usuarioCriadorId: 'usuario4',
      ),
      Receita(
        nome: 'Sushi',
        imagemUrl: 'https://www.folhabv.com.br/wp-content/plugins/seox-image-magick/imagick_convert.php?width=2000&height=1333&format=.jpg&quality=91&imagick=uploads.folhabv.com.br/2023/09/1aaa.jpg',
        pontuacao: 120,
        tempoPreparo: 50,
        listaIngredientes: ['arroz para sushi', 'peixe cru', 'alga', 'vinagre de arroz'],
        ordemPreparo: ['Prepare o arroz', 'Corte o peixe', 'Enrole o sushi', 'Corte e sirva'],
        usuarioCriadorId: 'usuario5',
      ),
      Receita(
        nome: 'Macarrão ao Molho Branco',
        imagemUrl: 'https://static.itdg.com.br/images/1200-675/108cb886572a98cb7d90372c5a799ff0/353778-original.jpg',
        pontuacao: 40,
        tempoPreparo: 25,
        listaIngredientes: ['macarrão', 'molho branco', 'queijo parmesão', 'ervas'],
        ordemPreparo: ['Cozinhe o macarrão', 'Prepare o molho branco', 'Combine o macarrão e o molho', 'Sirva com queijo parmesão e ervas'],
        usuarioCriadorId: 'usuario6',
      ),
    ];


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
              child: ListaReceitas(receitas: receitas),
            )
          ]
        )
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
          backgroundColor: primaryColor400
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

  ListaReceitas({required this.receitas});

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

  RecipeCard({required this.receita});

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
                        end: Alignment.topCenter
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
      )
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomIconButton({required this.onPressed});

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
          padding: EdgeInsets.only( top: 4.0, bottom: 12.0, left: 16.0, right: 8.0),        
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