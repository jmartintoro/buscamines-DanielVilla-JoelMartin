import 'package:cupertino_base/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'widget_tresratlla.dart';

class LayoutPlay extends StatefulWidget {
  const LayoutPlay({Key? key}) : super(key: key);

  @override
  LayoutPlayState createState() => LayoutPlayState();
}

class LayoutPlayState extends State<LayoutPlay> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${appData.bombes}',
              style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 0, 0)),),
            Text(
              'Partida',
              style: TextStyle(fontSize: 25, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            
          ],
        ),
        leading: CupertinoNavigationBarBackButton(
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
