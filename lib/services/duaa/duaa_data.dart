import '../../models/duaa.dart';

class DuaaData {
  static const List<Duaa> allDuaas = [
    // Morning & Evening
    Duaa(
      id: 1,
      title: 'Morning Remembrance',
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      transliteration: 'Asbahnā wa asbahal-mulku lillāh',
      translation: 'We have reached the morning and the dominion belongs to Allah.',
      source: 'Said in the morning for protection and blessings.',
      category: DuaaCategory.morningEvening,
    ),
    Duaa(
      id: 2,
      title: 'Evening Remembrance',
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      transliteration: 'Amsaynā wa amsal-mulku lillāh',
      translation: 'We have reached the evening and the dominion belongs to Allah.',
      source: 'Said in the evening for protection and blessings.',
      category: DuaaCategory.morningEvening,
    ),

    // Sleep
    Duaa(
      id: 3,
      title: 'Before Sleep',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allāhumma amūtu wa ahyā',
      translation: 'In Your name, O Allah, I die and I live.',
      source: 'The Prophet ﷺ would say this before sleeping. (Bukhari)',
      category: DuaaCategory.sleep,
    ),
    Duaa(
      id: 4,
      title: 'Upon Waking',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      transliteration: "Alhamdu lillāhil-ladhī ahyānā ba'da mā amātanā wa ilayhin-nushūr",
      translation: 'Praise be to Allah who gave us life after death and to Him is the resurrection.',
      source: 'Said immediately upon waking up. (Bukhari)',
      category: DuaaCategory.sleep,
    ),

    // Masjid
    Duaa(
      id: 5,
      title: 'Entering the Masjid',
      arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      transliteration: 'Allāhumma-ftah lī abwāba rahmatik',
      translation: 'O Allah, open for me the doors of Your mercy.',
      source: 'Said when entering the mosque. (Muslim)',
      category: DuaaCategory.masjid,
    ),
    Duaa(
      id: 6,
      title: 'Leaving the Masjid',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      transliteration: "Allāhumma innī as'aluka min fadlik",
      translation: 'O Allah, I ask You from Your bounty.',
      source: 'Said when leaving the mosque. (Muslim)',
      category: DuaaCategory.masjid,
    ),

    // Food
    Duaa(
      id: 7,
      title: 'Before Eating',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillāh',
      translation: 'In the name of Allah.',
      source: 'Said before starting to eat. (Bukhari & Muslim)',
      category: DuaaCategory.food,
    ),
    Duaa(
      id: 8,
      title: 'After Eating',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ',
      transliteration: 'Alhamdu lillāhil-ladhī at\'amanī hādhā wa razaqanīh',
      translation: 'Praise be to Allah who fed me this and provided it for me.',
      source: 'Said after finishing a meal. (Abu Dawud & Tirmidhi)',
      category: DuaaCategory.food,
    ),

    // Forgiveness & Guidance
    Duaa(
      id: 9,
      title: 'For Forgiveness',
      arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
      transliteration: "Astaghfirullāhal-'Adhīm alladhī lā ilāha illā Huwal-Hayyul-Qayyūmu wa atūbu ilayh",
      translation: 'I seek forgiveness from Allah the Magnificent, there is no god but He, the Living, the Sustainer, and I repent to Him.',
      source: 'The master of seeking forgiveness. (Abu Dawud & Tirmidhi)',
      category: DuaaCategory.forgivenessGuidance,
    ),
    Duaa(
      id: 10,
      title: 'For Guidance',
      arabic: 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
      transliteration: 'Allāhumma-hdinī wa saddidnī',
      translation: 'O Allah, guide me and keep me on the right path.',
      source: 'A comprehensive dua for guidance. (Muslim)',
      category: DuaaCategory.forgivenessGuidance,
    ),
  ];

  static List<Duaa> getByCategory(String category) {
    return allDuaas.where((d) => d.category == category).toList();
  }

  static Duaa? getById(int id) {
    try {
      return allDuaas.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  static Map<String, List<Duaa>> get groupedByCategory {
    final Map<String, List<Duaa>> grouped = {};
    for (final category in DuaaCategory.all) {
      final duaas = getByCategory(category);
      if (duaas.isNotEmpty) {
        grouped[category] = duaas;
      }
    }
    return grouped;
  }
}
