import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'GlobalState.dart';
import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GlobalState(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
