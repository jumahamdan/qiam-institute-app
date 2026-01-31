import 'package:flutter/material.dart';
import '../../services/adhan/adhan_notification_service.dart';
import '../../services/adhan/adhan_settings.dart';
import '../../services/adhan/adhan_sounds.dart';
import '../../widgets/settings/settings_section.dart';
import '../../widgets/settings/settings_tile.dart';

/// Adhan & Notifications settings sub-screen.
class AdhanSettingsScreen extends StatefulWidget {
  const AdhanSettingsScreen({super.key});

  @override
  State<AdhanSettingsScreen> createState() => _AdhanSettingsScreenState();
}

class _AdhanSettingsScreenState extends State<AdhanSettingsScreen> {
  final AdhanNotificationService _adhanService = AdhanNotificationService();

  late bool _adhanEnabled;
  late String _selectedSound;
  late bool _useSeparateFajrSound;
  late String _fajrSound;
  late bool _vibrate;
  late double _volume;
  late Map<String, bool> _prayerAdhansEnabled;
  late bool _preReminderEnabled;
  late int _preReminderMinutes;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _adhanService.stopPreview();
    super.dispose();
  }

  void _loadSettings() {
    setState(() {
      _adhanEnabled = _adhanService.isGlobalEnabled;
      _selectedSound = _adhanService.selectedSoundId;
      _useSeparateFajrSound = _adhanService.useSeparateFajrSound;
      _fajrSound = _adhanService.fajrSoundId;
      _vibrate = _adhanService.vibrateEnabled;
      _volume = _adhanService.volume;
      _prayerAdhansEnabled = _adhanService.getAllPrayerStates();
      _preReminderEnabled = _adhanService.preReminderEnabled;
      _preReminderMinutes = _adhanService.preReminderMinutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhan & Notifications'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 8, bottom: 16 + bottomSafeArea),
        children: [
          // ========== ADHAN SOUND SECTION ==========
          SettingsSection(
            title: 'Adhan Sound',
            icon: Icons.volume_up,
            children: [
              SettingsTile.toggle(
                icon: _adhanEnabled ? Icons.notifications_active : Icons.notifications_off,
                title: 'Enable Adhan',
                subtitle: 'Play adhan audio at prayer times',
                value: _adhanEnabled,
                onChanged: (value) async {
                  setState(() => _adhanEnabled = value);
                  await _adhanService.setGlobalEnabled(value);
                },
                iconColor: _adhanEnabled ? primaryColor : null,
              ),
              if (_adhanEnabled) ...[
                SettingsTile.value(
                  icon: Icons.music_note,
                  title: 'Adhan Sound',
                  value: AdhanSoundCatalog.getById(_selectedSound)?.name ?? 'Makkah',
                  onTap: _showAdhanSoundPicker,
                ),
                SettingsTile.toggle(
                  icon: Icons.wb_twilight,
                  title: 'Different Sound for Fajr',
                  subtitle: 'Traditional Fajr adhan has unique melody',
                  value: _useSeparateFajrSound,
                  onChanged: (value) async {
                    setState(() => _useSeparateFajrSound = value);
                    await _adhanService.setFajrSoundSettings(value, _fajrSound);
                  },
                ),
                if (_useSeparateFajrSound)
                  SettingsTile.value(
                    icon: Icons.music_note,
                    title: 'Fajr Adhan Sound',
                    value: AdhanSoundCatalog.getById(_fajrSound)?.name ?? 'Fajr - Makkah',
                    onTap: _showFajrSoundPicker,
                  ),
                // Volume slider
                _buildVolumeSlider(primaryColor),
                SettingsTile.toggle(
                  icon: Icons.vibration,
                  title: 'Vibration',
                  subtitle: 'Vibrate when adhan notification appears',
                  value: _vibrate,
                  onChanged: (value) async {
                    setState(() => _vibrate = value);
                    await _adhanService.setVibrateEnabled(value);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.play_circle_outline, color: primaryColor),
                  title: const Text('Preview Sound'),
                  subtitle: const Text('Play a sample of the selected adhan'),
                  onTap: () => _previewCurrentSound(),
                ),
              ],
            ],
          ),

          // ========== PRAYER ALERTS SECTION ==========
          if (_adhanEnabled)
            SettingsSection(
              title: 'Prayer Alerts',
              icon: Icons.checklist,
              children: [
                for (final prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'])
                  SettingsTile.toggle(
                    icon: Icons.access_time,
                    title: prayer,
                    value: _prayerAdhansEnabled[prayer] ?? true,
                    onChanged: (value) async {
                      setState(() => _prayerAdhansEnabled[prayer] = value);
                      await _adhanService.setPrayerEnabled(prayer, value);
                    },
                  ),
              ],
            ),

          // ========== PRE-PRAYER REMINDER SECTION ==========
          if (_adhanEnabled)
            SettingsSection(
              title: 'Pre-Prayer Reminder',
              icon: Icons.alarm,
              children: [
                SettingsTile.toggle(
                  icon: Icons.notifications_paused,
                  title: 'Enable Reminder',
                  subtitle: 'Get notified before prayer time',
                  value: _preReminderEnabled,
                  onChanged: (value) async {
                    setState(() => _preReminderEnabled = value);
                    await _adhanService.setPreReminder(value, _preReminderMinutes);
                  },
                ),
                if (_preReminderEnabled)
                  SettingsTile.value(
                    icon: Icons.timer,
                    title: 'Minutes Before',
                    value: '$_preReminderMinutes minutes',
                    onTap: _showPreReminderPicker,
                  ),
              ],
            ),

          // ========== BATTERY OPTIMIZATION WARNING ==========
          _buildBatteryOptimizationCard(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildVolumeSlider(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.volume_down, color: Colors.grey[600]),
          Expanded(
            child: Slider(
              value: _volume,
              activeColor: primaryColor,
              onChanged: (value) => setState(() => _volume = value),
              onChangeEnd: (value) async {
                await _adhanService.setVolume(value);
              },
            ),
          ),
          Icon(Icons.volume_up, color: Colors.grey[600]),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '${(_volume * 100).round()}%',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryOptimizationCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.battery_alert, color: Colors.amber[700]),
                const SizedBox(width: 8),
                const Text(
                  'Battery Optimization',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'For reliable adhan notifications, you may need to disable battery optimization for this app in your device settings.',
              style: TextStyle(color: Colors.amber[900], fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(
              'Go to: Settings > Apps > Qiam Institute > Battery > Unrestricted',
              style: TextStyle(
                color: Colors.amber[800],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdhanSoundPicker() {
    _showSoundPickerBottomSheet(
      title: 'Select Adhan Sound',
      sounds: AdhanSoundCatalog.regularSounds,
      selectedId: _selectedSound,
      onSelect: (id) async {
        setState(() => _selectedSound = id);
        await _adhanService.setSelectedSound(id);
      },
    );
  }

  void _showFajrSoundPicker() {
    _showSoundPickerBottomSheet(
      title: 'Select Fajr Adhan Sound',
      sounds: AdhanSoundCatalog.fajrSounds,
      selectedId: _fajrSound,
      onSelect: (id) async {
        setState(() => _fajrSound = id);
        await _adhanService.setFajrSoundSettings(true, id);
      },
    );
  }

  void _showSoundPickerBottomSheet({
    required String title,
    required List<AdhanSound> sounds,
    required String selectedId,
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
              ...sounds.map((sound) {
                final isSelected = selectedId == sound.id;
                return ListTile(
                  leading: isSelected
                      ? Icon(Icons.check_circle, color: primaryColor)
                      : Icon(Icons.circle_outlined, color: Colors.grey[400]),
                  title: Text(
                    sound.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? primaryColor : null,
                    ),
                  ),
                  subtitle: Text(sound.nameArabic),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_circle_outline),
                    onPressed: () => _previewSound(sound),
                  ),
                  onTap: () {
                    onSelect(sound.id);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    ).then((_) => _adhanService.stopPreview());
  }

  void _showPreReminderPicker() {
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
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Minutes Before Prayer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final minutes in AdhanSettings.preReminderOptions)
                ListTile(
                  leading: _preReminderMinutes == minutes
                      ? Icon(Icons.check_circle, color: primaryColor)
                      : Icon(Icons.circle_outlined, color: Colors.grey[400]),
                  title: Text(
                    '$minutes minutes',
                    style: TextStyle(
                      fontWeight: _preReminderMinutes == minutes ? FontWeight.w600 : FontWeight.normal,
                      color: _preReminderMinutes == minutes ? primaryColor : null,
                    ),
                  ),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    setState(() => _preReminderMinutes = minutes);
                    await _adhanService.setPreReminder(true, minutes);
                    if (mounted) navigator.pop();
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _previewCurrentSound() async {
    final sound = AdhanSoundCatalog.getById(_selectedSound);
    if (sound != null) {
      await _previewSound(sound);
    }
  }

  Future<void> _previewSound(AdhanSound sound) async {
    await _adhanService.previewSound(sound);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playing preview: ${sound.name}'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Stop',
            onPressed: () => _adhanService.stopPreview(),
          ),
        ),
      );
    }
  }
}
