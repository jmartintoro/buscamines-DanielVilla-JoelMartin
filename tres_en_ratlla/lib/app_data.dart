import 'dart:math';
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  int tamany = 9; //o 15
  int bombes = 5; //o 10, 20
  bool nightmode = true;

  int flags = 0;
  String chrono = '00';

  List<List<String>> board = [];
  bool gameIsOver = false;
  bool gameWinner = false;

  void resetGame() {
    board.clear();                                                              //1r '-': hay (f) o no (-) puesta bandera
    board = List.generate(tamany, (_) => List.filled(tamany, '---'));           //2n '-': bomba (b) o numero de bombas alrededor (numero)
    randomBombs();                                                              //3r '-': destapado (s) o no (-)
    checkBombs();
    flags = 0;
    gameWinner = false;
    //printBoard(); // Agregamos esta función para imprimir el tablero
    notifyListeners(); // Notificar cambios después de resetear el juego
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
    notifyListeners(); // Notificar cambios después de colocar bombas
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
    notifyListeners(); // Notificar cambios después de verificar bombas
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
        showBombs();
        gameIsOver = true;
      }
      if (board[row][col][1] != 'b'){
        checkAround(row, col+1);  //Derecha
        checkAround(row, col-1);  //Izquierda
        checkAround(row-1, col);  //Arriba
        checkAround(row-1, col+1);  //Arriba Derecha
        checkAround(row-1, col-1);  //Arriba Izquierda
        checkAround(row+1, col);  //Abajo
        checkAround(row+1, col+1);  //Abajo Derecha
        checkAround(row+1, col-1);  //Abajo Izquierda

        checkGameWinner(); // Comprobar que no queda cap casella sense bomba per descubrir
      } 
      
      notifyListeners(); // Notificar cambios después de realizar una jugada
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

  void flagator(int row, int col) {
    if (board[row][col][2] != 's') {
      if (board[row][col][0] == "f") {
        board[row][col] = '-${board[row][col][1]}${board[row][col][2]}';
        flags--;
      } else if (board[row][col][0] == "-") {
        board[row][col] = 'f${board[row][col][1]}${board[row][col][2]}';
        flags++;
      }
      notifyListeners();
    }
  }

  void updateChrono(String newChrono) {
    chrono = newChrono;
    notifyListeners();
  }

  void checkAround(int row, int col) {
    if (row < 0 || row >= tamany || col < 0 || col >= tamany || board[row][col][2] == 's' || board[row][col][0] != '-') {
        return;  // No hagas nada si la casilla ya se reveló o está fuera de los límites o no contiene un '0'
    }

    if (board[row][col][1] == '0') {
      board[row][col] = '${board[row][col][0]}${board[row][col][1]}s';

      if (!(col+1>=tamany)) {
        checkAround(row, col + 1);
      }

      if (!(col-1<0)) {
        checkAround(row, col - 1);
      }

      if (!(row+1>=tamany)) {
        checkAround(row+1, col);
      }

      if (!(row-1<0)) {
        checkAround(row-1, col);
      }
    }
    return;
  }


  // Comprova si el jugador a obert totes les caselles no bomba
  void checkGameWinner() {
    int totalCaselles = tamany*tamany-bombes;
    int contadorCaselles = 0;
    for (int fila = 0; fila < tamany; fila++) {
      for (int casilla = 0; casilla < tamany; casilla++) {
        if (board[fila][casilla][1] != 'b' && board[fila][casilla][2] == 's'){
          contadorCaselles +=1;
        }
      }
    } 
    if (contadorCaselles == totalCaselles) {
      gameWinner = true;
    }
  }
}
