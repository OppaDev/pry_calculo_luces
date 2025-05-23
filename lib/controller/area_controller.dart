import 'dart:math';
import '../model/area_model.dart';

class AreaController {
  // verificar si el ancho y el alto son positivos
  bool verificarPositivo(double ancho, double largo) {
    if (ancho <= 0 || largo <= 0) {
      return false;
    }
    return true;
  }

  // Método para calcular la distribución de luces utilizando AreaModel
  Map<String, dynamic> calcularDistribucionLucesConModelo(AreaModel areaModel) {
    const double IL = 1600; // Cantidad de luz por foco
    const double ILA = 500; // Intensidad luz/área

    double area = areaModel.ancho * areaModel.largo;
    double numeroLuces = (ILA * area) / (IL * 0.8);

    int y = sqrt(numeroLuces * (areaModel.largo / areaModel.ancho)).round();
    int x = sqrt(numeroLuces * (areaModel.ancho / areaModel.largo)).round();

    double distanciaX = areaModel.ancho / x;
    double distanciaY = areaModel.largo / y;

    List<double> focosX = List.generate(x, (i) => (i + 1) * distanciaX);
    List<double> focosY = List.generate(y, (j) => (j + 1) * distanciaY);

    List<Map<String, double>> puntos = [];
    for (var fx in focosX) {
      for (var fy in focosY) {
        puntos.add({"x": fx - distanciaX / 2, "y": fy - distanciaY / 2});
      }
    }

    return {
      "cantidadLuces": x * y,
      "distribucion": {"horizontales": x, "verticales": y},
      "puntos": puntos,
    };
  }
}
