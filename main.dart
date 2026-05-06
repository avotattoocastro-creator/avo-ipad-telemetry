import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const AvoPerformanceApp());
}

class AvoPerformanceApp extends StatelessWidget {
  const AvoPerformanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avo Performance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Negro profundo para máximo contraste
        fontFamily: 'Roboto', // Recomiendo cambiar a 'Rajdhani' o 'Share Tech Mono' para look F1
      ),
      home: const TelemetryDashboard(),
    );
  }
}

class TelemetryDashboard extends StatefulWidget {
  const TelemetryDashboard({Key? key}) : super(key: key);

  @override
  State<TelemetryDashboard> createState() => _TelemetryDashboardState();
}

class _TelemetryDashboardState extends State<TelemetryDashboard> {
  // Variables de estado simuladas (Aquí conectaremos el stream de BLE del ESP32-S3)
  final String _gpsStatus = "RTK FIX"; 
  final String _speed = "54.2";
  final String _heartRate = "180"; // ECG MAX30003
  final String _symmetry = "98.5%"; // IMU BNO055 + TinyML
  final bool _fatigaWarning = false;

  // Paleta F1-Style
  final Color _neonGreen = const Color(0xFF39FF14);
  final Color _neonRed = const Color(0xFFFF073A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'AVO TELEMETRY',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2.0),
            ),
            Row(
              children: [
                Icon(Icons.satellite_alt, color: _neonGreen, size: 16),
                const SizedBox(width: 8),
                Text(
                  _gpsStatus,
                  style: TextStyle(color: _neonGreen, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mapa Placeholder (Aquí irá Google Maps API con marcadores de precisión centimétrica)
              Expanded(
                flex: 2,
                child: _buildGlassContainer(
                  child: Center(
                    child: Text(
                      'MAPA RTK EN TIEMPO REAL\n(Precisión < 2cm)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Paneles de Telemetría
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildGlassContainer(
                        child: _buildDataDisplay(
                          label: 'VELOCIDAD (km/h)',
                          value: _speed,
                          valueColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildGlassContainer(
                        child: _buildDataDisplay(
                          label: 'PULSO (BPM)',
                          value: _heartRate,
                          valueColor: _fatigaWarning ? _neonRed : _neonGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Panel de Análisis TinyML
              Expanded(
                flex: 1,
                child: _buildGlassContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDataDisplay(
                        label: 'SIMETRÍA DE ZANCADA',
                        value: _symmetry,
                        valueColor: _neonGreen,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ESTADO IA', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _neonGreen.withOpacity(0.2),
                              border: Border.all(color: _neonGreen),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ÓPTIMO',
                              style: TextStyle(color: _neonGreen, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
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

  // Widget para el efecto Glassmorphism (Alto contraste asegurado por fondo oscuro)
  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  // Widget para mostrar los datos con formato F1
  Widget _buildDataDisplay({required String label, required String value, required Color valueColor}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 48,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
