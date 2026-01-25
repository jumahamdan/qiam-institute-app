import 'package:flutter/material.dart';

class IslamicCalendarScreen extends StatelessWidget {
  const IslamicCalendarScreen({super.key});

  // Islamic days with approximate Gregorian dates for Hijri 1447
  static const List<Map<String, String>> _islamicDays = [
    {
      'name': 'Hijri Year Begins',
      'date': '26 June, 2025',
      'day': 'THURSDAY',
    },
    {
      'name': 'Day of Ashoora',
      'date': '5 July, 2025',
      'day': 'SATURDAY',
    },
    {
      'name': 'Ramadan',
      'date': '19 February, 2026',
      'day': 'THURSDAY',
    },
    {
      'name': 'Last 10 Days of Ramadan',
      'date': '11 March, 2026',
      'day': 'WEDNESDAY',
    },
    {
      'name': 'Eid al-Fitr',
      'date': '21 March, 2026',
      'day': 'SATURDAY',
    },
    {
      'name': '10 Days of Dhul Hajj',
      'date': '18 May, 2026',
      'day': 'MONDAY',
    },
    {
      'name': 'Day of Arafah',
      'date': '26 May, 2026',
      'day': 'TUESDAY',
    },
    {
      'name': 'Eid al-Adha',
      'date': '27 May, 2026',
      'day': 'WEDNESDAY',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Colors.white,
          ],
          stops: const [0.0, 0.3],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hijri Year Header
          const Center(
            child: Text(
              'HIJRI 1447',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Islamic Days List
          ..._islamicDays.map((day) => _IslamicDayCard(
                name: day['name']!,
                date: day['date']!,
                dayOfWeek: day['day']!,
              )),
        ],
      ),
    );
  }
}

class _IslamicDayCard extends StatelessWidget {
  final String name;
  final String date;
  final String dayOfWeek;

  const _IslamicDayCard({
    required this.name,
    required this.date,
    required this.dayOfWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            // Left side: Name
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Right side: Date and day
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dayOfWeek,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
