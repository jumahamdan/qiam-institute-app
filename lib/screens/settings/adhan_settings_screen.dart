import 'package:flutter/material.dart';

import '../../services/adhan/adhan_notification_service.dart';
import '../../services/adhan/adhan_sounds.dart';

/// Advanced adhan settings screen.
class AdhanSettingsScreen extends StatefulWidget {
  const AdhanSettingsScreen({super.key});

  @override
  State<AdhanSettingsScreen> createState() => _AdhanSettingsScreenState();
}

class _AdhanSettingsScreenState extends State<AdhanSettingsScreen> {
  final AdhanNotificationService _adhanService = AdhanNotificationService();

  late String _selectedSound;
  late bool _useSeparateFajrSound;
  late String _fajrSound;
  late bool _vibrate;
  late double _volume;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _selectedSound = _adhanService.selectedSoundId;
      _useSeparateFajrSound = _adhanService.useSeparateFajrSound;
      _fajrSound = _adhanService.fajrSoundId;
      _vibrate = _adhanService.vibrateEnabled;
      _volume = _adhanService.volume;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhan Settings'),
      ),
      body: ListView(
        children: [
          // Sound Selection Section
          _buildSection(
            title: 'Adhan Sound',
            children: [
              for (final sound in AdhanSoundCatalog.regularSounds)
                RadioListTile<String>(
                  title: Text(sound.name),
                  subtitle: Text(sound.nameArabic),
                  value: sound.id,
                  groupValue: _selectedSound,
                  activeColor: primaryColor,
                  secondary: IconButton(
                    icon: Icon(Icons.play_circle_outline, color: primaryColor),
                    onPressed: () => _previewSound(sound),
                  ),
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() => _selectedSound = value);
                      await _adhanService.setSelectedSound(value);
                    }
                  },
                ),
            ],
          ),

          // Fajr Sound Section
          _buildSection(
            title: 'Fajr Adhan',
            children: [
              SwitchListTile(
                title: const Text('Use Different Sound for Fajr'),
                subtitle: const Text('Traditional Fajr adhan has unique melody'),
                value: _useSeparateFajrSound,
                activeColor: primaryColor,
                onChanged: (value) async {
                  setState(() => _useSeparateFajrSound = value);
                  await _adhanService.setFajrSoundSettings(value, _fajrSound);
                },
              ),
              if (_useSeparateFajrSound)
                for (final sound in AdhanSoundCatalog.fajrSounds)
                  RadioListTile<String>(
                    title: Text(sound.name),
                    subtitle: Text(sound.nameArabic),
                    value: sound.id,
                    groupValue: _fajrSound,
                    activeColor: primaryColor,
                    secondary: IconButton(
                      icon: Icon(Icons.play_circle_outline, color: primaryColor),
                      onPressed: () => _previewSound(sound),
                    ),
                    onChanged: (value) async {
                      if (value != null) {
                        setState(() => _fajrSound = value);
                        await _adhanService.setFajrSoundSettings(true, value);
                      }
                    },
                  ),
            ],
          ),

          // Volume Section
          _buildSection(
            title: 'Volume',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.volume_down),
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
                    const Icon(Icons.volume_up),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: Text(
                    '${(_volume * 100).round()}%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Vibration Section
          _buildSection(
            title: 'Vibration',
            children: [
              SwitchListTile(
                title: const Text('Vibrate with Adhan'),
                subtitle: const Text('Vibrate when adhan notification appears'),
                value: _vibrate,
                activeColor: primaryColor,
                onChanged: (value) async {
                  setState(() => _vibrate = value);
                  await _adhanService.setVibrateEnabled(value);
                },
              ),
            ],
          ),

          // Battery Optimization Warning
          _buildBatteryOptimizationCard(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBatteryOptimizationCard() {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.amber[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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

  Future<void> _previewSound(AdhanSound sound) async {
    await _adhanService.previewSound(sound);

    // Show snackbar
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
