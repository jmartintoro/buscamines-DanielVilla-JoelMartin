import 'dart:async';
import 'package:buscaminas/app_data.dart';
import 'package:buscaminas/widget_tresratlla.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LayoutPlay extends StatefulWidget {
  const LayoutPlay({Key? key}) : super(key: key);

  @override
  _LayoutPlayState createState() => _LayoutPlayState();
}

class _LayoutPlayState extends State<LayoutPlay> {
  late Timer _timer;
  String chrono = '00';

  @override
  void initState() {
    super.initState();

    final appData = context.read<AppData>(); // Usar context.read para acceder a AppData

    // Iniciar el cronómetro
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!appData.gameIsOver && !appData.gameWinner) {
        // Incrementar el tiempo en un segundo
        int seconds = int.parse(chrono) + 1;
        setState(() {
          chrono = seconds.toString().padLeft(2, '0');
        });

        // Actualizar la variable 'chrono' en AppData
        appData.updateChrono(chrono);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Detener el cronómetro al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();

    return CupertinoPageScaffold(
      backgroundColor: appData.nightmode ? Color.fromARGB(255, 59, 59, 59) : CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: appData.nightmode ? Color.fromARGB(27, 0, 0, 0) : CupertinoColors.white,
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${appData.bombes - appData.flags}   ',
              style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 0, 0)),
            ),
            SizedBox(width: 70,),
            Text(
              '   ${chrono}\'',
              style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 120, 220, 25)),
            ),
          ],
        ),
        leading: CupertinoNavigationBarBackButton(
          color: appData.nightmode ? CupertinoColors.white : CupertinoColors.activeBlue,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: const SafeArea(
        child: WidgetTresRatlla(),
      ),
    );
  }
}
