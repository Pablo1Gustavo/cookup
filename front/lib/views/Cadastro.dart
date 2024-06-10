import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/views/Login.dart';


import '../utils/constants.dart';
import 'Profile.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _CadastroController = TextEditingController();
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
            SizedBox(height: 200),
            Center(
              child: Image.asset('assets/logo_cookup.png', width: 400, height: 200),
            ),
            Align(
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
              controller: _CadastroController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Insira seu login',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  )),
            ),
            SizedBox(height: 30),
             Align(
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
              controller: _CadastroController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Insira seu login',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  )),
            ),
            SizedBox(height: 30),
            Align(
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  )),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(primaryColor),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },
                child: Text('Cadastrar'),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Ja tem uma conta? ",
                    style: TextStyle(
                        color: Color.fromARGB(
                            255, 16, 16, 16)),
                  ),
                  TextSpan(
                    text: "conecte-se",
                    style: TextStyle(
                      color:
                          primaryColor,
                      fontWeight: FontWeight
                          .bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
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
