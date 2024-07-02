import 'package:flutter/material.dart';
import 'package:front/services/auth_service.dart';
import 'package:front/utils/constants.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {

  const LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(Icons.logout, size: 40, color: white,),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Sair"),
                  content: Text("Tem certeza que deseja sair?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Provider.of<AuthService>(context, listen: false).logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AuthCheck()),
                        );
                      },
                      child: Text("Sair"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}