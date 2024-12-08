import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.getPickedPicture});

  final void Function(File pickedPicture) getPickedPicture;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _takenImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _takenImage = File(pickedImage.path);
    });
    widget.getPickedPicture(_takenImage!);
  }

  void _galleryImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _takenImage = File(pickedImage.path);
    });
    widget.getPickedPicture(_takenImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton.icon(
          onPressed: _takePicture,
          label: const Text('Take Picture'),
          icon: const Icon(Icons.camera),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton.icon(
          onPressed: _galleryImage,
          label: const Text('Pick Picture'),
          icon: const Icon(Icons.image),
        ),
      ],
    );

    if (_takenImage != null) {
      content = Image.file(
        _takenImage!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              )),
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          child: content,
        ),
        if (_takenImage != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: _takePicture,
                    label: const Text('Take Picture'),
                    icon: const Icon(Icons.camera),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton.icon(
                    onPressed: _galleryImage,
                    label: const Text('Pick Picture'),
                    icon: const Icon(Icons.image),
                  ),
                ],
              ),
            ],
          )
      ],
    );
  }
}
