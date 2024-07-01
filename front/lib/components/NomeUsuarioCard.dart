import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/services/auth_service.dart';

class NomeUsuarioCard extends StatefulWidget {
  final void Function(String, String, String) onSubmit;

  NomeUsuarioCard({required this.onSubmit});

  @override
  _NomeUsuarioCardState createState() => _NomeUsuarioCardState();
}

class _NomeUsuarioCardState extends State<NomeUsuarioCard> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _fotoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Escolha um Nome de Usuário',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Nome de usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira um nome de usuário';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  hintText: 'Descrição do Perfil',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira uma descrição do perfil';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fotoController,
                decoration: InputDecoration(
                  hintText: 'URL da Foto do Perfil',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a URL da foto do perfil';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(
                      _usernameController.text.trim(),
                      _descricaoController.text.trim(),
                      _fotoController.text.trim(),
                    );
                    context.read<AuthService>().updateUserData(
                      context.read<AuthService>().usuario!.uid,
                      username: _usernameController.text.trim(),
                      descricaoPerfil: _descricaoController.text.trim(),
                      fotoPerfil: _fotoController.text.trim(),
                      pontos: 0, // Valor padrão inicial para pontos
                    ); // Atualiza os dados do usuário no AuthService
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
