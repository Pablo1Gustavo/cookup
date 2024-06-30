import 'package:flutter/material.dart';
import 'package:front/services/auth_service.dart';
import 'package:provider/provider.dart';

class NomeUsuarioCard extends StatefulWidget {
  final void Function(String) onSubmit;

  NomeUsuarioCard({required this.onSubmit});

  @override
  _NomeUsuarioCardState createState() => _NomeUsuarioCardState();
}

class _NomeUsuarioCardState extends State<NomeUsuarioCard> {
  final TextEditingController _usernameController = TextEditingController();
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(_usernameController.text.trim());
                    context.read<AuthService>().updateUsername(
                      context.read<AuthService>().usuario!.uid,
                      _usernameController.text.trim(),
                    ); // Atualiza o nome do usuário no AuthService
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
