import 'package:example/sub_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var route = CupertinoPageRoute(builder: (_) => null);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Audio(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Example"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (_) => SubPage())),
                child: Text("Open sub page normaly."),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) => SubPage(
                          pageTransitionDuration: route.transitionDuration,
                        ))),
                child: Text("Open sub page with handler."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
