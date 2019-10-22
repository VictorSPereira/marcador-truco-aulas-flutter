import 'package:flutter/material.dart';
import 'package:marcador_truco/views/home_page.dart';
import 'views/home_page.dart';
import 'package:screen/screen.dart';


Future main() async {
  bool isKeptOn = await Screen.isKeptOn;

  Screen.keepOn(true);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.deepOrange),
    ),
  );
}
