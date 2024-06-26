import 'package:flutter/material.dart';
import 'package:google_map_app/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Map',
      home: MapAppBar(),
    );
  }
}


