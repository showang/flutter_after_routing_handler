import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

import 'package:after_routing_handler/after_routing_handler.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('Fetched data before routing finished.', () async {
    var pageState = MockState();
    when(pageState.mounted).thenReturn(true);
    var routeDuration =
        CupertinoPageRoute(builder: (context) {}).transitionDuration;
    var startTime = DateTime.now().millisecondsSinceEpoch;
    print("start at: $startTime\n");
    var successCallback = expectAsync1<void, bool>((data) {
      var now = DateTime.now().millisecondsSinceEpoch;
      print(
          " now: $now\n start: $startTime\n duration: ${routeDuration.inMilliseconds}");
      assert(now >= startTime + routeDuration.inMilliseconds);
    }, count: 1);
    AfterRoutingHandler(pageState: pageState, duration: routeDuration)
      ..apiUpdate(
        fetchData: true,
        apiFuture: apiFuture(true, 100),
        apiErrorCallback: () {
          assert(false);
        },
        updateDataDelegate: successCallback,
      );
  });
  test('Fetched data after routing finished.', () {
    var pageState = MockState();
    when(pageState.mounted).thenReturn(true);
    var routeDuration =
        CupertinoPageRoute(builder: (context) {}).transitionDuration;
    var startTime = DateTime.now();
    var callback = expectAsync1<void, bool>((data) {
      assert(DateTime.now().millisecondsSinceEpoch >=
          startTime.millisecondsSinceEpoch + routeDuration.inMilliseconds);
    }, count: 1);
    AfterRoutingHandler(pageState: pageState, duration: routeDuration)
      ..apiUpdate(
        fetchData: true,
        apiFuture: apiFuture(true, 500),
        apiErrorCallback: () {
          assert(false);
        },
        updateDataDelegate: callback,
      );
  });
}

Future<bool> apiFuture(bool out, int duration) async {
  sleep(const Duration(milliseconds: 100));
  return out;
}

class MockState extends Mock implements State<StatefulWidget> {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return "";
  }
}
