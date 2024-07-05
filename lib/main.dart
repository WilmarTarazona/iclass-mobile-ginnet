import 'pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:iclassmultiplataform/database/database_helper.dart';

void main() async{
  runApp(const MyApp());

  DBHelper db = DBHelper();
  try {
    await db.initDatabase();
  } catch (e) {
    print('Error initializing database: $e');
  }
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
