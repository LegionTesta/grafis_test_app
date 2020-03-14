import 'package:flutter/material.dart';
import 'package:grafis_test_app/ui/client/client_register_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClientRegisterScreen()
    );
  }
}
