// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

MaterialColor convertNumberToColor(int number) {
  MaterialColor defaultColor = Colors.blue;
  Map<int, MaterialColor> colors = <int, MaterialColor>{
    0 : Colors.blue,
    1 : Colors.yellow,
    2: Colors.red,
    3: Colors.green,
    4 : Colors.purple
  };
  return colors[number % 5] ?? defaultColor;
}

int count = 0;

void main() {
  runApp(MyApp(color: convertNumberToColor(count)));
  count++;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.color}) : super(key: key);

  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: color,
      ),
      // home: const MyHomePage(title: 'Home Page'),
      routes: {
        '/': (context) => const MyHomePage(title: 'Home Page:root'),
        'main': (context) => const MyHomePage(title: 'Home Page:main'),
        'topMain': (context) => const MyHomePage(title: 'Home Page:topMain'),
        'bottomMain': (context) => const MyHomePage(title: 'Home Page:bottomMain'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? _counter = 0;
  late MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel('multiple-flutters');
    _channel.setMethodCallHandler((call) async {
      if (call.method == "setCount") {
        // A notification that the host platform's data model has been updated.
        setState(() {
          _counter = call.arguments as int?;
        });
      } else {
        throw Exception('not implemented ${call.method}');
      }
    });
  }

  void _incrementCounter() {
    // Mutations to the data model are forwarded to the host platform.
    _channel.invokeMethod<void>("incrementCount", _counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: _incrementCounter,
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                _channel.invokeMethod<void>("next", _counter);
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
