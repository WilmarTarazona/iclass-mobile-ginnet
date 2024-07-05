import 'package:flutter/material.dart';
import 'package:iclassmultiplataform/database/database_helper.dart';

class VerificationSuccessPopup extends StatelessWidget {

  DBHelper dbHelper = DBHelper();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Verificación Exitosa'),
      content: Column(
        children: [
          Text('Se realizó la verificación correctamente'),
          SizedBox(height: 10),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el PopUp
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}