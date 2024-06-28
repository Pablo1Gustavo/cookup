import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerComponent extends StatefulWidget {
  final Function(XFile?) onImagePicked;

  const ImagePickerComponent({super.key, required this.onImagePicked});

  @override
  State<ImagePickerComponent> createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  XFile? selectedImage;

  Future<void> _pickImage() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Abrir Câmera'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Selecionar da Galeria'),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        },
      );

      if (source != null) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: source);

        setState(() {
          selectedImage = pickedFile;
        });

        widget.onImagePicked(pickedFile);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A permissão de Câmera é necessária!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        selectedImage == null
            ? const Text("Nenhuma imagem selecionada")
            : SizedBox(
                width: double.infinity,
                child: Image.file(
                  File(selectedImage!.path),
                  height: 200,
                  width: double.infinity,
                ),
              ),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(10.0),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 24,
                color: Colors.black,
              ),
              SizedBox(height: 8),
              Text(
                'Adicionar Imagem',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
