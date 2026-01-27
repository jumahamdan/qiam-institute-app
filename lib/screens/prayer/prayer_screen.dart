// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../services/prayer/prayer_service.dart';
import '../../services/prayer/prayer_settings.dart';
import '../../services/qibla/qibla_service.dart';
import '../qibla/qibla_screen.dart';
import 'yearly_prayer_times_screen.dart';

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
  bool _isLoading = true;

  // Day navigation
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedSunrise;

  // Qiam vs Location toggle (true = Qiam, false = Location)
  bool _isQiamMode = true;

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

    if (mounted) {
      setState(() {
        _qiblaDirection = _qiblaService.qiblaDirection;
        _isLoading = false;
      });
    }
  }

  void _updatePrayerData() {
    final now = DateTime.now();
    final isToday = _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;

    if (isToday) {
      _prayerTimes = _prayerService.getTodayPrayerList();
      _nextPrayer = _prayerService.getNextPrayer();
      _selectedSunrise = _prayerService.sunrise;
    } else {
      _prayerTimes = _prayerService.getPrayerListForDate(_selectedDate);
      _nextPrayer = _prayerService.getNextPrayer(); // Still show countdown for today's next prayer
      _selectedSunrise = _prayerService.getSunriseForDate(_selectedDate);
    }
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _updatePrayerData();
    });
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _updatePrayerData();
    });
  }

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');

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
              // Qiam / Location toggle at the very top
              _buildModeToggle(),
              const SizedBox(height: 12),

              // Date row (and location only for Location mode)
              _buildDateLocationRow(dateFormat.format(_selectedDate)),
              const SizedBox(height: 16),

              // Circular progress indicator for next prayer
              _buildNextPrayerCircle(),
              const SizedBox(height: 24),

              // Prayer times list (with sunrise after Fajr and calendar link)
              _buildPrayerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle() {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Qiam tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isQiamMode) {
                  HapticFeedback.lightImpact();
                  setState(() => _isQiamMode = true);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isQiamMode ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      _isQiamMode
                          ? 'assets/images/logo_white.png'
                          : 'assets/images/logo.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Qiam',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: _isQiamMode ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Location tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_isQiamMode) {
                  HapticFeedback.lightImpact();
                  setState(() => _isQiamMode = false);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isQiamMode ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: !_isQiamMode ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: !_isQiamMode ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateLocationRow(String dateString) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        // Day navigation row - styled to match toggle
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Previous day button - circular
              GestureDetector(
                onTap: () => _changeDate(-1),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
              ),

              // Date display - expanded to fill space
              Expanded(
                child: GestureDetector(
                  onTap: _isToday ? null : _goToToday,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _isToday ? primaryColor : Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                dateString,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!_isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'TAP FOR TODAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Next day button - circular
              GestureDetector(
                onTap: () => _changeDate(1),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerCircle() {
    final nextPrayer = _nextPrayer!;
    final timeUntil = nextPrayer.timeUntil;
    final hours = timeUntil.inHours;
    final minutes = timeUntil.inMinutes.remainder(60);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left: Prayer info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXT PRAYER',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nextPrayer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'at ${nextPrayer.formattedTime}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                // Location - only in Location mode
                if (!_isQiamMode) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          _prayerService.locationName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Center: Qibla (tappable)
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QiblaScreen()),
                );
              },
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '🕋',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_qiblaDirection.toStringAsFixed(0)}° ${_qiblaService.qiblaCardinalDirection}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Qibla',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right: Countdown
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'remaining',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
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
        children: [
          for (int i = 0; i < _prayerTimes!.length; i++) ...[
            _buildPrayerRow(_prayerTimes![i]),
            // Add sunrise row after Fajr
            if (_prayerTimes![i].name == 'Fajr' && _selectedSunrise != null)
              _buildSunriseRow(),
          ],
          // Calendar link integrated at bottom
          _buildCalendarLink(),
        ],
      ),
    );
  }

  Widget _buildCalendarLink() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const YearlyPrayerTimesScreen()),
        );
      },
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              color: primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'View Monthly Calendar',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunriseRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.03),
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          // Sunrise icon - smaller
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.wb_sunny_outlined,
              color: Colors.orange,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),

          // Sunrise label
          Expanded(
            child: Text(
              'Sunrise',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ),

          // Sunrise time
          Text(
            DateFormat('h:mm a').format(_selectedSunrise!),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(PrayerTimeInfo prayer) {
    final isNext = prayer.isNext;
    // Only show Iqamah in Qiam mode
    String? iqamahTime;
    if (_isQiamMode) {
      final iqamahOffset = _getIqamahOffset(prayer.name);
      if (iqamahOffset != null) {
        iqamahTime = DateFormat('h:mm a').format(prayer.time.add(Duration(minutes: iqamahOffset)));
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isNext ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08) : null,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

          // Adhan time - prominent (comes first)
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

          // Iqamah time (if available, comes after Adhan)
          if (iqamahTime != null)
            Padding(
              padding: const EdgeInsets.only(left: 16),
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
                              child: Text(e.value.name),
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
