import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cupertino_base/widget_tresratlla_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppData with ChangeNotifier {
  // App status
  String colorPlayer = "Verd";
  String colorOpponent = "Taronja";
  int tamany = 9; //o 15
  int bombes = 5; //o 10, 20

  List<List<String>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-';

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;

  void resetGame() {
    board.clear();                                                              //1r '-': hay (f) o no (-) puesta bandera
    board = List.generate(tamany, (_) => List.filled(tamany, '---'));           //2n '-': bomba (b) o numero de bombas alrededor (numero)
    randomBombs();                                                              //3r '-': destapado (s) o no (-)
    checkBombs();
    printBoard(); // Agregamos esta función para imprimir el tablero
  }

  // Generar bombas de manera aleatoria
  void randomBombs() {
    final Random r = Random();
    for (int b = 0; b < bombes; b++) {
      int fila, casilla;
      do {
        fila = r.nextInt(tamany);
        casilla = r.nextInt(tamany);
      } while (board[fila][casilla][1] == 'b');
      board[fila][casilla] ='${board[fila][casilla][0]}b${board[fila][casilla][2]}';
    }
  }

  // Verificar bombas alrededor de cada casilla
  void checkBombs() {
    for (int fila = 0; fila < tamany; fila++) {
      for (int casilla = 0; casilla < tamany; casilla++) {
        if (board[fila][casilla][1] != 'b') {
          int numBombes = 0;
          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              if (i == 0 && j == 0) continue; // Ignorar la casilla actual
              int nuevaFila = fila + i;
              int nuevaCasilla = casilla + j;
              if (nuevaFila >= 0 &&
                  nuevaFila < tamany &&
                  nuevaCasilla >= 0 &&
                  nuevaCasilla < tamany) {
                if (board[nuevaFila][nuevaCasilla][1] == 'b') {
                  numBombes++;
                }
              }
            }
          }
          board[fila][casilla] = '${board[fila][casilla][0]}$numBombes${board[fila][casilla][2]}';
        }
      }
    }
  }

  void printBoard() {
    for (int fila = 0; fila < tamany; fila++) {
      print(board[fila]);
    }
  }

  // Fa una jugada, primer el jugador després la maquina
  void playMove(int row, int col) {
    if (board[row][col][2] == '-') {
      board[row][col] = '${board[row][col][0]}${board[row][col][1]}s';
      if (board[row][col][1] == 'b'){
        // funcion que destape todas las bombas 
        showBombs();
        // llamar funcion game over
        gameIsOver = true;
      }
      if (board[row][col][1] != 'b'){
        checkAround(row, col);
      } //////////////// No esta bien implementado
      //checkGameWinner();
    }
  }

  void showBombs() {
    for (int fila = 0; fila < tamany; fila++) {
      for (int casilla = 0; casilla < tamany; casilla++) {
        if (board[fila][casilla][1] == 'b') {
          board[fila][casilla] = '${board[fila][casilla][0]}${board[fila][casilla][1]}s';
        } else if (board[fila][casilla][2] != 's') {
          board[fila][casilla] = '${board[fila][casilla][0]} s';
        }
      }
    }
  }

  void checkAround(int row, int col) {
    if (row < 0 || row >= tamany || col < 0 || col >= tamany || board[row][col][1] == 's' || board[row][col][0] != '0') {
        return;  // No hagas nada si la casilla ya se reveló o está fuera de los límites o no contiene un '0'
    }

    board[row][col] = '${board[row][col][0]}${board[row][col][1]}s';

    // Llamar recursivamente a las casillas adyacentes
    print('checkAround(row - 1, col);');
    checkAround(row - 1, col);
    print('checkAround(row + 1, col);');
    checkAround(row + 1, col);
    print('checkAround(row, col - 1);');
    checkAround(row, col - 1);
    print('checkAround(row, col + 1);');
    checkAround(row, col + 1);
  }


  // Comprova si el joc ja té un tres en ratlla
  // No comprova la situació d'empat
  void checkGameWinner() {
    for (int i = 0; i < 4; i++) {
      // Comprovar files
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '-') {
        gameIsOver = true;
        gameWinner = board[i][0];
        return;
      }

      // Comprovar columnes
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '-') {
        gameIsOver = true;
        gameWinner = board[0][i];
        return;
      }
    }

    // Comprovar diagonal principal
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '-') {
      gameIsOver = true;
      gameWinner = board[0][0];
      return;
    }

    // Comprovar diagonal secundària
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '-') {
      gameIsOver = true;
      gameWinner = board[0][2];
      return;
    }

    // No hi ha guanyador, torna '-'
    gameWinner = '-';
  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpPlayer = Image.asset('assets/images/player.png');
    Image tmpOpponent = Image.asset('assets/images/opponent.png');

    // Carrega les imatges
    if (context.mounted) {
      imagePlayer = await convertWidgetToUiImage(tmpPlayer);
    }
    if (context.mounted) {
      imageOpponent = await convertWidgetToUiImage(tmpOpponent);
    }

    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );
    return completer.future;
  }
}
