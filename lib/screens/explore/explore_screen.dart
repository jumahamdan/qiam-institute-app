import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/constants.dart';

class ExploreScreen extends StatefulWidget {
  final void Function(int screenIndex, String title)? onNavigate;

  const ExploreScreen({super.key, this.onNavigate});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(AppConstants.introVideoUrl) ?? '9qcNe2NSThE';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigate(BuildContext context, int screenIndex, String title, String route) {
    if (widget.onNavigate != null) {
      widget.onNavigate!(screenIndex, title);
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
            const SizedBox(height: 16),

            // Video Player at top
            _buildVideoCard(context),
            const SizedBox(height: 12),

            // Support Qiam button under video
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
            const SizedBox(height: 20),

            // Grid of explore cards
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _ExploreCard(
                  icon: Icons.event,
                  title: 'Events',
                  subtitle: 'Upcoming programs',
                  color: const Color(0xFF4CAF50),
                  onTap: () => _navigate(context, 10, 'Events', '/events'),
                ),
                _ExploreCard(
                  icon: Icons.favorite,
                  title: 'Our Values',
                  subtitle: 'What we stand for',
                  color: const Color(0xFFE91E63),
                  onTap: () => _navigate(context, 11, 'Our Values', '/values'),
                ),
                _ExploreCard(
                  icon: Icons.people,
                  title: 'Volunteer',
                  subtitle: 'Join our team',
                  color: const Color(0xFF2196F3),
                  onTap: () => _navigate(context, 13, 'Volunteer', '/volunteer'),
                ),
                _ExploreCard(
                  icon: Icons.play_circle_filled,
                  title: 'Media',
                  subtitle: 'Videos & content',
                  color: const Color(0xFFFF5722),
                  onTap: () => _navigate(context, 12, 'Media', '/media'),
                ),
                _ExploreCard(
                  icon: Icons.nights_stay,
                  title: 'Daily Duaa',
                  subtitle: 'Supplications',
                  color: const Color(0xFF9C27B0),
                  onTap: () => _navigate(context, 15, 'Daily Duaa', '/duaa'),
                ),
                _ExploreCard(
                  icon: Icons.calendar_month,
                  title: 'Islamic Calendar',
                  subtitle: 'Important dates',
                  color: const Color(0xFF795548),
                  onTap: () => _navigate(context, 16, 'Islamic Calendar', '/islamic-calendar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YoutubePlayer(
            controller: _youtubeController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The seasons change; our values don\'t.',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Qiam Institute',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.play_circle_outline, color: Colors.grey[400]),
              ],
            ),
          ),
        ],
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
