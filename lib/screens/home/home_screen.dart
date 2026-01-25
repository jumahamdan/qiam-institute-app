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
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _nextPrayer = _prayerService.getNextPrayer());
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
      appBar: AppBar(
        title: const Text('Qiam Institute'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            tooltip: 'Get Directions',
            onPressed: () => _launchUrl(AppConstants.directionsUrl),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.asset('assets/images/logo.png', height: 80),
              ),
              const SizedBox(height: 16),

              // Video Intro
              _buildVideoSection(context),
              const SizedBox(height: 20),

              // Next Prayer Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('NEXT PRAYER',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                letterSpacing: 1.2,
                              )),
                      const SizedBox(height: 8),
                      Text(_nextPrayer.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(_nextPrayer.formattedTime,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                      const SizedBox(height: 8),
                      Text('in ${_nextPrayer.formattedTimeUntil}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Donate Button
              ElevatedButton.icon(
                onPressed: () => _launchUrl(AppConstants.donateUrl),
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Donate Now'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
              const SizedBox(height: 24),

              // Quick Links
              Text('Explore', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.9,
                children: [
                  _QuickLinkItem(icon: Icons.event, label: 'Events', onTap: () => _launchUrl(AppConstants.eventsUrl)),
                  _QuickLinkItem(icon: Icons.favorite, label: 'Values', onTap: () => Navigator.pushNamed(context, '/values')),
                  _QuickLinkItem(icon: Icons.people, label: 'Volunteer', onTap: () => Navigator.pushNamed(context, '/volunteer')),
                  _QuickLinkItem(icon: Icons.play_circle, label: 'Media', onTap: () => Navigator.pushNamed(context, '/media')),
                ],
              ),
              const SizedBox(height: 24),

              // Social Media
              Text('Connect With Us', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(icon: Icons.facebook, color: const Color(0xFF1877F2), onTap: () => _launchUrl(AppConstants.facebookUrl)),
                  const SizedBox(width: 16),
                  _SocialButton(icon: Icons.camera_alt, color: const Color(0xFFE4405F), onTap: () => _launchUrl(AppConstants.instagramUrl)),
                  const SizedBox(width: 16),
                  _SocialButton(icon: Icons.play_circle_fill, color: const Color(0xFFFF0000), onTap: () => _launchUrl(AppConstants.youtubeUrl)),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Contact Us', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => _launchUrl('tel:${AppConstants.contactPhone}'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 18, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(AppConstants.contactPhone, style: TextStyle(color: Colors.grey[700])),
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
                            Text(AppConstants.contactEmail, style: TextStyle(color: Colors.grey[700])),
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
                            child: Text(AppConstants.address, style: TextStyle(color: Colors.grey[700]), textAlign: TextAlign.center),
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

  Widget _buildVideoSection(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchUrl(AppConstants.introVideoUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  AppConstants.introVideoThumbnail,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(Icons.play_circle_outline, size: 60, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Watch Our Introduction',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Learn about Qiam Institute', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new, color: Theme.of(context).colorScheme.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickLinkItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
