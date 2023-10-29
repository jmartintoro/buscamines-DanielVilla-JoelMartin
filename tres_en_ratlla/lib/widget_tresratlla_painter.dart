import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'package:flutter_svg/flutter_svg.dart';
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;

  WidgetTresRatllaPainter(this.appData);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = appData.nightmode ? const ui.Color.fromARGB(222, 255, 255, 255) : Colors.black
      ..strokeWidth = 5.0;

    // Definim els punts on es creuaran les línies verticals y horitzontals
    for (int l = 1; l < appData.tamany; l++) {
      final double lineaHorizontal = l * size.height / appData.tamany;
      final double lineaVertical = l * size.width / appData.tamany;
      //Dibuixem les linees
      canvas.drawLine(Offset(0, lineaHorizontal),
          Offset(size.width, lineaHorizontal), paint);
      canvas.drawLine(
          Offset(lineaVertical, 0), Offset(lineaVertical, size.height), paint);
    }
  }

  // Dibuia una creu centrada a una casella del taulell
  void drawNumber(Canvas canvas, double x, double y, String number, Color color,
      double strokeWidth, Size s) {
    
    TextSpan span = TextSpan(
      text: number.toString(),
      style: TextStyle(
        color: color,
        fontSize: s.height/25,        // Tamaño del número
        fontWeight: FontWeight.bold,
      ),
    );

    TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    tp.layout();
    tp.paint(canvas, Offset(x - tp.width/2, y - tp.height-5));
  }

  // Dibuixa un cercle centrat a una casella del taulell
  void drawBomb(Canvas canvas, double x, double y, double radius, Color color,
      double strokeWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(Offset(x, y), radius, paint);
    canvas.drawCircle(Offset(x, y), radius / 2, paint2);
  }

  //Dibuixa bandera
  void drawBandera(Canvas canvas, double x, double y, double width,
      double height, Color color, double strokeWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    final flagHeight = height * 0.6;
    final flagWidth = width * 0.6;

    // Dibuja el asta de la bandera
    canvas.drawLine(Offset(x, y), Offset(x, y + flagHeight), paint);

    // Dibuja el cuerpo de la bandera
    final flagPath = Path()
      ..moveTo(x, y)
      ..lineTo(x + flagWidth/2, y)
      ..lineTo(x, y + flagHeight/2)
      ..lineTo(x - flagWidth/2, y)
      ..lineTo(x, y+ flagHeight/2)
      ..close();

    canvas.drawPath(flagPath, paint2);
  }

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    // Dibuixar 'X' i 'O' del tauler
    double cellWidth = size.width / appData.tamany;
    double cellHeight = size.height / appData.tamany;

    for (int i = 0; i < appData.tamany; i++) {
      for (int j = 0; j < appData.tamany; j++) {
        if (appData.board[i][j][0] != '1' && appData.board[i][j][1] != 'b' && appData.board[i][j][2] != '-') {
          // Dibuixar una X amb el color del jugador
          Color color = Colors.blue;

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0);

          drawNumber(canvas, cX, cY, appData.board[i][j][1], color, 5.0, size);
        } else if (appData.board[i][j][0] != '1' &&
            appData.board[i][j][1] == 'b' && appData.board[i][j][2] != '-') {
          // Dibuixar bomba
          Color color = Colors.red;

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0) / 2;
          double radius = (min(cellWidth, cellHeight) / 2) - 5;

          drawBomb(canvas, cX, cY, radius, color, 5.0);
        } else if (appData.board[i][j][0] == 'f' && appData.board[i][j][2] == '-') {
          Color color = Colors.red;

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0) / 5;

          drawBandera(canvas, cX, cY, cellWidth/1.5, cellHeight ,color, 5.0);
        }
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawMessage(Canvas canvas, Size size) {
    
    String message = '';
    if (appData.gameIsOver) {
      message = 'Has EXPLOTAT!';
    } else {
      message = 'Has GUANYAT!'; 
    }
    

    TextStyle textStyle = TextStyle(
      color: appData.nightmode ? Colors.white : Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = appData.nightmode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }

  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    if (appData.gameIsOver || appData.gameWinner) {
      drawMessage(canvas, size);
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
