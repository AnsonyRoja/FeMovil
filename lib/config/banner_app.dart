import 'package:flutter/material.dart';


class CirclePainter extends CustomPainter {

  @override

  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1) // Color blanco transparente
      ..style = PaintingStyle.fill;

    final bluePaint = Paint()
      ..color = const Color(0xFF7531FF) // Color azul sólido
      ..style = PaintingStyle.fill; // Estilo de relleno


    final centerY1 = size.height / 2;

  
    // Dibujar círculos blancos
    canvas.drawCircle(Offset(380, centerY1), 150, paint);
    canvas.drawCircle(const Offset(50, 170), 120, paint);

    // Dibujar círculos azules dentro de los círculos blancos
    canvas.drawCircle(Offset(380, centerY1), 120, bluePaint); // Círculo azul dentro del primer círculo blanco
    canvas.drawCircle(const Offset(50, 170), 90, bluePaint); // Círculo azul dentro del segundo círculo blanco
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}