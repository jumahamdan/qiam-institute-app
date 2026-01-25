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

  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.cloud;
      case 'Maghrib':
        return Icons.nights_stay_outlined;
      case 'Isha':
        return Icons.nightlight_round;
      case 'Sunset':
        return Icons.wb_twilight;
      default:
        return Icons.access_time;
    }
  }

  Color _getPrayerIconColor(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Colors.orange[300]!;
      case 'Sunrise':
        return Colors.orange;
      case 'Dhuhr':
        return Colors.amber;
      case 'Asr':
        return Colors.orange[400]!;
      case 'Maghrib':
        return Colors.deepOrange;
      case 'Isha':
        return Colors.indigo;
      case 'Sunset':
        return Colors.deepOrange[300]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return SafeArea(
      child: Column(
        children: [
          // Header with title and toggle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Timings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => _showWeekView = !_showWeekView),
                      icon: Icon(_showWeekView ? Icons.today : Icons.calendar_view_week, size: 18),
                      label: Text(_showWeekView ? 'Today' : '7-Day'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(_showWeekView ? 'Next 7 Days' : dateFormat.format(today),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(AppConstants.defaultLocationName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          if (!_showWeekView)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
              child: Row(
                children: [
                  const SizedBox(width: 44),
                  Expanded(flex: 2, child: Text('Prayer', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600], fontSize: 12))),
                  Expanded(child: Text('Adhan', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600], fontSize: 12))),
                  Expanded(child: Text('Iqamah', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600], fontSize: 12))),
                ],
              ),
            ),
          Expanded(child: _showWeekView ? _buildWeekView() : _buildTodayView()),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('${AppConstants.calculationMethod} (${AppConstants.asrCalculation})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchDonate,
                icon: const Icon(Icons.volunteer_activism),
                label: const Text('Support Qiam Institute'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayView() {
    final prayers = _prayerService.todayPrayerTimes;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: [
        ..._prayerTimes.map((p) => _buildPrayerRow(p)),
        const Divider(height: 1),
        _buildSunRow('Sunset', prayers.maghrib, Icons.wb_twilight, Colors.deepOrange[300]!),
      ],
    );
  }

  Widget _buildPrayerRow(PrayerTimeInfo prayer) {
    final iqamahOffset = AppConstants.iqamahOffsets[prayer.name];
    String? iqamahTime;
    if (iqamahOffset != null) {
      iqamahTime = DateFormat('h:mm a').format(prayer.time.add(Duration(minutes: iqamahOffset)));
    }

    return Container(
      decoration: BoxDecoration(
        color: prayer.isNext ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08) : null,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _getPrayerIconColor(prayer.name).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_getPrayerIcon(prayer.name), color: _getPrayerIconColor(prayer.name), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(prayer.name, style: TextStyle(
                  fontWeight: prayer.isNext ? FontWeight.bold : FontWeight.w500,
                  color: prayer.isNext ? Theme.of(context).colorScheme.primary : null,
                  fontSize: 16,
                )),
                if (prayer.isNext) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('NEXT', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Text(prayer.formattedTime, textAlign: TextAlign.center, style: TextStyle(
              fontWeight: prayer.isNext ? FontWeight.bold : FontWeight.w500,
              color: prayer.isNext ? Theme.of(context).colorScheme.primary : null,
            )),
          ),
          Expanded(
            child: Text(iqamahTime ?? '-', textAlign: TextAlign.center, style: TextStyle(
              fontWeight: prayer.isNext ? FontWeight.bold : FontWeight.w500,
              color: prayer.isNext ? Theme.of(context).colorScheme.primary : Colors.grey[700],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSunRow(String name, DateTime time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
          Expanded(child: Text(DateFormat('h:mm a').format(time), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500))),
          const Expanded(child: SizedBox()),
        ],
      ),
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
            label: Column(children: [
              Text(day.dayName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(day.shortDate, style: const TextStyle(fontSize: 12)),
            ]),
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
      DataCell(Row(children: [
        Icon(_getPrayerIcon(prayer), size: 16, color: _getPrayerIconColor(prayer)),
        const SizedBox(width: 8),
        Text(prayer, style: const TextStyle(fontWeight: FontWeight.w500)),
      ])),
      ...times.map((t) => DataCell(Text(t))),
    ]);
  }
}
