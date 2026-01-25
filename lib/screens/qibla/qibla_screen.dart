import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../services/qibla/qibla_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final QiblaService _qiblaService = QiblaService();
  QiblaData? _qiblaData;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initQibla();
  }

  Future<void> _initQibla() async {
    await _qiblaService.initialize();
    _qiblaService.startListening();
    _qiblaService.compassStream.listen((data) {
      if (mounted) {
        setState(() {
          _qiblaData = data;
          _isInitialized = true;
        });
      }
    });

    // Set initial data even if no compass stream
    setState(() {
      _qiblaData = QiblaData(
        qiblaDirection: _qiblaService.qiblaDirection,
        compassHeading: 0,
        accuracy: null,
        hasCompass: _qiblaService.hasCompass,
      );
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _qiblaService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final qiblaDirection = _qiblaData?.qiblaDirection ?? 0;
    final compassHeading = _qiblaData?.compassHeading ?? 0;
    final hasCompass = _qiblaData?.hasCompass ?? false;
    final needsCalibration = _qiblaData?.needsCalibration ?? false;
    final distance = _qiblaService.getDistanceToMakkah();
    final cardinalDirection = _qiblaService.qiblaCardinalDirection;

    return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Compass Container
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Compass rose (rotates with device)
                    Transform.rotate(
                      angle: -compassHeading * (math.pi / 180),
                      child: const Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(top: 16, child: Text('N', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                          Positioned(bottom: 16, child: Text('S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                          Positioned(left: 16, child: Text('W', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                          Positioned(right: 16, child: Text('E', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                        ],
                      ),
                    ),

                    // Qibla indicator (points to Qibla)
                    Transform.rotate(
                      angle: (qiblaDirection - compassHeading) * (math.pi / 180),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mosque,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 3,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Direction Info
              Text(
                'Direction: ${qiblaDirection.toStringAsFixed(1)}° $cardinalDirection',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Distance to Makkah: ${distance.toStringAsFixed(0)} km',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),

              // Status Cards
              if (!hasCompass)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Compass sensor not available. Showing direction from North.',
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (needsCalibration)
                Card(
                  color: Colors.amber[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber[800]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Calibrate Compass',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber[900],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Move your device in a figure-8 pattern for better accuracy',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Compass calibrated. Point your phone towards the mosque icon.',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
    );
  }
}
