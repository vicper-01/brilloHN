import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'respuesta_correcta.dart';

class PuntajeScreen extends StatefulWidget {
  final String nombre;
  final int score;
  final List<Map<String, dynamic>> answers;

  PuntajeScreen(
      {required this.nombre, required this.score, required this.answers});

  @override
  _PuntajeScreenState createState() => _PuntajeScreenState();
}

class _PuntajeScreenState extends State<PuntajeScreen> {
  final CollectionReference _puntajesCollection =
      FirebaseFirestore.instance.collection('puntajes');
  late Future<void> _saveScoreFuture;
  late Future<List<Map<String, dynamic>>> _scoresFuture;

  @override
  void initState() {
    super.initState();
    _saveScoreFuture = _saveScore();
    _scoresFuture = _loadScores();
  }

  Future<void> _saveScore() async {
    await _puntajesCollection.doc(widget.nombre).set({
      'puntaje': widget.score,
    });
  }

  Future<List<Map<String, dynamic>>> _loadScores() async {
    QuerySnapshot querySnapshot = await _puntajesCollection.get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        'nombre': doc.id,
        'puntaje': data['puntaje'],
      };
    }).toList();
  }

  void _showAnswers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RespuestaCorrectaScreen(answers: widget.answers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puntajes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.question_answer),
            onPressed: _showAnswers,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _saveScoreFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('assets/lottie/loading.json'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset('assets/lottie/error.json'),
                  SizedBox(height: 20),
                  Text('Error al guardar el puntaje: ${snapshot.error}'),
                ],
              ),
            );
          } else {
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _scoresFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset('assets/lottie/loading.json'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Lottie.asset('assets/lottie/error.json'),
                        SizedBox(height: 20),
                        Text('Error al cargar los puntajes: ${snapshot.error}'),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No hay puntajes disponibles'),
                  );
                } else {
                  var scores = snapshot.data!;
                  scores.sort((a, b) => b['puntaje'].compareTo(a['puntaje']));
                  return ListView.builder(
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      var score = scores[index];
                      return ListTile(
                        title: Text(score['nombre']),
                        trailing: Text(score['puntaje'].toString()),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
