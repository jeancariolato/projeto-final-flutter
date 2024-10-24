import 'package:flutter/material.dart';
import 'package:projeto_final/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
     //ALTERANDO FONTE DO APP
     theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Satoshi'), 
          bodyMedium: TextStyle(fontFamily: 'Satoshi'), 
          titleLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold), 
        ),
      ),
      home:  const HomeScreen(),
    );
  }
}


