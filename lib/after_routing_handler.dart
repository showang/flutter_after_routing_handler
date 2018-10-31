import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class AfterRoutingHandler {
  State currentState;
  bool _animationEnd = false;

  Map<Function(dynamic), dynamic> _callbackFuncDataMap = {};

  List<Function> _taskCallbackList = [];

  Map<Future<dynamic>, Tuple2<ValueSetter<dynamic>, void Function(dynamic)>>
      _pendingFuture = {};

  bool get _unmounted => !currentState.mounted;

  AfterRoutingHandler(
    this.currentState, {
    Duration transitionDuration = const Duration(),
  }) {
    Timer(Duration(milliseconds: transitionDuration.inMilliseconds + 50), () {
      _animationEnd = true;
      if (_unmounted) return;
      if (_callbackFuncDataMap.isNotEmpty) {
        _callbackFuncDataMap.forEach((func, data) => func(data));
      }
      if (_taskCallbackList.isNotEmpty) {
        _taskCallbackList.forEach((func) => func());
      }
      if (_pendingFuture.isNotEmpty) {
        _pendingFuture.forEach((future, callbacks) {
          future
              .then((data) => callbacks.item1(data))
              .catchError((e) => callbacks.item2(e));
        });
      }
    });
  }

  scheduleFuture<DataType>(
    Future<DataType> future, {
    bool shouldInvoke: true,
    bool runImmediately: true,
    @required void Function(dynamic) errorCallback,
    @required ValueSetter<DataType> successDelegate,
  }) {
    if (!shouldInvoke) return;
    if (runImmediately) {
      future
          .then((data) => _whenFutureFinished(successDelegate, data))
          .catchError((e) => _whenFutureFinished(errorCallback, e));
    } else {
      _pendingFuture[future] = Tuple2(successDelegate, errorCallback);
    }
  }

  schedule<DataType>(VoidCallback task, {bool shouldInvoke: true}) {
    if (!shouldInvoke) return;
    _taskCallbackList.add(task);
  }

  _whenFutureFinished(Function callback, dynamic data) {
    if (_unmounted || callback == null) return;
    if (_animationEnd) {
      callback(data);
    } else {
      _callbackFuncDataMap[callback] = data;
    }
  }
}
