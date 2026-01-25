import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/prayer/prayer_screen.dart';
import 'screens/qibla/qibla_screen.dart';
import 'screens/volunteer/volunteer_screen.dart';
import 'screens/values/values_screen.dart';
import 'screens/media/media_screen.dart';
import 'screens/islamic_calendar/islamic_calendar_screen.dart';
import 'screens/duaa/duaa_screen.dart';
import 'screens/settings/settings_screen.dart';

class QiamApp extends StatelessWidget {
  const QiamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiam Institute',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
      routes: {
        '/volunteer': (context) => const VolunteerScreen(),
        '/values': (context) => const ValuesScreen(),
        '/media': (context) => const MediaScreen(),
        '/qibla': (context) => const QiblaScreen(),
        '/islamic-calendar': (context) => const IslamicCalendarScreen(),
        '/duaa': (context) => const DuaaScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    PrayerScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _MoreMenuItem(
              icon: Icons.location_on,
              label: 'Qibla Direction',
              subtitle: 'Find the direction to Makkah',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/qibla');
              },
            ),
            _MoreMenuItem(
              icon: Icons.calendar_month,
              label: 'Islamic Calendar',
              subtitle: 'Important Islamic dates',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/islamic-calendar');
              },
            ),
            _MoreMenuItem(
              icon: Icons.nights_stay,
              label: 'Daily Duaa',
              subtitle: 'Supplications for daily life',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/duaa');
              },
            ),
            _MoreMenuItem(
              icon: Icons.settings,
              label: 'Settings',
              subtitle: 'Prayer times and app settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.mosque_outlined),
              selectedIcon: Icon(Icons.mosque),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.access_time_outlined),
              selectedIcon: Icon(Icons.access_time_filled),
              label: 'Timings',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMoreMenu,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.more_horiz, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreMenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
