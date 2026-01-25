import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/constants.dart';
import '../../services/prayer/prayer_service.dart';
import '../../services/events/events_service.dart';
import '../../models/event.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int screenIndex, String title)? onNavigate;

  const HomeScreen({super.key, this.onNavigate});

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

  // Core values data (top 3 to display)
  static const List<Map<String, String>> _coreValues = [
    {'name': 'Humility', 'arabic': 'تواضع', 'description': 'Recognizing one\'s smallness before Allah, avoiding pride always.', 'image': 'Tawado3.png'},
    {'name': 'Justice', 'arabic': 'عدل', 'description': 'Upholding fairness, equity, and truth in all dealings—personal and societal.', 'image': '3adl.png'},
    {'name': 'Compassion', 'arabic': 'رحمة', 'description': 'Emulating the mercy of Allah in our interactions with all of creation.', 'image': 'Rahma.png'},
  ];

  @override
  void initState() {
    super.initState();
    _initServices();
    _loadEvents();

    final videoId = YoutubePlayer.convertUrlToId(AppConstants.introVideoUrl) ?? '9qcNe2NSThE';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
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

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() => _nextPrayer = _prayerService.getNextPrayer());
      }
    });
  }

  Future<void> _loadEvents() async {
    try {
      // Load more events, then take top 3 after sorting (same as events screen)
      final response = await _eventsService.getUpcomingEvents(perPage: 20);
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Video Player
                  _buildVideoCard(),
                  const SizedBox(height: 16),

                  // Values Section
                  _buildValuesSection(),
                  const SizedBox(height: 16),

                  // Next Prayer Card - Condensed
                  _buildPrayerCard(),
                  const SizedBox(height: 12),

                  // Support Qiam Button - under prayer card
                  SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(AppConstants.donateUrl),
                      icon: const Icon(Icons.volunteer_activism, size: 18),
                      label: const Text('Support Qiam Institute'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Upcoming Events Section
                  _buildEventsSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoCard() {
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

  Widget _buildPrayerCard() {
    if (_isLoading || _nextPrayer == null) {
      return Card(
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(12),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Row(
          children: [
            // Left side: Next Prayer label, name and countdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NEXT PRAYER',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        _nextPrayer!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'in ${_nextPrayer!.formattedTimeUntil}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right side: TIME
            Text(
              _nextPrayer!.formattedTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValuesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Our Values',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton(
              onPressed: () {
                if (widget.onNavigate != null) {
                  widget.onNavigate!(11, 'Our Values');
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 36),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('See All'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: _coreValues.map((value) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: value != _coreValues.last ? 8 : 0,
                ),
                child: _ValueMiniCard(
                  name: value['name']!,
                  arabic: value['arabic']!,
                  imagePath: 'assets/images/values/${value['image']}',
                  onTap: () {
                    if (widget.onNavigate != null) {
                      widget.onNavigate!(11, 'Our Values');
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Events',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton(
              onPressed: () {
                if (widget.onNavigate != null) {
                  widget.onNavigate!(10, 'Events');
                } else {
                  Navigator.pushNamed(context, '/events');
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 36),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('See All'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Events list
        if (_eventsLoading)
          _buildEventsLoading()
        else if (_events.isEmpty)
          _buildEventsEmpty()
        else
          _buildEventsList(),
      ],
    );
  }

  Widget _buildEventsLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 72,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventsEmpty() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.event_available, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No upcoming events',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Check back soon for new events',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadEvents,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Column(
      children: _events.take(3).map((event) {
        return _EventMiniCard(
          event: event,
          onTap: () => _launchUrl(event.url ?? AppConstants.eventsUrl),
        );
      }).toList(),
    );
  }
}

class _EventMiniCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const _EventMiniCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isToday = event.isToday;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Date box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isToday
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.startDate.day.toString(),
                      style: TextStyle(
                        color: isToday ? Colors.white : Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      _getMonthAbbr(event.startDate.month),
                      style: TextStyle(
                        color: isToday
                            ? Colors.white.withValues(alpha: 0.9)
                            : Theme.of(context).colorScheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title - Primary
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Meta line - Secondary
                    Row(
                      children: [
                        if (isToday) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'TODAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            event.formattedTime,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    // Location - Tertiary
                    if (event.venue != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          event.venue!.name,
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
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

class _ValueMiniCard extends StatelessWidget {
  final String name;
  final String arabic;
  final String imagePath;
  final VoidCallback onTap;

  const _ValueMiniCard({
    required this.name,
    required this.arabic,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 40,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.star,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                arabic,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
