import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'dart:math';
import 'puntaje_screen.dart';

class QuizScreen extends StatefulWidget {
  final String nombre;
  final List<Map<String, dynamic>> questions;

  QuizScreen({required this.nombre, required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> answers = [];
  bool isLoading = true;
  List<Map<String, dynamic>> availableQuestions = [];

  @override
  void initState() {
    super.initState();
    availableQuestions = List.from(widget.questions);

    // Seleccionar aleatoriamente 10 preguntas si hay más de 10 disponibles
    if (availableQuestions.length > 10) {
      availableQuestions.shuffle();
      availableQuestions = availableQuestions.take(10).toList();
    }

    _showLoading();
  }

  void _showLoading() {
    setState(() {
      isLoading = true;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _answerQuestion(String answer) {
    var question = availableQuestions[currentQuestionIndex];
    var correctAnswer = question['Respuesta'];

    answers.add({
      'Pregunta': question['Pregunta'],
      'Seleccionada': answer,
      'Correcta': correctAnswer,
      'options': question
    });

    if (answer == correctAnswer) {
      setState(() {
        score++;
      });
    }

    // Eliminar la pregunta actual de la lista de preguntas disponibles
    availableQuestions.removeAt(currentQuestionIndex);

    if (availableQuestions.isNotEmpty) {
      setState(() {
        // Seleccionar un nuevo índice de pregunta si aún quedan preguntas
        currentQuestionIndex = Random().nextInt(availableQuestions.length);
      });
      _showLoading();
    } else {
      // Si no quedan preguntas, ir a la pantalla de puntaje
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PuntajeScreen(
              nombre: widget.nombre, score: score, answers: answers),
        ),
      );
    }
  }

  Widget _getRandomBackgroundAnimation(double screenWidth) {
    int bgIndex = (currentQuestionIndex % 4) + 1;
    Random random = Random();
    double left = random.nextDouble() * (screenWidth - 100);
    double top =
        random.nextDouble() * (MediaQuery.of(context).size.height - 100);

    // Ajuste dinámico del tamaño de la animación según el ancho de la pantalla
    double animationSize = screenWidth * 0.3;

    return Positioned(
      left: left,
      top: top,
      child: Lottie.asset(
        'assets/lottie/quiz_background$bgIndex.json',
        width: animationSize,
        height: animationSize,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 100)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var question = availableQuestions[currentQuestionIndex];
                var options = Map.of(question)
                  ..remove('Pregunta')
                  ..remove('Respuesta');

                return Stack(
                  children: <Widget>[
                    if (!isLoading)
                      _getRandomBackgroundAnimation(constraints.maxWidth),
                    if (isLoading)
                      Center(
                        child: Lottie.asset(
                          'assets/lottie/loading.json',
                          width: constraints.maxWidth * 0.4,
                          height: constraints.maxHeight * 0.4,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  'Pregunta ${widget.questions.length - availableQuestions.length + 1}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                              SizedBox(height: 20),
                              Text(question['Pregunta'],
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green),
                                  textAlign: TextAlign.center),
                              SizedBox(height: 20),
                              for (var optionKey in options.keys)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () => _answerQuestion(optionKey),
                                    child: Text(options[optionKey]),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
