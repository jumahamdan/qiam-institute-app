import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../config/constants.dart';
import '../../services/prayer/prayer_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayerService = PrayerService();
  NextPrayerInfo? _nextPrayer;
  Timer? _timer;
  late YoutubePlayerController _youtubeController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initServices();

    final videoId = YoutubePlayer.convertUrlToId(AppConstants.introVideoUrl) ?? '9qcNe2NSThE';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: false,
      ),
    );
  }

  Future<void> _initServices() async {
    await _prayerService.initialize();
    if (mounted) {
      setState(() {
        _nextPrayer = _prayerService.getNextPrayer();
        _isLoading = false;
      });
    }

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() => _nextPrayer = _prayerService.getNextPrayer());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _youtubeController.dispose();
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Video Player
            Card(
              clipBehavior: Clip.antiAlias,
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
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Next Prayer Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _isLoading || _nextPrayer == null
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          Text('NEXT PRAYER',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                    letterSpacing: 1.2,
                                  )),
                          const SizedBox(height: 8),
                          Text(_nextPrayer!.name,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(_nextPrayer!.formattedTime,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  )),
                          const SizedBox(height: 8),
                          Text('in ${_nextPrayer!.formattedTimeUntil}',
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

            // Social Media
            Text('Connect With Us', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SocialButton(icon: FontAwesomeIcons.facebook, color: const Color(0xFF1877F2), onTap: () => _launchUrl(AppConstants.facebookUrl)),
                _SocialButton(icon: FontAwesomeIcons.xTwitter, color: const Color(0xFF000000), onTap: () => _launchUrl(AppConstants.twitterUrl)),
                _SocialButton(icon: FontAwesomeIcons.youtube, color: const Color(0xFFFF0000), onTap: () => _launchUrl(AppConstants.youtubeUrl)),
                _SocialButton(icon: FontAwesomeIcons.instagram, color: const Color(0xFFE4405F), onTap: () => _launchUrl(AppConstants.instagramUrl)),
                _SocialButton(icon: FontAwesomeIcons.tiktok, color: const Color(0xFF000000), onTap: () => _launchUrl(AppConstants.tiktokUrl)),
                _SocialButton(icon: FontAwesomeIcons.flickr, color: const Color(0xFF0063DC), onTap: () => _launchUrl(AppConstants.flickrUrl)),
              ],
            ),
            const SizedBox(height: 16),
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

  const _SocialButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Center(
          child: FaIcon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
