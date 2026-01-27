import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../services/qibla/qibla_service.dart';
import '../../services/location/location_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  final QiblaService _qiblaService = QiblaService();
  final LocationService _locationService = LocationService();

  QiblaData? _qiblaData;
  bool _isInitialized = false;
  bool _wasAligned = false; // Track alignment state for haptic
  bool _locationError = false;
  String? _errorMessage;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
    try {
      await _qiblaService.initialize();
      await _locationService.initialize();

      // Check if location is available
      if (_locationService.locationName == 'Unknown Location') {
        setState(() {
          _locationError = true;
          _errorMessage = 'Unable to determine your location. Please enable location services.';
          _isInitialized = true;
        });
        return;
      }

      _qiblaService.startListening();
      _qiblaService.compassStream.listen((data) {
        if (mounted) {
          setState(() {
            _qiblaData = data;
            _isInitialized = true;
            _locationError = false;
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
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _locationError = true;
        _errorMessage = 'Error initializing compass: $e';
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _qiblaService.stopListening();
    super.dispose();
  }

  /// Get shortened location (city, state/country)
  String get _shortLocation {
    final fullName = _locationService.locationName;
    // If it's already short, return as is
    if (fullName.length <= 25) return fullName;

    // Try to extract city and state/country
    final parts = fullName.split(', ');
    if (parts.length >= 2) {
      // Return first part (city) and last part (state/country)
      return '${parts[0]}, ${parts[parts.length - 1]}';
    }
    return fullName;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (!_isInitialized) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withValues(alpha: 0.05),
                Colors.white,
                primaryColor.withValues(alpha: 0.03),
              ],
            ),
          ),
          child: Center(child: CircularProgressIndicator(color: primaryColor)),
        ),
      );
    }

    // Show error state if location unavailable
    if (_locationError) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withValues(alpha: 0.05),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(primaryColor),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 64,
                            color: Colors.orange.withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Location Unavailable',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage ?? 'Please enable location services to find Qibla direction.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isInitialized = false;
                                _locationError = false;
                              });
                              _initServices();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final qiblaDirection = _qiblaData?.qiblaDirection ?? 0;
    final compassHeading = _qiblaData?.compassHeading ?? 0;
    final hasCompass = _qiblaData?.hasCompass ?? false;
    final needsCalibration = _qiblaData?.needsCalibration ?? false;

    // Check if pointing towards Qibla (within 5 degrees)
    final angleDiff = ((qiblaDirection - compassHeading) % 360).abs();
    final isPointingToQibla = angleDiff < 5 || angleDiff > 355;

    // Handle alignment transitions and haptics outside of the synchronous build
    final shouldAlignNow = isPointingToQibla && !_wasAligned;
    final shouldUnalignNow = !isPointingToQibla && _wasAligned;

    if (shouldAlignNow || shouldUnalignNow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          if (shouldAlignNow) {
            HapticFeedback.mediumImpact();
            _wasAligned = true;
          } else if (shouldUnalignNow) {
            _wasAligned = false;
          }
        });
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.06),
              Colors.white,
              primaryColor.withValues(alpha: 0.04),
            ],
          ),
        ),
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.landscape) {
                return _buildLandscapeLayout(
                  primaryColor: primaryColor,
                  qiblaDirection: qiblaDirection,
                  compassHeading: compassHeading,
                  isPointingToQibla: isPointingToQibla,
                  hasCompass: hasCompass,
                  needsCalibration: needsCalibration,
                );
              }
              return _buildPortraitLayout(
                primaryColor: primaryColor,
                qiblaDirection: qiblaDirection,
                compassHeading: compassHeading,
                isPointingToQibla: isPointingToQibla,
                hasCompass: hasCompass,
                needsCalibration: needsCalibration,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout({
    required Color primaryColor,
    required double qiblaDirection,
    required double compassHeading,
    required bool isPointingToQibla,
    required bool hasCompass,
    required bool needsCalibration,
  }) {
    return Column(
      children: [
        _buildHeader(primaryColor),
        _buildLocationRow(primaryColor),
        if (hasCompass && !isPointingToQibla)
          _buildUserGuidance(primaryColor),
        if (isPointingToQibla)
          _buildAlignmentMessage(),
        Expanded(
          child: Center(
            child: _buildCompass(
              primaryColor: primaryColor,
              qiblaDirection: qiblaDirection,
              compassHeading: compassHeading,
              isPointingToQibla: isPointingToQibla,
              hasCompass: hasCompass,
              needsCalibration: needsCalibration,
            ),
          ),
        ),
        _buildInfoSection(primaryColor, qiblaDirection),
        if (!hasCompass || needsCalibration)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildStatusMessage(hasCompass, needsCalibration),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLandscapeLayout({
    required Color primaryColor,
    required double qiblaDirection,
    required double compassHeading,
    required bool isPointingToQibla,
    required bool hasCompass,
    required bool needsCalibration,
  }) {
    return Row(
      children: [
        // Left side: Compass
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildHeader(primaryColor),
              Expanded(
                child: Center(
                  child: _buildCompass(
                    primaryColor: primaryColor,
                    qiblaDirection: qiblaDirection,
                    compassHeading: compassHeading,
                    isPointingToQibla: isPointingToQibla,
                    hasCompass: hasCompass,
                    needsCalibration: needsCalibration,
                    size: 240,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Right side: Info
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLocationRow(primaryColor),
                const SizedBox(height: 12),
                if (hasCompass && !isPointingToQibla)
                  _buildUserGuidance(primaryColor),
                if (isPointingToQibla)
                  _buildAlignmentMessage(),
                const SizedBox(height: 16),
                _buildInfoSectionVertical(primaryColor, qiblaDirection),
                if (!hasCompass || needsCalibration)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildStatusMessage(hasCompass, needsCalibration),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          _buildRoundedButton(
            primaryColor: primaryColor,
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),

          // Title
          Text(
            'Qibla Compass',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),

          // Empty placeholder for symmetry
          const SizedBox(width: 44, height: 44),
        ],
      ),
    );
  }

  Widget _buildRoundedButton({
    required Color primaryColor,
    required IconData icon,
    VoidCallback? onTap,
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
          child: Icon(icon, color: primaryColor, size: 22),
        ),
      ),
    );
  }

  Widget _buildLocationRow(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 16,
            color: Colors.grey[500],
          ),
          const SizedBox(width: 4),
          Text(
            _shortLocation,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserGuidance(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        'Hold phone flat and rotate until aligned',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAlignmentMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            const Text(
              "You're facing Qibla!",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(Color primaryColor, double qiblaDirection) {
    final distance = _qiblaService.getDistanceToMakkah();
    final cardinalDirection = _qiblaService.qiblaCardinalDirection;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          // Distance to Makkah
          Expanded(
            child: Column(
              children: [
                Icon(Icons.straighten, color: primaryColor, size: 24),
                const SizedBox(height: 6),
                Text(
                  '${distance.toStringAsFixed(0)} km',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'to Makkah',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 55,
            color: primaryColor.withValues(alpha: 0.2),
          ),

          // Qibla bearing with detailed cardinal direction
          Expanded(
            child: Column(
              children: [
                Icon(Icons.explore, color: primaryColor, size: 24),
                const SizedBox(height: 6),
                Text(
                  '${qiblaDirection.toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  cardinalDirection,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 55,
            color: primaryColor.withValues(alpha: 0.2),
          ),

          // Tip - better icon showing phone flat
          Expanded(
            child: Column(
              children: [
                Icon(Icons.screen_rotation_alt, color: primaryColor, size: 24),
                const SizedBox(height: 6),
                Text(
                  'Hold flat',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'for accuracy',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSectionVertical(Color primaryColor, double qiblaDirection) {
    final distance = _qiblaService.getDistanceToMakkah();
    final cardinalDirection = _qiblaService.qiblaCardinalDirection;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Distance to Makkah
          Row(
            children: [
              Icon(Icons.straighten, color: primaryColor, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${distance.toStringAsFixed(0)} km',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'to Makkah',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Qibla bearing
          Row(
            children: [
              Icon(Icons.explore, color: primaryColor, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${qiblaDirection.toStringAsFixed(1)}° $cardinalDirection',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Qibla bearing',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Hold flat tip
          Row(
            children: [
              Icon(Icons.screen_rotation_alt, color: primaryColor, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hold flat',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'for accuracy',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompass({
    required Color primaryColor,
    required double qiblaDirection,
    required double compassHeading,
    required bool isPointingToQibla,
    required bool hasCompass,
    required bool needsCalibration,
    double size = 300,
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
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer circle with tick marks
            CustomPaint(
              size: Size(size, size),
              painter: _CompassPainter(
                compassHeading: compassHeading,
                primaryColor: primaryColor,
              ),
            ),

            // Cardinal directions (rotate with compass)
            Transform.rotate(
              angle: compassAngle,
              child: SizedBox(
                width: size * 0.85,
                height: size * 0.85,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // N - increased spacing from tick marks
                    Positioned(
                      top: 22,
                      child: Text(
                        'N',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    // S
                    Positioned(
                      bottom: 22,
                      child: Transform.rotate(
                        angle: math.pi,
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    // E
                    Positioned(
                      right: 22,
                      child: Transform.rotate(
                        angle: -math.pi / 2,
                        child: Text(
                          'E',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                    // W
                    Positioned(
                      left: 22,
                      child: Transform.rotate(
                        angle: math.pi / 2,
                        child: Text(
                          'W',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryColor.withValues(alpha: 0.7),
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
                size: Size(size, size),
                painter: _NeedlePainter(primaryColor: primaryColor, size: size),
              ),
            ),

            // Kaaba icon at Qibla direction - positioned to touch the ring
            Transform.rotate(
              angle: qiblaAngle,
              child: Align(
                alignment: const Alignment(0, -0.72),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isPointingToQibla
                        ? Colors.green.withValues(alpha: 0.2)
                        : primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPointingToQibla ? Colors.green : primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.mosque,
                    size: 20,
                    color: isPointingToQibla ? Colors.green : primaryColor,
                  ),
                ),
              ),
            ),

            // Center Kaaba decoration
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.2),
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

    // Draw tick marks (rotate with compass) - bolder and more visible
    for (int i = 0; i < 60; i++) {
      final angle = (i * 6 - compassHeading) * (math.pi / 180);
      final isMajor = i % 5 == 0;
      final isCardinal = i % 15 == 0; // N, E, S, W
      final tickLength = isCardinal ? 20.0 : (isMajor ? 14.0 : 8.0);

      paint.color = isCardinal
          ? primaryColor
          : (isMajor
              ? primaryColor.withValues(alpha: 0.85)
              : primaryColor.withValues(alpha: 0.4));
      paint.strokeWidth = isCardinal ? 3.5 : (isMajor ? 2.8 : 1.8);

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
  final double size;

  _NeedlePainter({required this.primaryColor, this.size = 300});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final scale = size / 300; // Scale relative to default 300

    // Draw needle pointing up (north)
    final needlePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final needlePath = Path();
    needlePath.moveTo(center.dx, center.dy - 75 * scale); // Top point
    needlePath.lineTo(center.dx - 6 * scale, center.dy - 20 * scale);
    needlePath.lineTo(center.dx + 6 * scale, center.dy - 20 * scale);
    needlePath.close();

    canvas.drawPath(needlePath, needlePaint);

    // Bottom part of needle (lighter)
    final bottomPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final bottomPath = Path();
    bottomPath.moveTo(center.dx, center.dy + 75 * scale); // Bottom point
    bottomPath.lineTo(center.dx - 6 * scale, center.dy + 20 * scale);
    bottomPath.lineTo(center.dx + 6 * scale, center.dy + 20 * scale);
    bottomPath.close();

    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) => oldDelegate.size != size;
}
