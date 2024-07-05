import 'package:flutter/material.dart';
class ForbiddenWordsPopup extends StatelessWidget {
  final List<String> forbiddenWords;

  ForbiddenWordsPopup({required this.forbiddenWords});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Palabras Prohibidas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Se han detectado palabras prohibidas:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          for (var word in forbiddenWords) Text('- $word'),
          SizedBox(height: 10),
          Text(
            'Se avisará al supervisor.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}