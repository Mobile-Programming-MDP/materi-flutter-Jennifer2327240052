import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes/models/node.dart';
import 'package:flutter/material.dart';

class NoteDialog extends StatefulWidget {
    final Note? note;
    NoteDialog({super.key, this.note});
    @override
    State<NoteDialog> createState() => _NoteDialogState();

    class _NoteDialogState extends State<NoteDialog> {
      final TextEditingController _titleController = TextEditingController();
      final TextEditingController _descriptionController = TextEditingController();
      File? _imageFile;
      String? _base64Image;

      @override
      void initState() {
        super.initState();
        if (widget.note != null) {
          _titleController.text = widget.note!.title;
          _descriptionController.text = widget.note!.description;
          _base64Image = widget.note!.imageBase64;
        }
    }

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery
        );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        String base46String = base46Encode(bytes);
        setState(() {
            _base64Image = base46String;
            _imageFile = File(pickedFile.path)
        });
        print("Base 64 String: $base64String");
      }else {
        print("No image selected.");
      }
    }
}
}