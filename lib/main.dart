import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'nombre_screen.dart';
import 'firebase_options.dart'; // Asegúrate de tener este archivo si usas FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrilloHN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NombreScreen(),
    );
  }
}
