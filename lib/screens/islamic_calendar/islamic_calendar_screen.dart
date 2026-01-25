import 'package:flutter/material.dart';

class IslamicCalendarScreen extends StatelessWidget {
  const IslamicCalendarScreen({super.key});

  static const List<Map<String, dynamic>> _islamicDays = [
    {
      'name': 'Hijri New Year',
      'arabic': 'رأس السنة الهجرية',
      'description': 'The Islamic New Year marks the beginning of the new Hijri calendar year, commemorating the Prophet\'s migration to Medina.',
      'month': 'Muharram 1',
      'icon': Icons.celebration,
    },
    {
      'name': 'Day of Ashura',
      'arabic': 'يوم عاشوراء',
      'description': 'The 10th of Muharram, a day of fasting commemorating when Allah saved Prophet Musa and the Israelites.',
      'month': 'Muharram 10',
      'icon': Icons.water_drop,
    },
    {
      'name': 'Ramadan Begins',
      'arabic': 'بداية رمضان',
      'description': 'The blessed month of fasting, reflection, and increased worship. The month in which the Quran was revealed.',
      'month': 'Ramadan 1',
      'icon': Icons.nightlight_round,
    },
    {
      'name': 'Last 10 Days of Ramadan',
      'arabic': 'العشر الأواخر من رمضان',
      'description': 'The most blessed nights of the year, containing Laylatul Qadr (Night of Power), better than a thousand months.',
      'month': 'Ramadan 21-30',
      'icon': Icons.auto_awesome,
    },
    {
      'name': 'Eid al-Fitr',
      'arabic': 'عيد الفطر',
      'description': 'The Festival of Breaking the Fast, celebrating the completion of Ramadan with prayers, charity, and family gatherings.',
      'month': 'Shawwal 1',
      'icon': Icons.card_giftcard,
    },
    {
      'name': 'First 10 Days of Dhul Hijjah',
      'arabic': 'عشر ذي الحجة',
      'description': 'The most virtuous days of the year. Good deeds during these days are more beloved to Allah than any other time.',
      'month': 'Dhul Hijjah 1-10',
      'icon': Icons.terrain,
    },
    {
      'name': 'Day of Arafah',
      'arabic': 'يوم عرفة',
      'description': 'The 9th of Dhul Hijjah, the greatest day of Hajj. Fasting this day expiates sins of the previous and coming year.',
      'month': 'Dhul Hijjah 9',
      'icon': Icons.landscape,
    },
    {
      'name': 'Eid al-Adha',
      'arabic': 'عيد الأضحى',
      'description': 'The Festival of Sacrifice, commemorating Prophet Ibrahim\'s willingness to sacrifice his son in obedience to Allah.',
      'month': 'Dhul Hijjah 10',
      'icon': Icons.mosque,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Important Islamic Days',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Key dates in the Hijri calendar',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Islamic Days List
          ..._islamicDays.map((day) => _IslamicDayCard(
                name: day['name'],
                arabic: day['arabic'],
                description: day['description'],
                month: day['month'],
                icon: day['icon'],
              )),
        ],
    );
  }
}

class _IslamicDayCard extends StatelessWidget {
  final String name;
  final String arabic;
  final String description;
  final String month;
  final IconData icon;

  const _IslamicDayCard({
    required this.name,
    required this.arabic,
    required this.description,
    required this.month,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(arabic, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(month, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              description,
              style: TextStyle(color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
