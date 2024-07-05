import 'dart:io';
import 'package:path/path.dart';
import 'dart:convert' as convert;
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:iclassmultiplataform/models/image.dart';

class DBHelper {
  static Database? _database;
  static const String TABLE_IMAGE = "Image";

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory docdir = await getApplicationDocumentsDirectory();
    String path = join(docdir.path, 'app.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $TABLE_IMAGE '
        '(id INTEGER PRIMARY KEY '
        'AUTOINCREMENT,'
        ' nombre TEXT,'
        ' imagen TEXT,'
        ' estado TEXT'
        ')');
  }

  Future<bool> fetchData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient!.query(TABLE_IMAGE,
    columns: ['id', 'nombre', 'estado'],
    where: 'estado = ?',
    whereArgs: ['Analizado']);
    if (result.isNotEmpty) return true;
    return false;
  }

  
  Future<Imagen> addImage(Imagen image) async {
    var dbClient = await db;
    image.id = await dbClient!.insert(TABLE_IMAGE, image.toJson());
    enviarDatos(image.id, image.imagen);
    return image;
  }

  Future<void> updateImage(int? id, Map<String, dynamic> newData) async {
    // Estados
    var dbClient = await db;
    int count = await dbClient!.update(TABLE_IMAGE, 
    newData,
    where: 'id = ?',
    whereArgs: [id]);
    // print(count);
  }

  Future<void> deleteImage(int? id) async {
    var dbClient = await db;
    int count = await dbClient!.delete(TABLE_IMAGE, 
    where: 'id = ?', 
    whereArgs: [id]);
    print(count);
  }

  Future<void> enviarDatos(int? id, String? imagenBase64) async {
    var url = Uri.parse('http://192.168.86.157:5002/imagen');
    var data = {
      'id': id,
      'imagen': imagenBase64,
    };
    var jsonData = convert.jsonEncode(data);
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );
      updateImage(id, {'estado': "Enviado"});
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        updateImage(id, {'nombre': jsonResponse['evento'],
                        'estado': "Analizado"});
        print('Respuesta de la API: ${jsonResponse['resultados']}');
      } else {
        print('La solicitud falló con el estado: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
  }

  Future close() async {
    var dbClient = await db;
    dbClient?.close();
  }
}