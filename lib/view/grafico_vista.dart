import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoVista extends StatelessWidget {
  final Map<String, dynamic> resultado;

  GraficoVista({required this.resultado});

  @override
  Widget build(BuildContext context) {
    List<Map<String, double>> puntos = List<Map<String, double>>.from(
      resultado['puntos'],
    );
    
    // Obtener dimensiones del área
    double maxX = puntos.isNotEmpty ? puntos.map((p) => p['x']!).reduce((a, b) => a > b ? a : b) : 0;
    double maxY = puntos.isNotEmpty ? puntos.map((p) => p['y']!).reduce((a, b) => a > b ? a : b) : 0;
    
    // Ajustar para mostrar el rectángulo completo
    double areaAncho = maxX * 2;
    double areaAlto = maxY * 2;

    return Scaffold(
      appBar: AppBar(
        title: Text("Distribución de Luces"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del resultado
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resultados del Cálculo',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoCard(
                            'Total de Luces',
                            '${resultado['cantidadLuces']}',
                            Icons.lightbulb,
                            Colors.orange,
                          ),
                          _buildInfoCard(
                            'Horizontales',
                            '${resultado['distribucion']['horizontales']}',
                            Icons.horizontal_rule,
                            Colors.green,
                          ),
                          _buildInfoCard(
                            'Verticales',
                            '${resultado['distribucion']['verticales']}',
                            Icons.vertical_align_center,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Gráfico
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plano de Distribución',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 400,
                        child: ScatterChart(
                          ScatterChartData(
                            scatterSpots: puntos
                                .map((punto) => ScatterSpot(punto['x']!, punto['y']!))
                                .toList(),
                            minX: -areaAncho * 0.1,
                            maxX: areaAncho * 1.1,
                            minY: -areaAlto * 0.1,
                            maxY: areaAlto * 1.1,
                            backgroundColor: Colors.grey.shade100,
                            scatterTouchData: ScatterTouchData(
                              touchTooltipData: ScatterTouchTooltipData(
                                getTooltipColor: (touchedSpot) => Colors.blue.withOpacity(0.8),
                                getTooltipItems: (touchedSpot) => ScatterTooltipItem(
                                  'Luz\nX: ${touchedSpot.x.toStringAsFixed(1)}\nY: ${touchedSpot.y.toStringAsFixed(1)}',
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                                axisNameWidget: Text(
                                  'Alto (m)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                                axisNameWidget: Text(
                                  'Ancho (m)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: true,
                              horizontalInterval: areaAlto / 10,
                              verticalInterval: areaAncho / 10,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.grey.shade300,
                                strokeWidth: 0.5,
                              ),
                              getDrawingVerticalLine: (value) => FlLine(
                                color: Colors.grey.shade300,
                                strokeWidth: 0.5,
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Leyenda
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('Posición de las luminarias'),
                      SizedBox(width: 20),
                      Container(
                        width: 20,
                        height: 2,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text('Perímetro del área'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}