import 'package:flutter/material.dart';
import 'package:front/components/SaveUnsaveRecipeButton.dart';
import 'package:front/models/post.dart';
import 'package:front/models/receita.dart';
import 'package:front/models/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;
  late Future<Usuario?> _usuarioFuture;
  late Future<Receita?> _receitaFuture;

  PostCard({
    required this.post,
  }) {
    _usuarioFuture = _fetchUsuario();
    if (post.receitaRef != null) {
      _receitaFuture = _fetchReceita();
    } else {
      _receitaFuture = Future.value(null); 
    }
  }

  Future<Usuario?> _fetchUsuario() async {
    if (post.usuarioRef == null) {
      return null;
    }
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await post.usuarioRef!.get();
      return Usuario.fromDocument(snapshot);
    } catch (e) {
      print('Erro ao carregar usuário: $e');
      return null;
    }
  }

  Future<Receita?> _fetchReceita() async {
    if (post.receitaRef == null) {
      return null;
    }
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await post.receitaRef!.get();
      return Receita.fromDocument(snapshot);
    } catch (e) {
      print('Erro ao carregar receita: $e');
      return null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.transparent,
      elevation: 0, 
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            SizedBox(height: 10.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  _buildPostImage(),
                  if (post.receitaRef != null) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 18.0, top: 18.0, left: 24.0, right: 0),
                              child: FutureBuilder<Receita?>(
                                future: _receitaFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Erro ao carregar título: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData || snapshot.data == null) {
                                    return Text('Título não encontrado');
                                  }
                                  return Text(
                                    snapshot.data!.nome,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SaveUnsaveRecipeButton(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
                              padding: EdgeInsets.only(top: 12.0, bottom: 8.0, left: 18.0, right: 8.0),  
                              receitaUID: post.receitaRef!.id,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),   
            SizedBox(height: 10.0),
            Text(
              post.descricao,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy • HH:mm');
    return formatter.format(timestamp.toDate());
  }

  Widget _buildUserInfo() {
    return FutureBuilder<Usuario?>(
      future: _usuarioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Erro ao carregar nome de usuário: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('Usuário não encontrado');
        }
        Usuario usuario = snapshot.data!;
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(usuario.fotoPerfil),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_formatDate(post.dataPostagem)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPostImage() {
    return FutureBuilder<Receita?>(
      future: _receitaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Erro ao carregar imagem da receita: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 200.0,
            fit: BoxFit.cover,
          );
        }
        Receita receita = snapshot.data!;
        if (receita.imagemUrl.isEmpty) {
          return Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 200.0,
            fit: BoxFit.cover,
          );
        }
        return Image.network(
          receita.imagemUrl,
          width: double.infinity,
          height: 200.0,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
