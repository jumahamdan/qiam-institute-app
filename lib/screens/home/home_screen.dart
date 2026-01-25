import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/constants.dart';
import '../../services/prayer/prayer_service.dart';
import '../../services/events/events_service.dart';
import '../../models/event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayerService = PrayerService();
  final EventsService _eventsService = EventsService();
  NextPrayerInfo? _nextPrayer;
  Timer? _timer;
  late YoutubePlayerController _youtubeController;
  bool _isLoading = true;
  List<Event> _events = [];
  bool _eventsLoading = true;

  @override
  void initState() {
    super.initState();
    _initServices();
    _loadEvents();

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

  Future<void> _loadEvents() async {
    try {
      final response = await _eventsService.getUpcomingEvents(perPage: 10);
      if (mounted) {
        setState(() {
          _events = response.events;
          _eventsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _eventsLoading = false);
      }
    }
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
      child: Column(
        children: [
          // Fixed top section
          Padding(
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
                const SizedBox(height: 16),

                // Next Prayer Card - compact
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: _isLoading || _nextPrayer == null
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            children: [
                              Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Next: ${_nextPrayer!.name}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  Text('${_nextPrayer!.formattedTime} • in ${_nextPrayer!.formattedTimeUntil}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => _launchUrl(AppConstants.donateUrl),
                                child: const Text('Donate'),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Events header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming Events',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/events'),
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable events section
          Expanded(
            child: _eventsLoading
                ? const Center(child: CircularProgressIndicator())
                : _events.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_available, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('No upcoming events', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return _EventMiniCard(
                            event: event,
                            onTap: () => _launchUrl(event.url ?? AppConstants.eventsUrl),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _EventMiniCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const _EventMiniCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Date box
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.startDate.day.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getMonthAbbr(event.startDate.month),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Event info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.formattedTime,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    if (event.venue != null)
                      Text(
                        event.venue!.name,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
