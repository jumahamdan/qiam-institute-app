import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../services/prayer/prayer_service.dart';
import '../../services/prayer/prayer_settings.dart';
import '../../services/location/location_service.dart';
import 'location_search_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PrayerService _prayerService = PrayerService();
  final LocationService _locationService = LocationService();

  late String _calculationMethod;
  late String _asrMethod;
  late String _locationName;
  late bool _autoDetectLocation;
  late bool _useFixedCalculation;
  late String _highLatitudeRule;
  late String _daylightSaving;
  late int _imsakMinutes;
  late Map<String, int> _corrections;

  bool _isLoadingLocation = false;
  bool _showAllMethods = false;

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
      _useFixedCalculation = settings.useFixedCalculation;
      _highLatitudeRule = settings.highLatitudeRule;
      _daylightSaving = settings.daylightSaving;
      _imsakMinutes = settings.imsakMinutes;
      _corrections = Map.from(settings.allCorrections);
    });
  }

  Future<void> _updateSetting({
    String? calculationMethod,
    String? asrMethod,
    bool? autoDetectLocation,
    bool? useFixedCalculation,
    String? highLatitudeRule,
    String? daylightSaving,
    int? imsakMinutes,
  }) async {
    if (calculationMethod != null) setState(() => _calculationMethod = calculationMethod);
    if (asrMethod != null) setState(() => _asrMethod = asrMethod);
    if (autoDetectLocation != null) setState(() => _autoDetectLocation = autoDetectLocation);
    if (useFixedCalculation != null) setState(() => _useFixedCalculation = useFixedCalculation);
    if (highLatitudeRule != null) setState(() => _highLatitudeRule = highLatitudeRule);
    if (daylightSaving != null) setState(() => _daylightSaving = daylightSaving);
    if (imsakMinutes != null) setState(() => _imsakMinutes = imsakMinutes);

    await _prayerService.updateSettings(
      calculationMethod: calculationMethod,
      asrMethod: asrMethod,
      autoDetectLocation: autoDetectLocation,
      useFixedCalculation: useFixedCalculation,
      highLatitudeRule: highLatitudeRule,
      daylightSaving: daylightSaving,
      imsakMinutes: imsakMinutes,
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

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // ========== LOCATION SECTION ==========
        _buildSectionCard(
          title: 'Location',
          icon: Icons.location_on,
          children: [
            // Current Location Display
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.place, color: primaryColor),
              ),
              title: const Text('Prayer Location'),
              subtitle: Text(_locationName),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openLocationSearch,
            ),

            // Use Current Location Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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

            const Divider(height: 1),

            // Auto-Detect Location Toggle
            SwitchListTile(
              secondary: Icon(Icons.gps_fixed, color: Colors.grey[600]),
              title: const Text('Auto-Detect Location'),
              subtitle: const Text('Use device GPS for prayer times'),
              value: _autoDetectLocation,
              activeTrackColor: primaryColor.withValues(alpha: 0.5),
              activeThumbColor: primaryColor,
              onChanged: (value) async {
                await _updateSetting(autoDetectLocation: value);
                if (value) {
                  _useCurrentLocation();
                }
              },
            ),

            // Note about manual location
            if (!_autoDetectLocation)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Auto-detect is turned off. Location must be updated manually.',
                          style: TextStyle(fontSize: 12, color: Colors.amber[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        // ========== PRAYER CALCULATION SECTION ==========
        _buildSectionCard(
          title: 'Prayer Calculation',
          icon: Icons.calculate,
          children: [
            // Fixed Calculation Mode Toggle
            SwitchListTile(
              secondary: Icon(Icons.tune, color: Colors.grey[600]),
              title: const Text('Fixed Calculation Mode'),
              subtitle: const Text('Use fixed angles instead of location-based'),
              value: _useFixedCalculation,
              activeTrackColor: primaryColor.withValues(alpha: 0.5),
              activeThumbColor: primaryColor,
              onChanged: (value) => _updateSetting(useFixedCalculation: value),
            ),

            const Divider(height: 1),

            // Current Calculation Method
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.verified, color: primaryColor),
              ),
              title: Text(
                PrayerSettings.calculationMethods[_calculationMethod]?.name ?? _calculationMethod,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                PrayerSettings.calculationMethods[_calculationMethod]?.anglesDisplay ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              trailing: Icon(
                _showAllMethods ? Icons.expand_less : Icons.expand_more,
                color: primaryColor,
              ),
              onTap: () => setState(() => _showAllMethods = !_showAllMethods),
            ),

            // Expandable Method List
            if (_showAllMethods) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'SELECT CALCULATION METHOD',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...PrayerSettings.calculationMethods.entries.map((entry) {
                final isSelected = _calculationMethod == entry.key;
                return ListTile(
                  dense: true,
                  leading: isSelected
                      ? Icon(Icons.check_circle, color: primaryColor, size: 20)
                      : Icon(Icons.circle_outlined, color: Colors.grey[400], size: 20),
                  title: Text(
                    entry.value.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? primaryColor : null,
                    ),
                  ),
                  subtitle: Text(
                    entry.value.anglesDisplay,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  onTap: () {
                    _updateSetting(calculationMethod: entry.key);
                    setState(() => _showAllMethods = false);
                  },
                );
              }),
            ],
          ],
        ),

        // ========== ADVANCED SETTINGS SECTION ==========
        _buildSectionCard(
          title: 'Advanced Settings',
          icon: Icons.settings,
          children: [
            // Asr Calculation Method
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.grey[600]),
              title: const Text('Asr Calculation'),
              subtitle: Text(PrayerSettings.asrMethods[_asrMethod] ?? _asrMethod),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showAsrMethodPicker,
            ),

            const Divider(height: 1),

            // High Latitude Adjustment
            ListTile(
              leading: Icon(Icons.north, color: Colors.grey[600]),
              title: const Text('High Latitude Rule'),
              subtitle: Text(PrayerSettings.highLatitudeRules[_highLatitudeRule] ?? _highLatitudeRule),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showHighLatitudePicker,
            ),

            const Divider(height: 1),

            // Daylight Saving Time
            ListTile(
              leading: Icon(Icons.wb_sunny, color: Colors.grey[600]),
              title: const Text('Daylight Saving Time'),
              subtitle: Text(PrayerSettings.daylightSavingOptions[_daylightSaving] ?? _daylightSaving),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showDaylightSavingPicker,
            ),

            const Divider(height: 1),

            // Imsak Minutes
            ListTile(
              leading: Icon(Icons.nightlight_round, color: Colors.grey[600]),
              title: const Text('Imsak'),
              subtitle: Text('$_imsakMinutes minutes before Fajr'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _imsakMinutes > 0
                        ? () => _updateSetting(imsakMinutes: _imsakMinutes - 5)
                        : null,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$_imsakMinutes',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: _imsakMinutes < 30
                        ? () => _updateSetting(imsakMinutes: _imsakMinutes + 5)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),

        // ========== MANUAL CORRECTIONS SECTION ==========
        _buildSectionCard(
          title: 'Manual Corrections',
          icon: Icons.tune,
          subtitle: 'Adjust prayer times in minutes',
          children: [
            ..._corrections.entries.map((entry) {
              return _buildCorrectionTile(entry.key, entry.value);
            }),
          ],
        ),

        // ========== ABOUT SECTION ==========
        _buildSectionCard(
          title: 'About',
          icon: Icons.info_outline,
          children: [
            ListTile(
              leading: Icon(Icons.apps, color: Colors.grey[600]),
              title: const Text('App Version'),
              subtitle: Text(AppConstants.appVersion),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.code, color: Colors.grey[600]),
              title: const Text('Prayer Calculation'),
              subtitle: const Text('Powered by Adhan library'),
            ),
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    String? subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '• $subtitle',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCorrectionTile(String prayer, int minutes) {
    final isPositive = minutes > 0;
    final isNegative = minutes < 0;

    return ListTile(
      dense: true,
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
              color: isPositive
                  ? Colors.green[50]
                  : isNegative
                      ? Colors.red[50]
                      : Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${minutes >= 0 ? '+' : ''}$minutes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isPositive
                    ? Colors.green[700]
                    : isNegative
                        ? Colors.red[700]
                        : Colors.grey[600],
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

  void _showDaylightSavingPicker() {
    _showPickerBottomSheet(
      title: 'Daylight Saving Time',
      items: PrayerSettings.daylightSavingOptions.entries.map((e) {
        return _PickerItem(key: e.key, title: e.value);
      }).toList(),
      selectedKey: _daylightSaving,
      onSelect: (key) => _updateSetting(daylightSaving: key),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Container(
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
              ...items.map((item) {
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
              }),
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
