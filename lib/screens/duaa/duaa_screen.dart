import 'package:flutter/material.dart';

class DuaaScreen extends StatelessWidget {
  const DuaaScreen({super.key});

  static const List<Map<String, String>> _duaas = [
    {
      'title': 'Morning Remembrance',
      'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      'transliteration': 'Asbahnā wa asbahal-mulku lillāh',
      'translation': 'We have reached the morning and the dominion belongs to Allah.',
      'benefit': 'Said in the morning for protection and blessings.',
    },
    {
      'title': 'Evening Remembrance',
      'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      'transliteration': 'Amsaynā wa amsal-mulku lillāh',
      'translation': 'We have reached the evening and the dominion belongs to Allah.',
      'benefit': 'Said in the evening for protection and blessings.',
    },
    {
      'title': 'Before Sleep',
      'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      'transliteration': 'Bismika Allāhumma amūtu wa ahyā',
      'translation': 'In Your name, O Allah, I die and I live.',
      'benefit': 'The Prophet ﷺ would say this before sleeping.',
    },
    {
      'title': 'Upon Waking',
      'arabic': 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      'transliteration': 'Alhamdu lillāhil-ladhī ahyānā ba\'da mā amātanā wa ilayhin-nushūr',
      'translation': 'Praise be to Allah who gave us life after death and to Him is the resurrection.',
      'benefit': 'Said immediately upon waking up.',
    },
    {
      'title': 'Entering the Masjid',
      'arabic': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      'transliteration': 'Allāhumma-ftah lī abwāba rahmatik',
      'translation': 'O Allah, open for me the doors of Your mercy.',
      'benefit': 'Said when entering the mosque.',
    },
    {
      'title': 'Leaving the Masjid',
      'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      'transliteration': 'Allāhumma innī as\'aluka min fadlik',
      'translation': 'O Allah, I ask You from Your bounty.',
      'benefit': 'Said when leaving the mosque.',
    },
    {
      'title': 'Before Eating',
      'arabic': 'بِسْمِ اللَّهِ',
      'transliteration': 'Bismillāh',
      'translation': 'In the name of Allah.',
      'benefit': 'Said before starting to eat.',
    },
    {
      'title': 'After Eating',
      'arabic': 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ',
      'transliteration': 'Alhamdu lillāhil-ladhī at\'amanī hādhā wa razaqanīh',
      'translation': 'Praise be to Allah who fed me this and provided it for me.',
      'benefit': 'Said after finishing a meal.',
    },
    {
      'title': 'For Forgiveness',
      'arabic': 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
      'transliteration': 'Astaghfirullāhal-\'Adhīm alladhī lā ilāha illā Huwal-Hayyul-Qayyūmu wa atūbu ilayh',
      'translation': 'I seek forgiveness from Allah the Magnificent, there is no god but He, the Living, the Sustainer, and I repent to Him.',
      'benefit': 'The master of seeking forgiveness.',
    },
    {
      'title': 'For Guidance',
      'arabic': 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
      'transliteration': 'Allāhumma-hdinī wa saddidnī',
      'translation': 'O Allah, guide me and keep me on the right path.',
      'benefit': 'A comprehensive dua for guidance.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Duaa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.nights_stay, size: 40, color: Colors.white),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Supplications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Essential duas for daily life',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Duaas List
          ..._duaas.map((duaa) => _DuaaCard(
                title: duaa['title']!,
                arabic: duaa['arabic']!,
                transliteration: duaa['transliteration']!,
                translation: duaa['translation']!,
                benefit: duaa['benefit']!,
              )),
        ],
      ),
    );
  }
}

class _DuaaCard extends StatelessWidget {
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String benefit;

  const _DuaaCard({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.benefit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bookmark, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                arabic,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Arial',
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              transliteration,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              translation,
              style: const TextStyle(height: 1.4),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                benefit,
                style: TextStyle(fontSize: 12, color: Colors.amber[900]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
