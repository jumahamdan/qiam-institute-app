import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/prayer/prayer_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayerService = PrayerService();
  late NextPrayerInfo _nextPrayer;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _prayerService.initialize();
    _nextPrayer = _prayerService.getNextPrayer();
    // Update every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateNextPrayer();
    });
  }

  void _updateNextPrayer() {
    setState(() {
      _nextPrayer = _prayerService.getNextPrayer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 8),

              // Next Prayer Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'NEXT PRAYER',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _nextPrayer.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _nextPrayer.formattedTime,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'in ${_nextPrayer.formattedTimeUntil}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Links Section
              Text(
                'Quick Links',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: const [
                  _QuickLinkCard(
                    icon: Icons.event,
                    label: 'Events',
                  ),
                  _QuickLinkCard(
                    icon: Icons.campaign,
                    label: 'Updates',
                  ),
                  _QuickLinkCard(
                    icon: Icons.access_time,
                    label: 'Prayer Times',
                  ),
                  _QuickLinkCard(
                    icon: Icons.explore,
                    label: 'Qibla',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickLinkCard({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Quick links - users can use bottom nav for now
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
