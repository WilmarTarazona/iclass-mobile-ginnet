import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

Future<String?> validarCara(String? data) async {
  var url = Uri.parse('http://192.168.86.157:5002/verificacion');
    try {
      var response = await http.post(url, 
      headers: {'Content-Type': 'application/json'}, 
      body: convert.jsonEncode({'imagen': data}));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['estado_validacion']) {
          return jsonResponse['resultados'];
        } else {
          return jsonResponse['resultados'];
        }
      } else {
        print('La solicitud falló con el estado: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
}