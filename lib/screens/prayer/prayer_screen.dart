import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';
import '../../services/prayer/prayer_service.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final PrayerService _prayerService = PrayerService();
  late List<PrayerTimeInfo> _prayerTimes;
  bool _showWeekView = false;

  @override
  void initState() {
    super.initState();
    _prayerService.initialize();
    _prayerTimes = _prayerService.getTodayPrayerList();
  }

  Future<void> _launchDonate() async {
    final uri = Uri.parse(AppConstants.donateUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showWeekView = !_showWeekView;
              });
            },
            icon: Icon(
              _showWeekView ? Icons.today : Icons.calendar_view_week,
              color: Colors.white,
            ),
            label: Text(
              _showWeekView ? 'Today' : '7-Day',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date and Location Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Column(
              children: [
                Text(
                  _showWeekView ? 'Next 7 Days' : dateFormat.format(today),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppConstants.defaultLocationName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Column Headers for Today View
          if (!_showWeekView)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Prayer',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Adhan',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Iqamah',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                ],
              ),
            ),

          // Prayer Times List
          Expanded(
            child: _showWeekView ? _buildWeekView() : _buildTodayView(),
          ),

          // Calculation Method Footer
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Calculation: ${AppConstants.calculationMethod} (${AppConstants.asrCalculation})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),

          // Donate Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchDonate,
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Support Qiam Institute'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayView() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _prayerTimes.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final prayer = _prayerTimes[index];
        final iqamahOffset = AppConstants.iqamahOffsets[prayer.name];
        String? iqamahTime;
        if (iqamahOffset != null) {
          final iqamah = prayer.time.add(Duration(minutes: iqamahOffset));
          iqamahTime = DateFormat('h:mm a').format(iqamah);
        }
        return _PrayerTimeRow(
          name: prayer.name,
          time: prayer.formattedTime,
          iqamahTime: iqamahTime,
          isNext: prayer.isNext,
        );
      },
    );
  }

  Widget _buildWeekView() {
    final weekTimes = _prayerService.getWeekPrayerTimes();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        columns: [
          const DataColumn(label: Text('Prayer')),
          ...weekTimes.map((day) => DataColumn(
                label: Column(
                  children: [
                    Text(day.dayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(day.shortDate, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              )),
        ],
        rows: [
          _buildWeekRow('Fajr', weekTimes.map((d) => PrayerService.formatTime(d.prayers.fajr)).toList()),
          _buildWeekRow('Sunrise', weekTimes.map((d) => PrayerService.formatTime(d.prayers.sunrise)).toList()),
          _buildWeekRow('Dhuhr', weekTimes.map((d) => PrayerService.formatTime(d.prayers.dhuhr)).toList()),
          _buildWeekRow('Asr', weekTimes.map((d) => PrayerService.formatTime(d.prayers.asr)).toList()),
          _buildWeekRow('Maghrib', weekTimes.map((d) => PrayerService.formatTime(d.prayers.maghrib)).toList()),
          _buildWeekRow('Isha', weekTimes.map((d) => PrayerService.formatTime(d.prayers.isha)).toList()),
        ],
      ),
    );
  }

  DataRow _buildWeekRow(String prayer, List<String> times) {
    return DataRow(cells: [
      DataCell(Text(prayer, style: const TextStyle(fontWeight: FontWeight.w500))),
      ...times.map((t) => DataCell(Text(t))),
    ]);
  }
}

class _PrayerTimeRow extends StatelessWidget {
  final String name;
  final String time;
  final String? iqamahTime;
  final bool isNext;

  const _PrayerTimeRow({
    required this.name,
    required this.time,
    this.iqamahTime,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isNext
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                        color: isNext
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                ),
                if (isNext) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                    color: isNext ? Theme.of(context).colorScheme.primary : null,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              iqamahTime ?? '-',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                    color: isNext
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[700],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
