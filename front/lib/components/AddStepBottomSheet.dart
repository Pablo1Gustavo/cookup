import 'package:flutter/material.dart';
import 'package:front/utils/constants.dart';

class AddStepBottomSheet extends StatelessWidget {
  final Function(String) onStepAdded;

  const AddStepBottomSheet({super.key, required this.onStepAdded});

  @override
  Widget build(BuildContext context) {
    TextEditingController itemController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: 'Digite o texto do passo',
                hintStyle: const TextStyle(color: black200),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Cancelar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Adicionar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: white,
                      )),
                  onPressed: () {
                    String newItem = itemController.text;
                    onStepAdded(newItem);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
