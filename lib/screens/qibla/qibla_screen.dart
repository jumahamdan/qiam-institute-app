import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../services/qibla/qibla_service.dart';
import '../../services/prayer/prayer_service.dart';
import '../../services/location/location_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  final QiblaService _qiblaService = QiblaService();
  final PrayerService _prayerService = PrayerService();
  final LocationService _locationService = LocationService();

  QiblaData? _qiblaData;
  NextPrayerInfo? _nextPrayer;
  String? _fullAddress;
  bool _isInitialized = false;
  bool _isRefreshing = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Light blue/teal theme colors
  static const Color _primaryColor = Color(0xFF4A90A4);
  static const Color _backgroundColor = Color(0xFFE8F4F8);
  static const Color _cardColor = Color(0xFFD4EBF2);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _initServices();
  }

  Future<void> _initServices() async {
    await _qiblaService.initialize();
    await _prayerService.initialize();
    await _locationService.initialize();

    _qiblaService.startListening();
    _qiblaService.compassStream.listen((data) {
      if (mounted) {
        setState(() {
          _qiblaData = data;
          _isInitialized = true;
        });
      }
    });

    // Set initial data
    setState(() {
      _qiblaData = QiblaData(
        qiblaDirection: _qiblaService.qiblaDirection,
        compassHeading: 0,
        accuracy: null,
        hasCompass: _qiblaService.hasCompass,
      );
      _nextPrayer = _prayerService.getNextPrayer();
      _isInitialized = true;
    });

    // Get full address
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final address = await _locationService.getFullAddress();
    if (mounted && address != null) {
      setState(() => _fullAddress = address);
    }
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Re-initialize services
    await _qiblaService.initialize();
    _qiblaService.startListening();

    setState(() {
      _nextPrayer = _prayerService.getNextPrayer();
      _isRefreshing = false;
    });

    await _loadAddress();
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
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final qiblaDirection = _qiblaData?.qiblaDirection ?? 0;
    final compassHeading = _qiblaData?.compassHeading ?? 0;
    final hasCompass = _qiblaData?.hasCompass ?? false;
    final needsCalibration = _qiblaData?.needsCalibration ?? false;

    // Check if pointing towards Qibla (within 5 degrees)
    final angleDiff = ((qiblaDirection - compassHeading) % 360).abs();
    final isPointingToQibla = angleDiff < 5 || angleDiff > 355;

    // Provide haptic feedback when aligned
    if (isPointingToQibla) {
      HapticFeedback.lightImpact();
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildHeader(),

            // Info Card
            _buildInfoCard(),

            // Compass
            Expanded(
              child: Center(
                child: _buildCompass(
                  qiblaDirection: qiblaDirection,
                  compassHeading: compassHeading,
                  isPointingToQibla: isPointingToQibla,
                  hasCompass: hasCompass,
                  needsCalibration: needsCalibration,
                ),
              ),
            ),

            // Status message
            if (!hasCompass || needsCalibration)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildStatusMessage(hasCompass, needsCalibration),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          _buildRoundedButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),

          // Title
          const Text(
            'Qibla',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),

          // Refresh button
          _buildRoundedButton(
            icon: Icons.refresh,
            onTap: _isRefreshing ? null : _refresh,
            isLoading: _isRefreshing,
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton({
    required IconData icon,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _primaryColor,
                  ),
                )
              : Icon(icon, color: _primaryColor, size: 22),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final prayerName = _nextPrayer?.name ?? 'Loading...';
    final timeUntil = _nextPrayer?.formattedTimeUntil ?? '--';
    final address = _fullAddress ?? _locationService.locationName;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Current Prayer
          Text(
            'Now : $prayerName',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),

          // Time remaining
          Text(
            '$timeUntil left',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  address,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompass({
    required double qiblaDirection,
    required double compassHeading,
    required bool isPointingToQibla,
    required bool hasCompass,
    required bool needsCalibration,
  }) {
    final compassAngle = -compassHeading * (math.pi / 180);
    final qiblaAngle = (qiblaDirection - compassHeading) * (math.pi / 180);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isPointingToQibla ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer circle with tick marks
            CustomPaint(
              size: const Size(320, 320),
              painter: _CompassPainter(
                compassHeading: compassHeading,
                primaryColor: _primaryColor,
              ),
            ),

            // Cardinal directions (rotate with compass)
            Transform.rotate(
              angle: compassAngle,
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // N
                    Positioned(
                      top: 15,
                      child: Text(
                        'N',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                    // S
                    Positioned(
                      bottom: 15,
                      child: Transform.rotate(
                        angle: math.pi,
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    // E
                    Positioned(
                      right: 15,
                      child: Transform.rotate(
                        angle: -math.pi / 2,
                        child: Text(
                          'E',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    // W
                    Positioned(
                      left: 15,
                      child: Transform.rotate(
                        angle: math.pi / 2,
                        child: Text(
                          'W',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _primaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Compass needle (pointing north, rotates with compass)
            Transform.rotate(
              angle: compassAngle,
              child: CustomPaint(
                size: const Size(320, 320),
                painter: _NeedlePainter(primaryColor: _primaryColor),
              ),
            ),

            // Kaaba icon at Qibla direction
            Transform.rotate(
              angle: qiblaAngle,
              child: Align(
                alignment: const Alignment(0, -0.55),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isPointingToQibla
                        ? Colors.green.withValues(alpha: 0.2)
                        : _primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPointingToQibla ? Colors.green : _primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.mosque,
                    size: 24,
                    color: isPointingToQibla ? Colors.green : _primaryColor,
                  ),
                ),
              ),
            ),

            // Center Kaaba decoration
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🕋',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage(bool hasCompass, bool needsCalibration) {
    if (!hasCompass) {
      return _buildStatusCard(
        icon: Icons.warning_amber_rounded,
        message: 'Compass not available on this device',
        color: Colors.orange,
      );
    }
    if (needsCalibration) {
      return _buildStatusCard(
        icon: Icons.screen_rotation,
        message: 'Move your phone in a figure-8 to calibrate',
        color: Colors.amber,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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

/// Compass tick marks and outer ring painter
class _CompassPainter extends CustomPainter {
  final double compassHeading;
  final Color primaryColor;

  _CompassPainter({
    required this.compassHeading,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw tick marks (rotate with compass)
    for (int i = 0; i < 60; i++) {
      final angle = (i * 6 - compassHeading) * (math.pi / 180);
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 18.0 : 10.0;

      paint.color = isMajor
          ? primaryColor.withValues(alpha: 0.8)
          : primaryColor.withValues(alpha: 0.3);
      paint.strokeWidth = isMajor ? 2.5 : 1.5;

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
  bool shouldRepaint(covariant _CompassPainter oldDelegate) {
    return oldDelegate.compassHeading != compassHeading;
  }
}

/// Compass needle painter
class _NeedlePainter extends CustomPainter {
  final Color primaryColor;

  _NeedlePainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw needle pointing up (north)
    final needlePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final needlePath = Path();
    needlePath.moveTo(center.dx, center.dy - 80); // Top point
    needlePath.lineTo(center.dx - 6, center.dy - 20);
    needlePath.lineTo(center.dx + 6, center.dy - 20);
    needlePath.close();

    canvas.drawPath(needlePath, needlePaint);

    // Bottom part of needle (lighter)
    final bottomPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final bottomPath = Path();
    bottomPath.moveTo(center.dx, center.dy + 80); // Bottom point
    bottomPath.lineTo(center.dx - 6, center.dy + 20);
    bottomPath.lineTo(center.dx + 6, center.dy + 20);
    bottomPath.close();

    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
