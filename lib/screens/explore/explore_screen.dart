import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover programs, events, and ways to get involved',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _ExploreCard(
                    icon: Icons.event,
                    title: 'Events',
                    subtitle: 'Upcoming programs',
                    color: const Color(0xFF4CAF50),
                    onTap: () => _launchUrl(AppConstants.eventsUrl),
                  ),
                  _ExploreCard(
                    icon: Icons.favorite,
                    title: 'Our Values',
                    subtitle: 'What we stand for',
                    color: const Color(0xFFE91E63),
                    onTap: () => Navigator.pushNamed(context, '/values'),
                  ),
                  _ExploreCard(
                    icon: Icons.people,
                    title: 'Volunteer',
                    subtitle: 'Join our team',
                    color: const Color(0xFF2196F3),
                    onTap: () => Navigator.pushNamed(context, '/volunteer'),
                  ),
                  _ExploreCard(
                    icon: Icons.play_circle_filled,
                    title: 'Media',
                    subtitle: 'Videos & content',
                    color: const Color(0xFFFF5722),
                    onTap: () => Navigator.pushNamed(context, '/media'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl(AppConstants.donateUrl),
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Support Qiam Institute'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
