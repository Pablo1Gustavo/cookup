import 'package:flutter/material.dart';

class EditableList extends StatelessWidget {
  final List<String> list;
  final String nameOfList;
  final Function(int) onRemove;
  final VoidCallback onAdd;

  const EditableList({
    required this.list,
    required this.nameOfList,
    required this.onRemove,
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('${nameOfList}s', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index]),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () => onRemove(index),
              ),
            );
          },
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: onAdd,
          child: Text('Adicionar ${nameOfList}'),
        ),
      ],
    );
  }
}