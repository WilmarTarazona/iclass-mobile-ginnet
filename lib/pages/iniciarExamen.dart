import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:iclassmultiplataform/components/ForbiddenWordsPopup.dart';
import 'package:iclassmultiplataform/components/verificacion_exitosa.dart';
import 'package:iclassmultiplataform/components/verificacion_fallida.dart';
import 'package:iclassmultiplataform/database/database_helper.dart';
import 'package:iclassmultiplataform/models/image.dart';
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:iclassmultiplataform/requests/request_helper.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class CameraPage extends StatefulWidget {
 final List<CameraDescription>? cameras;
 final VoidCallback? initializeMicrophone;
 final List<String>? listaOraciones;
 const CameraPage({this.cameras, this.initializeMicrophone, this.listaOraciones, Key? key}) : super(key: key);


 @override
 _CameraPageState createState() => _CameraPageState();
}


class _CameraPageState extends State<CameraPage> {
 late CameraController controller;
 List<String>? _listaOraciones;


 SpeechToText _speechToText = SpeechToText();
 bool _speechEnabled = false;
 String _lastWords = '';


 DBHelper dbHelper = DBHelper();
 bool iniciarExamenEnabled = true;
 bool verificacionExitosa = false;
 late Timer timer;


 @override
 void initState() {
   super.initState();


   _initSpeech();


   _listaOraciones = widget.listaOraciones;
   print("oraciones prohibidas");
   print(_listaOraciones);


   controller = CameraController(
     widget.cameras![0],
     ResolutionPreset.max,


   );
   controller.initialize().then((_) {
     if (!mounted) {
       return;
     }
     setState(() {});
   });

   timer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (iniciarExamenEnabled && controller.value.isInitialized) {
        _captureImage();
      }
    });

 }

 void _captureImage() async {
  try {
      final XFile file = await controller.takePicture();
      final Uint8List bytes = await file.readAsBytes();
      final String base64String = base64Encode(bytes);
      
      saveData(base64String);
    } catch (e) {
      print('Error al capturar la imagen: $e');
    }
 }


 void _initSpeech() async {
   _speechEnabled = await _speechToText.initialize();
   setState(() {});
 }


 void _startListening() async {
   print("Se está escuchando");
   await _speechToText.listen(onResult: _onSpeechResult, localeId: 'es_ES');
   setState(() {});
 }


 void _stopListening() async {
   await _speechToText.stop();
   setState(() {});
 }


 void _onSpeechResult(SpeechRecognitionResult result) {
   setState(() {
     _lastWords = result.recognizedWords;
     _checkWords(_lastWords);
   });
 }


 void _checkWords(String sentence) {
    if (_listaOraciones != null) {
      for (String forbiddenSentence in _listaOraciones!) {
        if (sentence.toLowerCase().contains(forbiddenSentence.toLowerCase())) {
          print('¡Advertencia! Se ha detectado una oración prohibida: $forbiddenSentence');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ForbiddenWordsPopup(forbiddenWords: [forbiddenSentence]);
            },
          );
          break;
        }
      }
    }
  }


 Future<void> iniciarExamen() async {
   final String? img = await _captureImg();
   var resultado = validarCara(img);
   if (true) {
     setState(() {
       verificacionExitosa = true;
     });
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return VerificationSuccessPopup();
       },
     );
     _startListening(); // Inicia la escucha del micrófono al pasar la verificación
   } else {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return VerificationFailedPopup(
           onRetry: () {
             // Lógica para volver a intentar la verificación
           },
         );
       },
     );
   }
 }


 Future<String?> _captureImg() async {
   try {
     final XFile file = await controller.takePicture();
     final Uint8List bytes = await file.readAsBytes();
     final String base64String = convert.base64Encode(bytes);
     return base64String;
   } catch (e) {
     print('Error al capturar la imagen: $e');
     return null;
   }
 }


 void saveData(String imagencita) {
   Imagen image = Imagen(
     nombre: "",
     imagen: imagencita,
     estado: "Guardado",
   );


   Future<Imagen> future = dbHelper.addImage(image);
   future.then((cus) {});
 }


 @override
 Widget build(BuildContext context) {
   if (!controller.value.isInitialized) {
     return const SizedBox(
       child: Center(
         child: CircularProgressIndicator(),
       ),
     );
   }
   return Scaffold(
     backgroundColor: Colors.grey[300],
     body: SafeArea(
       child: Column(
         children: [
           CameraPreview(controller),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               ElevatedButton(
                 onPressed: iniciarExamenEnabled ? iniciarExamen : null,
                 child: const Text('Iniciar Examen'),
               ),
               ElevatedButton(
                 onPressed: () {
                   setState(() {
                     iniciarExamenEnabled = true;
                     _stopListening(); // Detiene la escucha del micrófono al finalizar el examen
                   });
                 },
                 child: const Text('Finalizar Examen'),
               ),
             ],
           ),
         ],
       ),
     ),
   );
 }
}
