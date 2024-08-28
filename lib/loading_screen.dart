import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lottie/lottie.dart';
import 'quiz_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String nombre;

  LoadingScreen({required this.nombre});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('questions');
  late Future<List<Map<String, dynamic>>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _loadQuestions();
  }

  Future<List<Map<String, dynamic>>> _loadQuestions() async {
    List<Map<String, dynamic>> questions;
    try {
      // Intenta obtener datos de Firebase Realtime Database
      DatabaseEvent event = await _database.once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> questionsMap =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        questions = questionsMap.entries
            .map((entry) => entry.value.first as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('No hay datos en Firebase');
      }
    } catch (e) {
      // Si hay un error, cargar datos del archivo local JSON
      final String response =
          await rootBundle.loadString('assets/preguntas.json');
      final data = await json.decode(response);
      questions = (data as Map<String, dynamic>)
          .entries
          .map((entry) => entry.value.first as Map<String, dynamic>)
          .toList();
    }

    questions
        .shuffle(); // Mezclar las preguntas para mostrar en orden aleatorio
    questions = questions.take(20).toList(); // Tomar solo 20 preguntas

    // Navegar a la pantalla de preguntas con los datos cargados
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              QuizScreen(nombre: widget.nombre, questions: questions)),
    );

    return questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset('assets/lottie/loading.json'),
            SizedBox(height: 20),
            Text('Cargando Preguntas...', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
