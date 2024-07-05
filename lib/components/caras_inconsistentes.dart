import 'package:flutter/material.dart';

class MultipleFacesDetectedPopup extends StatelessWidget {
  final Function onUnderstood;

  MultipleFacesDetectedPopup({required this.onUnderstood});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detección 1'),
      content: Column(
        children: [
          Text('Se detectaron más de una cara mediante la cámara, se enviará al supervisor'),
          SizedBox(height: 10),
          Text('Recomendaciones:'),
          Text('* Por favor, evitar que aparezcan más personas cerca suyo.'),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el PopUp
            onUnderstood(); // Llama a la función proporcionada al presionar "Entendido"
          },
          child: Text('Entendido'),
        ),
      ],
    );
  }
}
