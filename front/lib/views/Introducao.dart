import 'package:flutter/material.dart';
import 'package:front/utils/constants.dart';
import 'Login.dart';

class Introducao extends StatefulWidget {
  const Introducao({super.key});

  @override
  State<Introducao> createState() => _IntroducaoState();
}

class _IntroducaoState extends State<Introducao> {


  @override
  Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/intro_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(32, 50, 32, 4),
                child: Text(
                  'Aprimore suas habilidades culinárias!',
                  style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: screenHeight * 0.3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(primaryColor),
                      foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                    child: const Text('Começar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
