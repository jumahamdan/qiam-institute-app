import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/constants.dart';

class PrayerScreen extends StatelessWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    // Placeholder prayer times - will be replaced with adhan calculations
    final prayerTimes = [
      ('Fajr', '5:47 AM', false),
      ('Sunrise', '7:08 AM', false),
      ('Dhuhr', '12:45 PM', true), // Next prayer
      ('Asr', '3:32 PM', false),
      ('Maghrib', '5:23 PM', false),
      ('Isha', '6:45 PM', false),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: Navigate to 7-day view
            },
            icon: const Icon(Icons.calendar_view_week, color: Colors.white),
            label: const Text(
              '7-Day',
              style: TextStyle(color: Colors.white),
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
                  dateFormat.format(today),
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

          // Prayer Times List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: prayerTimes.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final (name, time, isNext) = prayerTimes[index];
                return _PrayerTimeRow(
                  name: name,
                  time: time,
                  isNext: isNext,
                );
              },
            ),
          ),

          // Calculation Method Footer
          Container(
            padding: const EdgeInsets.all(16),
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
        ],
      ),
    );
  }
}

class _PrayerTimeRow extends StatelessWidget {
  final String name;
  final String time;
  final bool isNext;

  const _PrayerTimeRow({
    required this.name,
    required this.time,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isNext
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          Text(
            time,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                  color:
                      isNext ? Theme.of(context).colorScheme.primary : null,
                ),
          ),
        ],
      ),
    );
  }
}
