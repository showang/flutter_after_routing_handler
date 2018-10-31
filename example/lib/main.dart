import 'package:example/sub_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) => Scaffold(
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
      );
}
