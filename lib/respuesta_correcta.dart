import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class RespuestaCorrectaScreen extends StatelessWidget {
  final List<Map<String, dynamic>> answers;

  RespuestaCorrectaScreen({required this.answers});

  Widget _getRandomBackgroundAnimation(BuildContext context) {
    Random random = Random();
    double left =
        random.nextDouble() * (MediaQuery.of(context).size.width - 100);
    double top =
        random.nextDouble() * (MediaQuery.of(context).size.height - 100);
    return Positioned(
      left: left,
      top: top,
      child: Lottie.asset(
        'assets/lottie/quiz_background1.json',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respuestas Correctas'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          _getRandomBackgroundAnimation(context),
          ListView.builder(
            itemCount: answers.length,
            itemBuilder: (context, index) {
              var answer = answers[index];
              var opciones = Map.of(answer['options']);
              opciones.remove('Pregunta');
              opciones.remove('Respuesta');

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Pregunta: ${answer['Pregunta']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        SizedBox(height: 10),
                        for (var optionKey in opciones.keys)
                          Text('${optionKey}. ${opciones[optionKey]}',
                              style: TextStyle(color: Colors.green)),
                        SizedBox(height: 10),
                        Text('Seleccionada: ${answer['Seleccionada']}',
                            style: TextStyle(color: Colors.yellow)),
                        Text('Correcta: ${answer['Correcta']}',
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
