import 'package:flutter/material.dart';
import '../../services/prayer/prayer_service.dart';
import '../../services/prayer/prayer_settings.dart';
import '../../services/location/location_service.dart';
import '../../widgets/settings/settings_section.dart';
import '../../widgets/settings/settings_tile.dart';
import 'location_search_screen.dart';

/// Prayer times settings sub-screen.
class PrayerTimesSettingsScreen extends StatefulWidget {
  const PrayerTimesSettingsScreen({super.key});

  @override
  State<PrayerTimesSettingsScreen> createState() => _PrayerTimesSettingsScreenState();
}

class _PrayerTimesSettingsScreenState extends State<PrayerTimesSettingsScreen> {
  final PrayerService _prayerService = PrayerService();
  final LocationService _locationService = LocationService();

  late String _calculationMethod;
  late String _asrMethod;
  late String _locationName;
  late bool _autoDetectLocation;
  late String _highLatitudeRule;
  late Map<String, int> _corrections;

  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final settings = _prayerService.settings;
    setState(() {
      _calculationMethod = settings.calculationMethod;
      _asrMethod = settings.asrMethod;
      _locationName = _prayerService.locationName;
      _autoDetectLocation = settings.autoDetectLocation;
      _highLatitudeRule = settings.highLatitudeRule;
      _corrections = Map.from(settings.allCorrections);
    });
  }

  Future<void> _updateSetting({
    String? calculationMethod,
    String? asrMethod,
    bool? autoDetectLocation,
    String? highLatitudeRule,
  }) async {
    if (calculationMethod != null) setState(() => _calculationMethod = calculationMethod);
    if (asrMethod != null) setState(() => _asrMethod = asrMethod);
    if (autoDetectLocation != null) setState(() => _autoDetectLocation = autoDetectLocation);
    if (highLatitudeRule != null) setState(() => _highLatitudeRule = highLatitudeRule);

    await _prayerService.updateSettings(
      calculationMethod: calculationMethod,
      asrMethod: asrMethod,
      autoDetectLocation: autoDetectLocation,
      highLatitudeRule: highLatitudeRule,
    );
  }

  Future<void> _updateCorrection(String prayer, int minutes) async {
    setState(() => _corrections[prayer] = minutes);
    await _prayerService.updateCorrection(prayer, minutes);
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    final result = await _locationService.getCurrentLocation();

    if (result.isSuccess && result.position != null) {
      await _prayerService.updateSettings(
        locationMode: PrayerSettings.locationModeAuto,
        autoDetectLocation: true,
        latitude: result.position!.latitude,
        longitude: result.position!.longitude,
        locationName: _locationService.locationName,
      );

      setState(() {
        _locationName = _locationService.locationName;
        _autoDetectLocation = true;
        _isLoadingLocation = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location updated to ${_locationService.locationName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Failed to get location'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openLocationSearch() async {
    final result = await Navigator.push<LocationSearchResult>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationSearchScreen(),
      ),
    );

    if (result != null) {
      await _prayerService.updateSettings(
        locationMode: PrayerSettings.locationModeManual,
        autoDetectLocation: false,
        latitude: result.latitude,
        longitude: result.longitude,
        locationName: result.name,
      );

      setState(() {
        _locationName = result.name;
        _autoDetectLocation = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location updated to ${result.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 8, bottom: 16 + bottomSafeArea),
        children: [
          // ========== LOCATION SECTION ==========
          SettingsSection(
            title: 'Location',
            icon: Icons.location_on,
            children: [
              SettingsTile.navigation(
                icon: Icons.place,
                title: 'Prayer Location',
                subtitle: _locationName,
                onTap: _openLocationSearch,
              ),
              SettingsTile.toggle(
                icon: Icons.gps_fixed,
                title: 'Auto-Detect Location',
                subtitle: 'Use device GPS for prayer times',
                value: _autoDetectLocation,
                onChanged: (value) async {
                  await _updateSetting(autoDetectLocation: value);
                  if (value) {
                    _useCurrentLocation();
                  }
                },
              ),
            ],
          ),

          // Use Current Location Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: _isLoadingLocation ? null : _useCurrentLocation,
              icon: _isLoadingLocation
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    )
                  : Icon(Icons.my_location, color: primaryColor),
              label: Text(
                _isLoadingLocation ? 'Detecting...' : 'Use Current Location',
                style: TextStyle(color: primaryColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // ========== CALCULATION METHOD SECTION ==========
          SettingsSection(
            title: 'Calculation Method',
            icon: Icons.calculate,
            children: [
              SettingsTile.value(
                icon: Icons.verified,
                title: 'Method',
                subtitle: PrayerSettings.calculationMethods[_calculationMethod]?.anglesDisplay,
                value: PrayerSettings.calculationMethods[_calculationMethod]?.name ?? _calculationMethod,
                onTap: _showCalculationMethodPicker,
              ),
              SettingsTile.value(
                icon: Icons.access_time,
                title: 'Asr Calculation',
                value: PrayerSettings.asrMethods[_asrMethod] ?? _asrMethod,
                onTap: _showAsrMethodPicker,
              ),
              SettingsTile.value(
                icon: Icons.north,
                title: 'High Latitude Rule',
                value: PrayerSettings.highLatitudeRules[_highLatitudeRule] ?? _highLatitudeRule,
                onTap: _showHighLatitudePicker,
              ),
            ],
          ),

          // ========== TIME ADJUSTMENTS SECTION ==========
          SettingsSection(
            title: 'Time Adjustments',
            icon: Icons.tune,
            children: [
              for (final entry in _corrections.entries)
                _buildCorrectionTile(entry.key, entry.value),
            ],
          ),

          // Info card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Adjustments are in minutes. Use positive values to delay and negative to advance prayer times.',
                      style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectionTile(String prayer, int minutes) {
    return ListTile(
      leading: Icon(Icons.schedule, color: Colors.grey[600]),
      title: Text(prayer),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            onPressed: minutes > -30 ? () => _updateCorrection(prayer, minutes - 1) : null,
          ),
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getCorrectionBackgroundColor(minutes),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${minutes >= 0 ? '+' : ''}$minutes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: _getCorrectionTextColor(minutes),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            onPressed: minutes < 30 ? () => _updateCorrection(prayer, minutes + 1) : null,
          ),
        ],
      ),
    );
  }

  Color _getCorrectionBackgroundColor(int minutes) {
    if (minutes > 0) return Colors.green[50]!;
    if (minutes < 0) return Colors.red[50]!;
    return Colors.grey[100]!;
  }

  Color _getCorrectionTextColor(int minutes) {
    if (minutes > 0) return Colors.green[700]!;
    if (minutes < 0) return Colors.red[700]!;
    return Colors.grey[600]!;
  }

  void _showCalculationMethodPicker() {
    _showPickerBottomSheet(
      title: 'Calculation Method',
      items: PrayerSettings.calculationMethods.entries.map((e) {
        return _PickerItem(
          key: e.key,
          title: e.value.name,
          subtitle: e.value.anglesDisplay,
        );
      }).toList(),
      selectedKey: _calculationMethod,
      onSelect: (key) => _updateSetting(calculationMethod: key),
    );
  }

  void _showAsrMethodPicker() {
    _showPickerBottomSheet(
      title: 'Asr Calculation Method',
      items: PrayerSettings.asrMethods.entries.map((e) {
        return _PickerItem(
          key: e.key,
          title: e.value,
          subtitle: e.key == 'hanafi'
              ? 'Shadow is twice the length of object'
              : 'Shadow equals length of object',
        );
      }).toList(),
      selectedKey: _asrMethod,
      onSelect: (key) => _updateSetting(asrMethod: key),
    );
  }

  void _showHighLatitudePicker() {
    _showPickerBottomSheet(
      title: 'High Latitude Rule',
      items: PrayerSettings.highLatitudeRules.entries.map((e) {
        return _PickerItem(key: e.key, title: e.value);
      }).toList(),
      selectedKey: _highLatitudeRule,
      onSelect: (key) => _updateSetting(highLatitudeRule: key),
    );
  }

  void _showPickerBottomSheet({
    required String title,
    required List<_PickerItem> items,
    required String selectedKey,
    required Function(String) onSelect,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: items.map((item) {
                    final isSelected = selectedKey == item.key;
                    return ListTile(
                      leading: isSelected
                          ? Icon(Icons.check_circle, color: primaryColor)
                          : Icon(Icons.circle_outlined, color: Colors.grey[400]),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? primaryColor : null,
                        ),
                      ),
                      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                      onTap: () {
                        onSelect(item.key);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _PickerItem {
  final String key;
  final String title;
  final String? subtitle;

  _PickerItem({required this.key, required this.title, this.subtitle});
}
