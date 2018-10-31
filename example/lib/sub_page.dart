import 'package:flutter/material.dart';
import 'package:after_routing_handler/after_routing_handler.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';

class SubPage extends StatefulWidget {
  final Duration pageTransitionDuration;

  SubPage({this.pageTransitionDuration});

  @override
  State<StatefulWidget> createState() => pageTransitionDuration == null
      ? SubPageState()
      : SubPageWithHandlerState();
}

class SubPageState extends State<SubPage> {
  List<String> urlList = [];

  @override
  Widget build(BuildContext context) {
    if (urlList.isEmpty) {
      imageUrlFuture().then((urls) {
        setState(() => urlList = urls..addAll(urlList));
      }).catchError((error) {});
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Page (Normal)"),
      ),
      body: buildGridView(urlList),
    );
  }
}

class SubPageWithHandlerState extends State<SubPage> {
  List<String> urlList = [];

  @override
  Widget build(BuildContext context) {
    AfterRoutingHandler(this, transitionDuration: widget.pageTransitionDuration)
      ..scheduleFuture(imageUrlFuture(),
          shouldInvoke: urlList.isEmpty,
          errorCallback: (error) {},
          successDelegate: (urls) =>
              setState(() => urlList = urls..addAll(urlList)));

    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Page (with Handler)"),
      ),
      body: buildGridView(urlList),
    );
  }
}

Widget buildGridView(List<String> urlList) => urlList.isEmpty
    ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    : GridView.builder(
        itemCount: urlList.length,
        gridDelegate:
            SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200.0),
        itemBuilder: (context, index) => FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: urlList[index],
            ));

Future<List<String>> imageUrlFuture() async {
  sleep(Duration(milliseconds: Random().nextInt(50)));
  return List.generate(
      100,
      (index) =>
          "http://placekitten.com/g/${Random().nextInt(200).toString()}");
}
