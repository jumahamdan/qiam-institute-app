import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config/theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'screens/prayer/prayer_screen.dart';
import 'screens/qibla/qibla_screen.dart';
import 'screens/volunteer/volunteer_screen.dart';
import 'screens/values/values_screen.dart';
import 'screens/media/media_screen.dart';
import 'screens/islamic_calendar/islamic_calendar_screen.dart';
import 'screens/duaa/duaa_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/about/about_screen.dart';
import 'screens/contact/contact_screen.dart';

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
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
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
  // -1 = Home (logo tapped), 0 = Explore, 1 = Timings, 2 = More (bottom sheet)
  int _selectedIndex = -1; // Start on Home

  void _onItemTapped(int index) {
    if (index == 2) {
      _showMoreMenu();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _goHome() {
    setState(() {
      _selectedIndex = -1;
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
              icon: Icons.info_outline,
              label: 'About Us',
              subtitle: 'Learn about Qiam Institute',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            _MoreMenuItem(
              icon: Icons.contact_mail,
              label: 'Contact Us',
              subtitle: 'Get in touch with us',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
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

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const ExploreScreen();
      case 1:
        return const PrayerScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: _goHome,
          tooltip: 'Home',
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              'assets/images/logo_white.png',
              errorBuilder: (_, __, ___) => const Icon(Icons.mosque, color: Colors.white),
            ),
          ),
        ),
        title: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            tooltip: 'Get Directions',
            onPressed: () async {
              final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=900+S+Frontage+Rd+Suite+110+Woodridge+IL+60517');
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex >= 0 ? _selectedIndex : 0,
        indicatorColor: _selectedIndex < 0 ? Colors.transparent : null,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(Icons.access_time_filled),
            label: 'Timings',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
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
