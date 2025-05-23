import 'package:flutter/material.dart';
import './view/ingreso_vista.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Distribución de Luces',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {'/': (context) => IngresoVista()},
    ),
  );
}
