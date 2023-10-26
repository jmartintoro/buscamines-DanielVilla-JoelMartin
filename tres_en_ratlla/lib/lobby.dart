import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_data.dart';

class Lobby extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Lobby> {

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
    
    return CupertinoPageScaffold(
      backgroundColor: appData.nightmode ? const Color.fromARGB(255, 19, 19, 19) : const Color.fromARGB(255, 234, 234, 234),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: appData.nightmode ? const Color.fromARGB(14, 255, 255, 255) : CupertinoColors.white,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(appData.nightmode ? CupertinoIcons.moon_stars_fill : CupertinoIcons.moon, size: 28, color: appData.nightmode ? CupertinoColors.white : CupertinoColors.activeBlue,),
          onPressed: () {
            setState(() {
              appData.nightmode = !appData.nightmode;
            });
          },
        ),
        middle: Text(
          'Buscaminas',
          style: TextStyle(fontSize: 25, color: appData.nightmode ? CupertinoColors.white : CupertinoColors.black),
        ),
        trailing: GestureDetector(
          onTap: () {
            _options(context);
          },
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.gear_alt, size: 28, color: appData.nightmode ? CupertinoColors.white : CupertinoColors.activeBlue),
            onPressed: () {
              _options(context);
            },
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _centerLobby(context),
          SizedBox(height: 50),
          Container(
            height: 10,
            child: Text(
              'Daniel Villa & Joel Martín',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w100,
                color: appData.nightmode ? CupertinoColors.white.withOpacity(0.7) : CupertinoColors.black.withOpacity(0.7)
              ),
            ),
          )
        ],
      ),
    );
  }

  Center _centerLobby(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/images/mine_icon.svg", height: 100, width: 100, color: appData.nightmode ? CupertinoColors.white : CupertinoColors.black,),
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
            decoration: BoxDecoration(
                color: appData.nightmode ? CupertinoColors.activeBlue : CupertinoColors.activeGreen,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: appData.nightmode ? CupertinoColors.activeBlue.withOpacity(0.51) : CupertinoColors.activeGreen.withOpacity(0.51),
                      blurRadius: 10,
                      spreadRadius: 0.0)
                ]),
            child: Text(
              'START',
              style: TextStyle(color: CupertinoColors.white),
            ),
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
