import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'widget_tresratlla_painter.dart';

class WidgetTresRatlla extends StatefulWidget {
  const WidgetTresRatlla({Key? key}) : super(key: key);

  @override
  WidgetTresRatllaState createState() => WidgetTresRatllaState();
}

class WidgetTresRatllaState extends State<WidgetTresRatlla> {

  // Al iniciar el widget, carrega les imatges
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppData appData = Provider.of<AppData>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final int row =
            (details.localPosition.dy / (context.size!.height / appData.tamany)).floor();
        final int col =
            (details.localPosition.dx / (context.size!.width / appData.tamany)).floor(); 
        if (appData.board[row][col][0] != "f") {
          appData.playMove(row, col);
        }
        setState(() {}); // Actualitza la vista
      },
      onDoubleTapDown: (TapDownDetails details) {
        final int row = (details.localPosition.dy  / (context.size!.height / appData.tamany)).floor();
        final int col = (details.localPosition.dx  / (context.size!.width / appData.tamany)).floor();
        appData.flagator(row, col);
        setState(() {}); // Actualitza la vista
      },
      child: SizedBox(
        width: MediaQuery.of(context)
            .size
            .width, // Ocupa tot l'ample de la pantalla
        height: MediaQuery.of(context).size.height -
            56.0, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
        child: CustomPaint(
          painter: WidgetTresRatllaPainter(appData),
        ),
      )
    );
  }
}