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
import 'screens/quran/quran_screen.dart';
import 'screens/tasbih/tasbih_screen.dart';
import 'screens/names_of_allah/names_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/about/about_screen.dart';
import 'screens/contact/contact_screen.dart';
import 'screens/events/events_screen.dart';

/// Path to the app logo asset
const _kLogoPath = 'assets/images/logo.png';

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
        '/events': (context) => const EventsScreen(),
        '/volunteer': (context) => const VolunteerScreen(),
        '/values': (context) => const ValuesScreen(),
        '/media': (context) => const MediaScreen(),
        '/qibla': (context) => const QiblaScreen(),
        '/islamic-calendar': (context) => const IslamicCalendarScreen(),
        '/duaa': (context) => const DuaaScreen(),
        '/quran': (context) => const QuranScreen(),
        '/tasbih': (context) => const TasbihScreen(),
        '/names-of-allah': (context) => const NamesOfAllahScreen(),
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
  // Main tabs: 0 = Home, 1 = Explore, 2 = Prayers, 3 = More (bottom sheet)
  // Secondary screens (keep bottom nav visible):
  // 10 = Events, 11 = Values, 12 = Media, 13 = Volunteer, 14 = Qibla, 15 = Duaa, 16 = Islamic Calendar
  // 20 = About, 21 = Contact, 22 = Settings
  int _selectedIndex = 0;
  String? _currentScreenTitle;

  // Dua screen search state
  bool _duaSearchActive = false;

  // Get the bottom nav index (0-3) for highlighting
  int get _bottomNavIndex {
    if (_selectedIndex >= 20) return 3; // More menu items
    if (_selectedIndex >= 10) return 1; // Explore sub-screens
    return _selectedIndex;
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      _showMoreMenu();
    } else {
      setState(() {
        _selectedIndex = index;
        _currentScreenTitle = null;
      });
    }
  }

  void _navigateTo(int screenIndex, String title) {
    setState(() {
      _selectedIndex = screenIndex;
      _currentScreenTitle = title;
    });
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Add padding for system navigation bar (Galaxy phones, etc.)
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Container(
          padding: EdgeInsets.only(top: 20, bottom: 10 + bottomPadding),
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
                icon: Icons.info_outline,
                label: 'About Us',
                subtitle: 'Learn about Qiam Institute',
                onTap: () {
                  Navigator.pop(context);
                  _navigateTo(20, 'About Us');
                },
              ),
              _MoreMenuItem(
                icon: Icons.contact_mail,
                label: 'Contact Us',
                subtitle: 'Get in touch with us',
                onTap: () {
                  Navigator.pop(context);
                  _navigateTo(21, 'Contact Us');
                },
              ),
              _MoreMenuItem(
                icon: Icons.settings,
                label: 'Settings',
                subtitle: 'Prayer times and app settings',
                onTap: () {
                  Navigator.pop(context);
                  _navigateTo(22, 'Settings');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      // Main tabs
      case 0:
        return HomeScreen(onNavigate: _navigateTo);
      case 1:
        return ExploreScreen(onNavigate: _navigateTo);
      case 2:
        return const PrayerScreen();
      // Explore sub-screens
      case 10:
        return const EventsScreen();
      case 11:
        return const ValuesScreen();
      case 12:
        return const MediaScreen();
      case 13:
        return const VolunteerScreen();
      case 14:
        return const QiblaScreen();
      case 15:
        return DuaaScreen(
          isSearchActive: _duaSearchActive,
          onSearchClose: () => setState(() => _duaSearchActive = false),
        );
      case 16:
        return const IslamicCalendarScreen();
      case 17:
        return const QuranScreen();
      case 18:
        return const TasbihScreen();
      case 19:
        return const NamesOfAllahScreen();
      // More menu screens
      case 20:
        return const AboutScreen();
      case 21:
        return const ContactScreen();
      case 22:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // Secondary screen - show back button and title
    if (_selectedIndex >= 10) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              // Go back to parent tab
              _selectedIndex = _selectedIndex >= 20 ? 0 : 1; // More items go to Home, Explore items go to Explore
              _currentScreenTitle = null;
              _duaSearchActive = false; // Reset search when leaving
            });
          },
        ),
        centerTitle: true,
        title: Text(
          _currentScreenTitle ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: _selectedIndex == 15
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _duaSearchActive = !_duaSearchActive;
                    });
                  },
                  tooltip: 'Search Duas',
                ),
              ]
            : null,
      );
    }

    // Prayer screen gets custom app bar
    if (_selectedIndex == 2) {
      return AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedIndex = 0),
            child: Image.asset(
              _kLogoPath,
              height: 32,
              errorBuilder: (_, _, _) => const Icon(Icons.mosque, color: Colors.white, size: 24),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Prayer Times',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Prayer Settings',
            onPressed: () => _navigateTo(22, 'Settings'),
          ),
        ],
      );
    }

    // Default app bar for Home and Explore
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 16, // Add left padding
      leading: const SizedBox(width: 16),
      title: GestureDetector(
        onTap: () => setState(() => _selectedIndex = 0),
        child: Image.asset(
          _kLogoPath,
          height: 40,
          errorBuilder: (_, _, _) => const Icon(Icons.mosque, color: Colors.white, size: 32),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.directions),
          tooltip: 'Get Directions',
          onPressed: () async {
            final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=900+S+Frontage+Rd+Suite+110+Woodridge+IL+60517');
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
        ),
        const SizedBox(width: 8), // Add right padding
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0, // Only allow pop (exit) when on home
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // If we didn't pop (exit), navigate to home instead
          setState(() {
            _selectedIndex = 0;
            _currentScreenTitle = null;
          });
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
        bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomNavIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: Opacity(
              opacity: 0.6,
              child: Image.asset(
                _kLogoPath,
                height: 24,
                errorBuilder: (_, _, _) => Icon(Icons.home_outlined, color: Colors.grey[600]),
              ),
            ),
            selectedIcon: Image.asset(
              _kLogoPath,
              height: 24,
              errorBuilder: (_, _, _) => Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
            ),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          const NavigationDestination(
            icon: Icon(Icons.mosque_outlined),
            selectedIcon: Icon(Icons.mosque),
            label: 'Prayers',
          ),
          const NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
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
