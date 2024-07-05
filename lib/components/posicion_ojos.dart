import 'package:flutter/material.dart';

class SuspiciousEyePositionPopup extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detección 2'),
      content: Column(
        children: [
          Text('Se detectó que las posiciones de los ojos del usuario son sospechosas, se enviará al supervisor'),
          SizedBox(height: 10),
          Text('Recomendaciones:'),
          Text('* Por favor, mantener la posición de los ojos cerca de la cámara.'),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el PopUp

          },
          child: Text('Entendido'),
        ),
      ],
    );
  }
}