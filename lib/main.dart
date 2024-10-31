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
     theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Satoshi'), // Texto normal
          bodyMedium: TextStyle(fontFamily: 'Satoshi'), // Texto secundário
          titleLarge: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold), // Títulos
          // Adicione outros estilos de texto se necessário
        ),
      ),
      home:  const HomeScreen(),
    );
  }
}


