import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:root_detection_flutter/home_screen.dart';

const MethodChannel methodChannel = MethodChannel("com.example.root_detection");

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }

}
