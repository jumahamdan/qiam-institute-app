import '../../models/duaa.dart';

class DuaaData {
  static const List<Duaa> allDuaas = [
    // Morning & Evening
    Duaa(
      id: 1,
      duaNumber: '1.1',
      title: 'Morning Remembrance',
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      transliteration: 'Asbahnā wa asbahal-mulku lillāh',
      translation: 'We have reached the morning and the dominion belongs to Allah.',
      source: 'Said in the morning for protection and blessings.',
      category: DuaaCategory.morningEvening,
      remarks: 'Recite this dua when you wake up in the morning. It acknowledges Allah\'s sovereignty over all creation and is a beautiful way to start your day.',
    ),
    Duaa(
      id: 2,
      duaNumber: '1.2',
      title: 'Evening Remembrance',
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      transliteration: 'Amsaynā wa amsal-mulku lillāh',
      translation: 'We have reached the evening and the dominion belongs to Allah.',
      source: 'Said in the evening for protection and blessings.',
      category: DuaaCategory.morningEvening,
      remarks: 'The evening counterpart to the morning remembrance. Recite this after Maghrib to acknowledge Allah\'s protection throughout the day.',
    ),

    // Sleep
    Duaa(
      id: 3,
      duaNumber: '2.1',
      title: 'Before Sleep',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allāhumma amūtu wa ahyā',
      translation: 'In Your name, O Allah, I die and I live.',
      source: 'The Prophet ﷺ would say this before sleeping. (Bukhari)',
      category: DuaaCategory.sleep,
      remarks: 'Sleep is described as a minor death, where the soul temporarily leaves the body. This dua acknowledges that our life and death are in Allah\'s hands.',
    ),
    Duaa(
      id: 4,
      duaNumber: '2.2',
      title: 'Upon Waking',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      transliteration: "Alhamdu lillāhil-ladhī ahyānā ba'da mā amātanā wa ilayhin-nushūr",
      translation: 'Praise be to Allah who gave us life after death and to Him is the resurrection.',
      source: 'Said immediately upon waking up. (Bukhari)',
      category: DuaaCategory.sleep,
      remarks: 'Upon waking, we thank Allah for returning our soul to us. This dua also reminds us of the Day of Resurrection when we will be raised from death.',
    ),

    // Masjid
    Duaa(
      id: 5,
      duaNumber: '3.1',
      title: 'Entering the Masjid',
      arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      transliteration: 'Allāhumma-ftah lī abwāba rahmatik',
      translation: 'O Allah, open for me the doors of Your mercy.',
      source: 'Said when entering the mosque. (Muslim)',
      category: DuaaCategory.masjid,
      remarks: 'Enter with your right foot first. The masjid is the house of Allah where we seek His mercy and blessings.',
    ),
    Duaa(
      id: 6,
      duaNumber: '3.2',
      title: 'Leaving the Masjid',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      transliteration: "Allāhumma innī as'aluka min fadlik",
      translation: 'O Allah, I ask You from Your bounty.',
      source: 'Said when leaving the mosque. (Muslim)',
      category: DuaaCategory.masjid,
      remarks: 'Exit with your left foot first. As we leave the masjid to return to worldly affairs, we ask Allah for His bounty in all our endeavors.',
    ),

    // Food
    Duaa(
      id: 7,
      duaNumber: '4.1',
      title: 'Before Eating',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillāh',
      translation: 'In the name of Allah.',
      source: 'Said before starting to eat. (Bukhari & Muslim)',
      category: DuaaCategory.food,
      remarks: 'If you forget to say it at the beginning, say: "Bismillāhi awwalahu wa ākhirahu" (In the name of Allah at its beginning and end).',
    ),
    Duaa(
      id: 8,
      duaNumber: '4.2',
      title: 'After Eating',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ',
      transliteration: 'Alhamdu lillāhil-ladhī at\'amanī hādhā wa razaqanīh',
      translation: 'Praise be to Allah who fed me this and provided it for me.',
      source: 'Said after finishing a meal. (Abu Dawud & Tirmidhi)',
      category: DuaaCategory.food,
      remarks: 'Express gratitude for the food Allah has provided. This dua acknowledges that all provision comes from Allah alone.',
    ),

    // Forgiveness & Guidance
    Duaa(
      id: 9,
      duaNumber: '5.1',
      title: 'For Forgiveness (Sayyid al-Istighfar)',
      arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
      transliteration: "Astaghfirullāhal-'Adhīm alladhī lā ilāha illā Huwal-Hayyul-Qayyūmu wa atūbu ilayh",
      translation: 'I seek forgiveness from Allah the Magnificent, there is no god but He, the Living, the Sustainer, and I repent to Him.',
      source: 'The master of seeking forgiveness. (Abu Dawud & Tirmidhi)',
      category: DuaaCategory.forgivenessGuidance,
      remarks: 'This is known as "Sayyid al-Istighfar" - the master of seeking forgiveness. The Prophet ﷺ said whoever says it during the day with conviction and dies that day will enter Paradise.',
    ),
    Duaa(
      id: 10,
      duaNumber: '5.2',
      title: 'For Guidance',
      arabic: 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
      transliteration: 'Allāhumma-hdinī wa saddidnī',
      translation: 'O Allah, guide me and keep me on the right path.',
      source: 'A comprehensive dua for guidance. (Muslim)',
      category: DuaaCategory.forgivenessGuidance,
      remarks: 'A short but powerful dua asking for both guidance to the truth and steadfastness upon it. "Saddidnī" means to make straight, like an arrow hitting its target.',
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
