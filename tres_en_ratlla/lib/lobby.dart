import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_data.dart';

class Lobby extends StatelessWidget {
  const Lobby({super.key});

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    return CupertinoPageScaffold(
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color.fromARGB(14, 255, 255, 255),
        middle: Text(
          'Buscaminas',
          style: TextStyle(fontSize: 25, color: CupertinoColors.white),
        ),
        trailing: GestureDetector(
          onTap: () {
            _options(context);
          },
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.gear_alt, size: 28, color: CupertinoColors.white),
            onPressed: () {
              _options(context);
            },
          ),
        ),
      ),
      child: _centerLobby(context),
    );
  }

  Center _centerLobby(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/images/mine_icon.svg", height: 100, width: 100, color: CupertinoColors.white,),
        SizedBox(height: 25),
        GestureDetector(
          onTap: () {
            appData.resetGame();
                appData.gameIsOver = false;
                Navigator.of(context).pushNamed('play');
          },
          child: Container(
            alignment: Alignment.center,
            width: 100,
            height: 50,
            child: Text(
              'START',
              style: TextStyle(color: CupertinoColors.white),
            ),
            decoration: BoxDecoration(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color:
                          Color.fromARGB(255, 26, 146, 155).withOpacity(0.51),
                      blurRadius: 10,
                      spreadRadius: 0.0)
                ]),
          ),
        )
      ],
    ));
  }

  void _options(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Opcions'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Taulell'),
              onPressed: () {
                Navigator.pop(context); // Cierra el popup de opciones
                _mostrarDialogTaulell(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Numero de Bombes'),
              onPressed: () {
                Navigator.pop(context); // Cierra el popup de opciones
                _mostrarDialogBombes(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<dynamic> _mostrarDialogBombes(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    return showCupertinoDialog(
        context: context, 
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Selecciona el numero de bombes'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('5'),
                onPressed:() {
                  appData.bombes = 5;
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('10'),
                onPressed: () {
                  appData.bombes = 10;
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('20'),
                onPressed: () {
                  appData.bombes = 20;
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        })
      ;
  }

  void _mostrarDialogTaulell(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Selecciona el tamany del taulell'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                // Lógica para manejar la opción 5x5
                appData.tamany = 9;
                Navigator.of(context).pop();
              },
              child: Text('Petit'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                appData.tamany = 15;
                Navigator.of(context).pop();
              },
              child: Text('Gran'),
            ),
          ],
        );
      },
    );
  }
}
