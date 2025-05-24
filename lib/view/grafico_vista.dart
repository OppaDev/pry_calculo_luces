import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoVista extends StatelessWidget {
  final Map<String, dynamic> resultado;

  GraficoVista({required this.resultado});

  @override
  Widget build(BuildContext context) {
    // Forzar orientación horizontal
    return Scaffold(
      appBar: AppBar(
        title: Text("Distribución de Luces"),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _mostrarInformacion(context),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            // Mostrar mensaje para rotar el dispositivo
            return _buildRotateMessage();
          } else {
            // Vista horizontal completa
            return _buildHorizontalLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildRotateMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.screen_rotation,
            size: 64,
            color: Colors.blue.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'Rota tu dispositivo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Para una mejor visualización del plano',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    List<Map<String, double>> puntos = List<Map<String, double>>.from(
      resultado['puntos'],
    );
    
    // Obtener dimensiones reales del área
    double areaAncho = resultado['ancho'].toDouble();
    double areaLargo = resultado['largo'].toDouble();

    return Row(
      children: [
        // Panel de información (lado izquierdo)
        Container(
          width: 300,
          child: _buildInfoPanel(context),
        ),
        
        // Separador vertical
        Container(
          width: 1,
          color: Colors.grey.shade300,
        ),
        
        // Gráfico interactivo (lado derecho)
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plano de Distribución Interactivo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Usa los gestos para hacer zoom y explorar el plano',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _buildInteractiveChart(puntos, areaAncho, areaLargo),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPanel(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resultados del cálculo
          _buildResultCard(),
          
          SizedBox(height: 16),
          
          // Dimensiones del área
          _buildDimensionsCard(),
          
          SizedBox(height: 16),
          
          // Leyenda
          _buildLegendCard(),
          
          SizedBox(height: 16),
          
          // Información técnica
          _buildTechnicalInfo(),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              'Total de Luces',
              '${resultado['cantidadLuces']}',
              Icons.lightbulb,
              Colors.orange,
            ),
            SizedBox(height: 8),
            _buildInfoRow(
              'Distribución H',
              '${resultado['distribucion']['horizontales']}',
              Icons.horizontal_rule,
              Colors.green,
            ),
            SizedBox(height: 8),
            _buildInfoRow(
              'Distribución V',
              '${resultado['distribucion']['verticales']}',
              Icons.vertical_align_center,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dimensiones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text('Ancho: ${resultado['ancho']} m'),
            Text('Largo: ${resultado['largo']} m'),
            Text('Área: ${(resultado['ancho'] * resultado['largo']).toStringAsFixed(1)} m²'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leyenda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(child: Text('Luminarias', style: TextStyle(fontSize: 12))),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 2,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Expanded(child: Text('Perímetro', style: TextStyle(fontSize: 12))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalInfo() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parámetros',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• 1600 lm/foco\n'
              '• 500 lm/m² requeridos\n'
              '• Factor: 0.8',
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 8),
        Expanded(child: Text(label, style: TextStyle(fontSize: 14))),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveChart(List<Map<String, double>> puntos, double areaAncho, double areaLargo) {
    return InteractiveViewer(
      boundaryMargin: EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 10.0,
      child: AspectRatio(
        aspectRatio: areaAncho / areaLargo,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 3),
            color: Colors.grey.shade50,
          ),
          child: CustomPaint(
            painter: LightsPainter(puntos, areaAncho, areaLargo),
            child: ScatterChart(
              ScatterChartData(
                // Puntos invisibles para el sistema de coordenadas
                scatterSpots: puntos
                    .map((punto) => ScatterSpot(
                          punto['x']!,
                          punto['y']!,
                        ))
                    .toList(),
                
                // Configuración de límites
                minX: 0,
                maxX: areaAncho,
                minY: 0,
                maxY: areaLargo,
                
                backgroundColor: Colors.transparent,
                
                // Configuración de tooltips
                scatterTouchData: ScatterTouchData(
                  enabled: true,
                  touchTooltipData: ScatterTouchTooltipData(
                    tooltipBgColor: Colors.blue.shade700.withOpacity(0.9),
                    getTooltipItems: (touchedSpot) => ScatterTooltipItem(
                      'Luminaria\nX: ${touchedSpot.x.toStringAsFixed(1)} m\nY: ${touchedSpot.y.toStringAsFixed(1)} m',
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                // Configuración de títulos y ejes
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: areaLargo > 10 ? areaLargo / 5 : 2,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value > areaLargo) return Container();
                        return Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                        );
                      },
                    ),
                    axisNameWidget: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Largo (m)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: areaAncho > 10 ? areaAncho / 5 : 2,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value > areaAncho) return Container();
                        return Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                        );
                      },
                    ),
                    axisNameWidget: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Ancho (m)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                
                // Grid mejorado
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  horizontalInterval: areaLargo > 10 ? areaLargo / 8 : 1,
                  verticalInterval: areaAncho > 10 ? areaAncho / 8 : 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 0.8,
                    dashArray: [3, 3],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 0.8,
                    dashArray: [3, 3],
                  ),
                ),
                
                // Sin border interno, ya que usamos Container
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarInformacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cómo usar el plano'),
        content: Text(
          '• Pellizca para hacer zoom\n'
          '• Arrastra para mover el plano\n'
          '• Toca una luz para ver su posición\n'
          '• El borde rojo marca el perímetro del área\n'
          '• Los puntos amarillos son las luminarias',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Entendido"),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para dibujar las luces con color uniforme
class LightsPainter extends CustomPainter {
  final List<Map<String, double>> puntos;
  final double areaAncho;
  final double areaLargo;

  LightsPainter(this.puntos, this.areaAncho, this.areaLargo);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.amber.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Calcular la escala para convertir coordenadas del área a coordenadas del canvas
    final scaleX = size.width / areaAncho;
    final scaleY = size.height / areaLargo;

    for (var punto in puntos) {
      final x = punto['x']! * scaleX;
      final y = (areaLargo - punto['y']!) * scaleY; // Invertir Y para que coincida con el gráfico

      // Dibujar círculo relleno
      canvas.drawCircle(Offset(x, y), 8, paint);
      // Dibujar borde del círculo
      canvas.drawCircle(Offset(x, y), 8, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}