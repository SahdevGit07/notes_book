import 'package:flutter/material.dart';
import 'package:notes_book/Screen/SqFlite/database_helper.dart';
import 'package:notes_book/Screen/splas_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // intialized  database.
 await DatabaseHelper.dbHelper();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}
