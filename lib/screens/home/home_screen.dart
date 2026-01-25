import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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

              // Donate Button
              ElevatedButton.icon(
                onPressed: () => _launchUrl(AppConstants.donateUrl),
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Donate Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                children: [
                  _QuickLinkCard(
                    icon: Icons.event,
                    label: 'Events',
                    onTap: () => _launchUrl(AppConstants.eventsUrl),
                  ),
                  _QuickLinkCard(
                    icon: Icons.favorite,
                    label: 'Our Values',
                    onTap: () => Navigator.pushNamed(context, '/values'),
                  ),
                  _QuickLinkCard(
                    icon: Icons.people,
                    label: 'Volunteer',
                    onTap: () => Navigator.pushNamed(context, '/volunteer'),
                  ),
                  _QuickLinkCard(
                    icon: Icons.play_circle,
                    label: 'Media',
                    onTap: () => Navigator.pushNamed(context, '/media'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Social Media Section
              Text(
                'Connect With Us',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    icon: Icons.facebook,
                    color: const Color(0xFF1877F2),
                    onTap: () => _launchUrl(AppConstants.facebookUrl),
                  ),
                  const SizedBox(width: 16),
                  _SocialButton(
                    icon: Icons.camera_alt,
                    color: const Color(0xFFE4405F),
                    onTap: () => _launchUrl(AppConstants.instagramUrl),
                  ),
                  const SizedBox(width: 16),
                  _SocialButton(
                    icon: Icons.play_circle_fill,
                    color: const Color(0xFFFF0000),
                    onTap: () => _launchUrl(AppConstants.youtubeUrl),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Contact Us',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => _launchUrl('tel:${AppConstants.contactPhone}'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 18, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              AppConstants.contactPhone,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _launchUrl('mailto:${AppConstants.contactEmail}'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email, size: 18, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              AppConstants.contactEmail,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              AppConstants.address,
                              style: TextStyle(color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
  final VoidCallback? onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
