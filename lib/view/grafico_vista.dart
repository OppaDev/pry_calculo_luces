import 'package:flutter/material.dart';

class GraficoVista extends StatelessWidget {
  final Map<String, dynamic> resultado;

  GraficoVista({required this.resultado});

  @override
  Widget build(BuildContext context) {
    List<Map<String, double>> puntos = List<Map<String, double>>.from(
      resultado['puntos'],
    );
    double ancho = puntos.isNotEmpty ? puntos.last['x']! * 2 : 0;
    double alto = puntos.isNotEmpty ? puntos.last['y']! * 2 : 0;

    return Scaffold(
      appBar: AppBar(title: Text("Distribución de Luces")),
      body: Center(
        child: CustomPaint(
          size: Size(ancho, alto),
          painter: LucesPainter(puntos),
        ),
      ),
    );
  }
}

class LucesPainter extends CustomPainter {
  final List<Map<String, double>> puntos;

  LucesPainter(this.puntos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

    final rectPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Dibujar el rectángulo
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), rectPaint);

    // Dibujar los puntos
    for (var punto in puntos) {
      canvas.drawCircle(Offset(punto['x']!, punto['y']!), 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
