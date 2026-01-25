import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../services/qibla/qibla_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  final QiblaService _qiblaService = QiblaService();
  QiblaData? _qiblaData;
  bool _isInitialized = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
    _pulseController.dispose();
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
    final qiblaAngle = (qiblaDirection - compassHeading) * (math.pi / 180);

    // Check if pointing towards Qibla (within 5 degrees)
    final isPointingToQibla = ((qiblaDirection - compassHeading).abs() % 360) < 5 ||
        ((qiblaDirection - compassHeading).abs() % 360) > 355;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Compass Container
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isPointingToQibla ? _pulseAnimation.value : 1.0,
                    child: child,
                  );
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        isPointingToQibla
                            ? Colors.green.withValues(alpha: 0.1)
                            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        isPointingToQibla
                            ? Colors.green.withValues(alpha: 0.2)
                            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isPointingToQibla
                            ? Colors.green.withValues(alpha: 0.3)
                            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer ring with tick marks
                      CustomPaint(
                        size: const Size(300, 300),
                        painter: _CompassTicksPainter(
                          compassHeading: compassHeading,
                          primaryColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      // Inner decorative circle
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                      ),

                      // Cardinal directions (rotate with compass)
                      Transform.rotate(
                        angle: -compassHeading * (math.pi / 180),
                        child: SizedBox(
                          width: 260,
                          height: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'N',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                bottom: 20,
                                child: Text('S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                              ),
                              const Positioned(
                                left: 20,
                                child: Text('W', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                              ),
                              const Positioned(
                                right: 20,
                                child: Text('E', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Qibla indicator arrow
                      Transform.rotate(
                        angle: qiblaAngle,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Kaaba icon with glow
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isPointingToQibla ? Colors.green : Theme.of(context).colorScheme.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isPointingToQibla ? Colors.green : Theme.of(context).colorScheme.primary)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mosque,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Arrow line
                            Container(
                              width: 4,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    isPointingToQibla ? Colors.green : Theme.of(context).colorScheme.primary,
                                    (isPointingToQibla ? Colors.green : Theme.of(context).colorScheme.primary)
                                        .withValues(alpha: 0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Center dot
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Status indicator
              if (isPointingToQibla)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Facing Qibla',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  '${qiblaDirection.toStringAsFixed(0)}° ${_qiblaService.qiblaCardinalDirection}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              const SizedBox(height: 8),

              // Distance to Makkah
              Text(
                '${distance.toStringAsFixed(0)} km to Makkah',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),

              // Warning/status messages
              if (!hasCompass)
                _buildStatusCard(
                  icon: Icons.warning_amber_rounded,
                  message: 'Compass not available on this device',
                  color: Colors.orange,
                )
              else if (needsCalibration)
                _buildStatusCard(
                  icon: Icons.screen_rotation,
                  message: 'Move your phone in a figure-8 to calibrate',
                  color: Colors.amber,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for compass tick marks
class _CompassTicksPainter extends CustomPainter {
  final double compassHeading;
  final Color primaryColor;

  _CompassTicksPainter({
    required this.compassHeading,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw tick marks
    for (int i = 0; i < 72; i++) {
      final angle = (i * 5 - compassHeading) * (math.pi / 180);
      final isMajor = i % 6 == 0; // Every 30 degrees
      final tickLength = isMajor ? 15.0 : 8.0;

      paint.color = isMajor
          ? primaryColor.withValues(alpha: 0.6)
          : primaryColor.withValues(alpha: 0.2);

      final startPoint = Offset(
        center.dx + (radius - tickLength) * math.sin(angle),
        center.dy - (radius - tickLength) * math.cos(angle),
      );
      final endPoint = Offset(
        center.dx + radius * math.sin(angle),
        center.dy - radius * math.cos(angle),
      );

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CompassTicksPainter oldDelegate) {
    return oldDelegate.compassHeading != compassHeading;
  }
}
