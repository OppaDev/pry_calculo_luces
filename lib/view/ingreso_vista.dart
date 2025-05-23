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
  final _formKey = GlobalKey<FormState>();

  void _calcularDistribucion() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    double alto = double.parse(_altoController.text);
    double ancho = double.parse(_anchoController.text);

    if (!_areaController.verificarPositivo(ancho, alto)) {
      _mostrarMensaje("Error", "El alto y el ancho deben ser mayores a 0.");
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

  void _mostrarMensaje(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
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

  void _limpiarCampos() {
    _altoController.clear();
    _anchoController.clear();
  }

  String? _validarNumero(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    
    double? numero = double.tryParse(value);
    if (numero == null) {
      return 'Ingrese un número válido';
    }
    
    if (numero <= 0) {
      return 'El valor debe ser mayor a 0';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cálculo de Luminarias"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calculate,
                          size: 48,
                          color: Colors.blue.shade600,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Automatización de Instalación de Luces',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ingrese las dimensiones del área para calcular la distribución óptima de luminarias',
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Formulario
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dimensiones del Área',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        TextFormField(
                          controller: _altoController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: _validarNumero,
                          decoration: InputDecoration(
                            labelText: "Altura (metros)",
                            hintText: "Ej: 10.5",
                            prefixIcon: Icon(Icons.height, color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _anchoController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: _validarNumero,
                          decoration: InputDecoration(
                            labelText: "Ancho (metros)",
                            hintText: "Ej: 8.5",
                            prefixIcon: Icon(Icons.straighten, color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 24),
                        
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _limpiarCampos,
                                icon: Icon(Icons.clear),
                                label: Text("Limpiar"),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  side: BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: _calcularDistribucion,
                                icon: Icon(Icons.calculate),
                                label: Text("Calcular Distribución"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Información técnica
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue.shade600),
                            SizedBox(width: 8),
                            Text(
                              'Parámetros de Cálculo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          '• Intensidad lumínica por foco: 1600 lm\n'
                          '• Intensidad requerida por área: 500 lm/m²\n'
                          '• Factor de utilización: 0.8\n'
                          '• Distribución optimizada automáticamente',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _altoController.dispose();
    _anchoController.dispose();
    super.dispose();
  }
}