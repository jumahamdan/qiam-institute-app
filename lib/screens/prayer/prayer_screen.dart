import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/prayer/prayer_service.dart';
import '../../services/prayer/prayer_settings.dart';
import '../../services/qibla/qibla_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final PrayerService _prayerService = PrayerService();
  final QiblaService _qiblaService = QiblaService();
  List<PrayerTimeInfo>? _prayerTimes;
  NextPrayerInfo? _nextPrayer;
  Timer? _timer;
  double _qiblaDirection = 0;
  double _compassHeading = 0;
  bool _isLoading = true;
  bool _hasCompass = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await _prayerService.initialize();
    _updatePrayerData();

    // Update every second for smooth countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _updatePrayerData());
      }
    });

    // Initialize qibla
    await _qiblaService.initialize();
    _qiblaService.startListening();
    _qiblaService.compassStream.listen((data) {
      if (mounted) {
        setState(() {
          _qiblaDirection = data.qiblaDirection;
          _compassHeading = data.compassHeading;
          _hasCompass = data.hasCompass;
        });
      }
    });

    if (mounted) {
      setState(() {
        _qiblaDirection = _qiblaService.qiblaDirection;
        _hasCompass = _qiblaService.hasCompass;
        _isLoading = false;
      });
    }
  }

  void _updatePrayerData() {
    _prayerTimes = _prayerService.getTodayPrayerList();
    _nextPrayer = _prayerService.getNextPrayer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _qiblaService.stopListening();
    super.dispose();
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PrayerSettingsSheet(
        prayerService: _prayerService,
        onSettingsChanged: () {
          setState(() => _updatePrayerData());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    // Show loading state while initializing
    if (_isLoading || _nextPrayer == null || _prayerTimes == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading prayer times...'),
          ],
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header with location and settings
              _buildHeader(dateFormat.format(today)),
              const SizedBox(height: 20),

              // Circular progress indicator for next prayer
              _buildNextPrayerCircle(),
              const SizedBox(height: 24),

              // Prayer times list
              _buildPrayerList(),
              const SizedBox(height: 16),

              // Sunrise and Sunset boxes
              _buildSunriseSunsetRow(),
              const SizedBox(height: 16),

              // Mini Qibla compass
              _buildMiniQiblaCompass(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String dateString) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prayer Times',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                dateString,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _prayerService.locationName,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _showSettingsModal,
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Prayer Settings',
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerCircle() {
    final nextPrayer = _nextPrayer!;
    final progress = nextPrayer.progress;
    final timeUntil = nextPrayer.timeUntil;
    final hours = timeUntil.inHours;
    final minutes = timeUntil.inMinutes.remainder(60);
    final seconds = timeUntil.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Next Prayer: ${nextPrayer.name}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Circular progress
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                // Progress circle
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Time display
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Text(
                      'Left',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Prayer time
          Text(
            '${nextPrayer.name} at ${nextPrayer.formattedTime}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: _prayerTimes!.map((prayer) => _buildPrayerRow(prayer)).toList(),
      ),
    );
  }

  Widget _buildPrayerRow(PrayerTimeInfo prayer) {
    final isNext = prayer.isNext;
    final iqamahOffset = _getIqamahOffset(prayer.name);
    String? iqamahTime;
    if (iqamahOffset != null) {
      iqamahTime = DateFormat('h:mm a').format(prayer.time.add(Duration(minutes: iqamahOffset)));
    }

    return Container(
      decoration: BoxDecoration(
        color: isNext ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08) : null,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Prayer icon - compact
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getPrayerColor(prayer.name).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getPrayerIcon(prayer.name),
              color: _getPrayerColor(prayer.name),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Prayer name
          Expanded(
            child: Row(
              children: [
                Text(
                  prayer.name,
                  style: TextStyle(
                    fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                    fontSize: 15,
                    color: isNext ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                if (isNext) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Iqamah time (if available)
          if (iqamahTime != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    iqamahTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    'Iqamah',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

          // Adhan time - prominent
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prayer.formattedTime,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isNext ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                ),
              ),
              Text(
                'Adhan',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunriseSunsetRow() {
    return Row(
      children: [
        Expanded(
          child: _buildSunTimeBox(
            'Sunrise',
            _prayerService.sunrise,
            Icons.wb_sunny_rounded,
            const Color(0xFFFF9800),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSunTimeBox(
            'Sunset',
            _prayerService.sunset,
            Icons.nights_stay_rounded,
            const Color(0xFFE91E63),
          ),
        ),
      ],
    );
  }

  Widget _buildSunTimeBox(String label, DateTime time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('h:mm a').format(time),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniQiblaCompass() {
    final qiblaAngle = (_qiblaDirection - _compassHeading) * (math.pi / 180);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mini compass
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // N indicator
                Transform.rotate(
                  angle: -_compassHeading * (math.pi / 180),
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'N',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                // Qibla arrow
                Transform.rotate(
                  angle: qiblaAngle,
                  child: Icon(
                    Icons.navigation,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Qibla info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.mosque,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Qibla Direction',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${_qiblaDirection.toStringAsFixed(1)}° ${_qiblaService.qiblaCardinalDirection}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  _hasCompass
                      ? 'Point arrow towards Makkah'
                      : 'Compass not available on this device',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Kaaba icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '🕋',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.dark_mode_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny_rounded;
      case 'Asr':
        return Icons.cloud_outlined;
      case 'Maghrib':
        return Icons.wb_twilight_rounded;
      case 'Isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }

  Color _getPrayerColor(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return const Color(0xFF5C6BC0); // Indigo
      case 'Dhuhr':
        return const Color(0xFFFFB300); // Amber
      case 'Asr':
        return const Color(0xFFFF7043); // Deep Orange
      case 'Maghrib':
        return const Color(0xFFE91E63); // Pink
      case 'Isha':
        return const Color(0xFF3F51B5); // Indigo
      default:
        return Colors.grey;
    }
  }

  int? _getIqamahOffset(String prayer) {
    const offsets = {
      'Fajr': 20,
      'Dhuhr': 15,
      'Asr': 15,
      'Maghrib': 5,
      'Isha': 15,
    };
    return offsets[prayer];
  }
}

// Prayer Settings Bottom Sheet
class _PrayerSettingsSheet extends StatefulWidget {
  final PrayerService prayerService;
  final VoidCallback onSettingsChanged;

  const _PrayerSettingsSheet({
    required this.prayerService,
    required this.onSettingsChanged,
  });

  @override
  State<_PrayerSettingsSheet> createState() => _PrayerSettingsSheetState();
}

class _PrayerSettingsSheetState extends State<_PrayerSettingsSheet> {
  late String _locationMode;
  late String _calculationMethod;
  late String _asrMethod;

  @override
  void initState() {
    super.initState();
    final settings = widget.prayerService.settings;
    _locationMode = settings.locationMode;
    _calculationMethod = settings.calculationMethod;
    _asrMethod = settings.asrMethod;
  }

  Future<void> _saveSettings() async {
    await widget.prayerService.updateSettings(
      locationMode: _locationMode,
      calculationMethod: _calculationMethod,
      asrMethod: _asrMethod,
    );
    widget.onSettingsChanged();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Row(
                children: [
                  Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Prayer Time Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Current Location
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Current Location',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.prayerService.locationName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Timezone: ${widget.prayerService.timezone}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Location Mode
              Text(
                'Location Mode',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Auto (Use GPS)'),
                      subtitle: const Text('Automatically detect your location'),
                      value: PrayerSettings.locationModeAuto,
                      groupValue: _locationMode,
                      onChanged: (value) => setState(() => _locationMode = value!),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    RadioListTile<String>(
                      title: const Text('Manual'),
                      subtitle: const Text('Set a fixed location'),
                      value: PrayerSettings.locationModeManual,
                      groupValue: _locationMode,
                      onChanged: (value) => setState(() => _locationMode = value!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select your preferred calculation method for accurate prayer times in your area.',
                        style: TextStyle(color: Colors.blue[800], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Calculation Method
              Text(
                'Calculation Method',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _calculationMethod,
                    items: PrayerSettings.calculationMethods.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _calculationMethod = value!),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Asr Calculation
              Text(
                'Asr Calculation',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _asrMethod,
                    items: PrayerSettings.asrMethods.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _asrMethod = value!),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
