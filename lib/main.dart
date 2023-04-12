import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.indigoAccent,
          secondary: Colors.grey[600],
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
