import 'package:flutter/material.dart';
import './RecipeCard.dart';

class RecipeCardSet extends StatelessWidget {
  final String title;
  final List<Map<String, String>> recipes;

  const RecipeCardSet({super.key, required this.title, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: recipes
                .map((recipe) => RecipeCard(
                      title: recipe['title'] ?? '',
                      imageUrl: recipe['imageUrl'] ?? '',
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
