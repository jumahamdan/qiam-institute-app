import 'package:flutter/material.dart';
import '../../config/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _calculationMethod = 'ISNA';
  String _asrMethod = 'Hanafi';
  bool _notificationsEnabled = true;
  int _fajrIqamah = 20;
  int _dhuhrIqamah = 15;
  int _asrIqamah = 15;
  int _maghribIqamah = 5;
  int _ishaIqamah = 15;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          // Prayer Calculation Section
          _buildSectionHeader('Prayer Calculation'),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Calculation Method'),
            subtitle: Text(_calculationMethod),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCalculationMethodPicker(),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Asr Calculation'),
            subtitle: Text(_asrMethod),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAsrMethodPicker(),
          ),
          const Divider(),

          // Iqamah Times Section
          _buildSectionHeader('Iqamah Times (minutes after Adhan)'),
          _buildIqamahTile('Fajr', _fajrIqamah, (v) => setState(() => _fajrIqamah = v)),
          _buildIqamahTile('Dhuhr', _dhuhrIqamah, (v) => setState(() => _dhuhrIqamah = v)),
          _buildIqamahTile('Asr', _asrIqamah, (v) => setState(() => _asrIqamah = v)),
          _buildIqamahTile('Maghrib', _maghribIqamah, (v) => setState(() => _maghribIqamah = v)),
          _buildIqamahTile('Isha', _ishaIqamah, (v) => setState(() => _ishaIqamah = v)),
          const Divider(),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Prayer Notifications'),
            subtitle: const Text('Get notified before each prayer'),
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          const Divider(),

          // About Section
          _buildSectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: Text(AppConstants.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Location'),
            subtitle: Text(AppConstants.defaultLocationName),
          ),
          const SizedBox(height: 24),

          // Note
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.amber[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Settings are saved locally. Some features will be available in future updates.',
                        style: TextStyle(color: Colors.amber[900], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildIqamahTile(String prayer, int value, Function(int) onChanged) {
    return ListTile(
      title: Text(prayer),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: value > 0 ? () => onChanged(value - 5) : null,
          ),
          SizedBox(
            width: 50,
            child: Text(
              '$value min',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: value < 60 ? () => onChanged(value + 5) : null,
          ),
        ],
      ),
    );
  }

  void _showCalculationMethodPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Calculation Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...[
            {'name': 'ISNA', 'desc': 'Islamic Society of North America'},
            {'name': 'MWL', 'desc': 'Muslim World League'},
            {'name': 'Egypt', 'desc': 'Egyptian General Authority'},
            {'name': 'Makkah', 'desc': 'Umm Al-Qura University'},
            {'name': 'Karachi', 'desc': 'University of Islamic Sciences'},
          ].map((m) => ListTile(
                title: Text(m['name']!),
                subtitle: Text(m['desc']!),
                trailing: _calculationMethod == m['name'] ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  setState(() => _calculationMethod = m['name']!);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAsrMethodPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Asr Calculation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Hanafi'),
            subtitle: const Text('Shadow is twice the length of object'),
            trailing: _asrMethod == 'Hanafi' ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              setState(() => _asrMethod = 'Hanafi');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Shafi\'i / Hanbali / Maliki'),
            subtitle: const Text('Shadow equals length of object'),
            trailing: _asrMethod != 'Hanafi' ? const Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              setState(() => _asrMethod = 'Standard');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
