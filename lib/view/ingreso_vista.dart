import 'package:flutter/material.dart';
import '../controller/area_controller.dart';
import '../model/area_model.dart' as model;
import 'grafico_vista.dart';

class IngresoVista extends StatefulWidget {
  @override
  _IngresoVistaState createState() => _IngresoVistaState();
}

class _IngresoVistaState extends State<IngresoVista> {
  final TextEditingController _altoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  final AreaController _areaController = AreaController();

  void _calcularDistribucion() {
    double? alto = double.tryParse(_altoController.text);
    double? ancho = double.tryParse(_anchoController.text);

    if (alto == null || ancho == null) {
      _mostrarMensaje("Por favor, ingrese valores numéricos válidos.");
      return;
    }

    if (!_areaController.verificarPositivo(ancho, alto)) {
      _mostrarMensaje("El alto y el ancho deben ser mayores a 0.");
      return;
    }

    model.AreaModel areaModel = model.AreaModel(ancho: ancho, largo: alto);
    Map<String, dynamic> resultado = _areaController
        .calcularDistribucionLucesConModelo(areaModel);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GraficoVista(resultado: resultado),
      ),
    );
  }

  void _mostrarMensaje(String mensaje) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Error"),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ingreso de Dimensiones")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _altoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Altura"),
            ),
            TextField(
              controller: _anchoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Ancho"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularDistribucion,
              child: Text("Calcular"),
            ),
          ],
        ),
      ),
    );
  }
}
