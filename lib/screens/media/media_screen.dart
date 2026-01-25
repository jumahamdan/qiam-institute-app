import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return just the body - MainNavigation provides the Scaffold and AppBar
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // YouTube Section
            _MediaSection(
              icon: Icons.play_circle_fill,
              iconColor: const Color(0xFFFF0000),
              title: 'YouTube Channel',
              description: 'Watch lectures, khutbahs, and educational content',
              buttonText: 'Visit YouTube Channel',
              onTap: () => _launchUrl(AppConstants.youtubeUrl),
            ),
            const SizedBox(height: 16),

            // Instagram Section
            _MediaSection(
              icon: Icons.camera_alt,
              iconColor: const Color(0xFFE4405F),
              title: 'Instagram',
              description: 'Follow us for updates, reminders, and community highlights',
              buttonText: 'Follow on Instagram',
              onTap: () => _launchUrl(AppConstants.instagramUrl),
            ),
            const SizedBox(height: 16),

            // Facebook Section
            _MediaSection(
              icon: Icons.facebook,
              iconColor: const Color(0xFF1877F2),
              title: 'Facebook',
              description: 'Join our community and stay connected with events',
              buttonText: 'Like on Facebook',
              onTap: () => _launchUrl(AppConstants.facebookUrl),
            ),
            const SizedBox(height: 24),

            // Featured Content Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Featured Content',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _FeaturedItem(
                      title: 'Weekly Lectures',
                      subtitle: 'Educational sessions every week',
                      icon: Icons.school,
                      onTap: () => _launchUrl(AppConstants.youtubeUrl),
                    ),
                    const Divider(),
                    _FeaturedItem(
                      title: 'Friday Khutbahs',
                      subtitle: 'Inspiring sermons from our community',
                      icon: Icons.mosque,
                      onTap: () => _launchUrl(AppConstants.youtubeUrl),
                    ),
                    const Divider(),
                    _FeaturedItem(
                      title: 'Community Events',
                      subtitle: 'Highlights and recordings',
                      icon: Icons.celebration,
                      onTap: () => _launchUrl(AppConstants.youtubeUrl),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Subscribe CTA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Stay Updated',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Subscribe to our YouTube channel and follow us on social media for the latest content',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _launchUrl(AppConstants.youtubeUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text('Subscribe Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _MediaSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const _MediaSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FeaturedItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
