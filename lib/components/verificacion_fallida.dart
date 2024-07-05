import 'package:flutter/material.dart';

class VerificationFailedPopup extends StatelessWidget {
  final Function onRetry;

  VerificationFailedPopup({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Verificación fallida'),
      content: Column(
        children: [
          Text('No se pudo realizar la verificación correctamente'),
          SizedBox(height: 10),
          Text('Recomendaciones:'),
          Text('* Si su foto enviada al supervisor no usa lentes, quitese los lentes.'),
          Text('* Encuadrar mejor la cámara.'),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el PopUp
            onRetry(); // Llama a la función proporcionada para volver a intentar
          },
          child: Text('Volver a intentar'),
        ),
      ],
    );
  }
}
