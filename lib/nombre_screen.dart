import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'loading_screen.dart';

class NombreScreen extends StatefulWidget {
  @override
  _NombreScreenState createState() => _NombreScreenState();
}

class _NombreScreenState extends State<NombreScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isAnimationCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresa tu apodo'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_isAnimationCompleted)
                Lottie.asset(
                  'assets/lottie/brilloHN.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  onLoaded: (composition) {
                    // Desvanece la animación después de que termine.
                    Future.delayed(composition.duration, () {
                      setState(() {
                        _isAnimationCompleted = true;
                      });
                    });
                  },
                ),
              // Usamos AnimatedOpacity para mostrar el formulario con un desvanecimiento
              AnimatedOpacity(
                opacity: _isAnimationCompleted ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: _isAnimationCompleted
                    ? Column(
                        children: [
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: 'Tu apodo',
                              labelStyle: TextStyle(color: Colors.green),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.yellow, width: 2.0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              String nombre = _controller.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoadingScreen(nombre: nombre),
                                ),
                              );
                            },
                            child: Text('Comenzar Juego'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        Text('Aprende viendo, aprende jugando'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                          ),
                                          child: Image.asset(
                                            'assets/energia.jpg',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Aprende viendo, aprende jugando: Esta aplicación está diseñada para promover el conocimiento sobre eficiencia energética entre los Hondureños.',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cerrar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Acerca de'),
                          ),
                        ],
                      )
                    : Container(), // Oculta el formulario si la animación aún no ha terminado
              ),
            ],
          ),
        ),
      ),
    );
  }
}
