import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/services/auth_service.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (authService.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (authService.usuario == null) {
      return Text('Usuário não logado');
    }

    return Text(
      authService.username ?? 'Nome de usuário não encontrado',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
