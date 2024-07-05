import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iclassmultiplataform/pages/iniciarExamen.dart';
import 'package:iclassmultiplataform/components/textfield.dart';
import 'package:iclassmultiplataform/components/button_login.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> iniciarSesion(BuildContext context) async {
    const String url = 'http://192.168.86.157:5002/login';

    final String username = usernameController.text;
    final String password = passwordController.text;

    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

     if (response.statusCode == 200) {
   final Map<String, dynamic> responseBody = json.decode(response.body);


   if (responseBody['success']) {
     List<CameraDescription> cameras = await availableCameras();
     List<String>? listaOracionesProhibidas = List<String>.from(responseBody['prohibited_sentences']);


     await Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => CameraPage(
           cameras: cameras,
           listaOraciones: listaOracionesProhibidas,
           initializeMicrophone: () {
             // Initialize microphone here
             // You can call initSpeechRecognizer() or any other initialization method
           },
         ),
       ),
     );
   } else {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Error'),
           content: Text('Credenciales incorrectas'),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: Text('OK'),
             ),
           ],
         );
       },
     );
   }
 } else {
   print('Error en la solicitud: ${response.statusCode}');
 }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset('lib/Images/ginnet_logo.png', // Ruta de la imagen
                height: 100,
                width: 100,),
              const SizedBox(height: 50),

              Text(
                'Inicia sesión con tu cuenta',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),


              textfield(
                controller: usernameController,
                hintText: 'Usuario',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              textfield(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),

              const SizedBox(height: 25),

              buttonLogin(
                onTap: () async {
                  await iniciarSesion(context);
                },
              ),

              const SizedBox(height: 50),

              // Nuevo contenido al final de la pantalla con imágenes
              Text(
                'Visítanos en nuestras redes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset('lib/Images/facebook_icon.png', // Ruta de la imagen
                        height: 100,
                        width: 100,),
                      const SizedBox(height: 8),
                      Text('Facebook'),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('lib/Images/ginnet_logo.png', // Ruta de la imagen
                        height: 100,
                        width: 100,),
                      const SizedBox(height: 8),
                      Text('Twitter'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}