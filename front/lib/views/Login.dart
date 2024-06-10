import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import '../utils/constants.dart';
import 'Profile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 200),
            Center(
              child: Image.asset('assets/logo_cookup.png', width: 400, height: 200),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: _loginController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Insira seu login',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  )),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Senha",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: _senhaController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Insira sua senha',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  )),
            ),
            const SizedBox(height: 200),
            SizedBox(
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
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                child: const Text('Logar'),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Não possui conta? ",
                    style: TextStyle(
                        color: Color.fromARGB(
                            255, 16, 16, 16)), // Customize text color as needed
                  ),
                  TextSpan(
                    text: "Cadastre-se",
                    style: const TextStyle(
                      color:
                          primaryColor, // Use a contrasting color for the button
                      fontWeight: FontWeight
                          .bold, // Make the button text bol // Add an underline for button effect
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("tela cadastro em breve");
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
