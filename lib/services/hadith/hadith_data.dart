import '../../models/hadith.dart';

/// Static hadith data containing curated authentic hadith
/// Includes: Complete 40 Nawawi + Selected Bukhari + Selected Muslim
class HadithData {
  // Common narrator names to avoid duplication
  static const String _abuHurairah = 'Abu Hurairah (RA)';
  static const String _abdullahIbnUmar = 'Abdullah ibn Umar (RA)';
  static const String _abdullahIbnAbbas = 'Abdullah ibn Abbas (RA)';
  static const String _anasIbnMalik = 'Anas ibn Malik (RA)';

  static const List<Hadith> allHadiths = [
    // ══════════════════════════════════════════════════════════════════════
    // 40 NAWAWI COLLECTION - Foundational Hadith
    // ══════════════════════════════════════════════════════════════════════

    Hadith(
      id: 1,
      hadithNumber: '1',
      narrator: 'Umar ibn Al-Khattab (RA)',
      arabic:
          'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إلَى اللَّهِ وَرَسُولِهِ فَهِجْرَتُهُ إلَى اللَّهِ وَرَسُولِهِ، وَمَنْ كَانَتْ هِجْرَتُهُ لِدُنْيَا يُصِيبُهَا أَوْ امْرَأَةٍ يَنْكِحُهَا فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ',
      transliteration:
          'Innamal-a\'malu bin-niyyat, wa innama likulli imri\'in ma nawa...',
      translation:
          'Actions are judged by intentions, and every person will get what they intended. So whoever emigrated for Allah and His Messenger, his emigration was for Allah and His Messenger. And whoever emigrated for worldly gain or to marry a woman, his emigration was for what he emigrated for.',
      source: 'Sahih Al-Bukhari 1, Sahih Muslim 1907',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.intentions,
      remarks:
          'This is the first hadith in An-Nawawi\'s collection and is considered one of the most important hadith in Islam. It establishes that the validity and reward of any action depends on the intention behind it.',
    ),

    Hadith(
      id: 2,
      hadithNumber: '2',
      narrator: 'Umar ibn Al-Khattab (RA)',
      arabic:
          'بَيْنَمَا نَحْنُ جُلُوسٌ عِنْدَ رَسُولِ اللَّهِ صلى الله عليه وسلم ذَاتَ يَوْمٍ، إذْ طَلَعَ عَلَيْنَا رَجُلٌ شَدِيدُ بَيَاضِ الثِّيَابِ، شَدِيدُ سَوَادِ الشَّعْرِ...',
      transliteration:
          'Baynama nahnu julusun \'inda Rasulillahi sallallahu alayhi wasallam...',
      translation:
          'One day while we were sitting with the Messenger of Allah, there appeared before us a man whose clothes were exceedingly white and whose hair was exceedingly black... He said: "O Muhammad, tell me about Islam." The Messenger of Allah said: "Islam is to testify that there is no god but Allah and Muhammad is the Messenger of Allah, to establish prayer, to pay zakat, to fast in Ramadan, and to make pilgrimage to the House if you are able."',
      source: 'Sahih Muslim 8',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'Known as the Hadith of Jibril. It defines Islam, Iman (faith), and Ihsan (excellence in worship), and mentions the signs of the Hour.',
    ),

    Hadith(
      id: 3,
      hadithNumber: '3',
      narrator: _abdullahIbnUmar,
      arabic:
          'بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ: شَهَادَةِ أَنْ لَا إلَهَ إلَّا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَإِقَامِ الصَّلَاةِ، وَإِيتَاءِ الزَّكَاةِ، وَحَجِّ الْبَيْتِ، وَصَوْمِ رَمَضَانَ',
      transliteration:
          'Buniya al-Islamu \'ala khams: shahadati an la ilaha illallah wa anna Muhammadan Rasulullah...',
      translation:
          'Islam is built upon five pillars: testifying that there is no god but Allah and that Muhammad is the Messenger of Allah, establishing prayer, paying zakat, making pilgrimage to the House, and fasting in Ramadan.',
      source: 'Sahih Al-Bukhari 8, Sahih Muslim 16',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.pillars,
      remarks: 'This hadith outlines the five pillars of Islam.',
    ),

    Hadith(
      id: 4,
      hadithNumber: '4',
      narrator: 'Abdullah ibn Mas\'ud (RA)',
      arabic:
          'إنَّ أَحَدَكُمْ يُجْمَعُ خَلْقُهُ فِي بَطْنِ أُمِّهِ أَرْبَعِينَ يَوْمًا نُطْفَةً، ثُمَّ يَكُونُ عَلَقَةً مِثْلَ ذَلِكَ، ثُمَّ يَكُونُ مُضْغَةً مِثْلَ ذَلِكَ، ثُمَّ يُرْسَلُ إلَيْهِ الْمَلَكُ فَيَنْفُخُ فِيهِ الرُّوحَ...',
      transliteration:
          'Inna ahadakum yujma\'u khalquhu fi batni ummihi arba\'ina yawman nutfatan...',
      translation:
          'Verily the creation of each one of you is brought together in his mother\'s womb for forty days as a drop, then he becomes a clot for a similar period, then a morsel for a similar period, then an angel is sent to him who breathes the spirit into him...',
      source: 'Sahih Al-Bukhari 3208, Sahih Muslim 2643',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This hadith describes human creation in the womb and the writing of destiny.',
    ),

    Hadith(
      id: 5,
      hadithNumber: '5',
      narrator: 'Aisha (RA)',
      arabic:
          'مَنْ أَحْدَثَ فِي أَمْرِنَا هَذَا مَا لَيْسَ مِنْهُ فَهُوَ رَدٌّ',
      transliteration:
          'Man ahdatha fi amrina hadha ma laysa minhu fahuwa radd',
      translation:
          'Whoever introduces something into this matter of ours that is not from it, it will be rejected.',
      source: 'Sahih Al-Bukhari 2697, Sahih Muslim 1718',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This hadith establishes the principle of rejecting innovations (bid\'ah) in religious matters.',
    ),

    Hadith(
      id: 6,
      hadithNumber: '6',
      narrator: 'Nu\'man ibn Bashir (RA)',
      arabic:
          'إنَّ الْحَلَالَ بَيِّنٌ، وَإِنَّ الْحَرَامَ بَيِّنٌ، وَبَيْنَهُمَا أُمُورٌ مُشْتَبِهَاتٌ لَا يَعْلَمُهُنَّ كَثِيرٌ مِنْ النَّاسِ، فَمَنْ اتَّقَى الشُّبُهَاتِ فَقْدِ اسْتَبْرَأَ لِدِينِهِ وَعِرْضِهِ...',
      transliteration:
          'Innal-halala bayyinun, wa innal-harama bayyinun, wa baynahuma umurun mushtabihat...',
      translation:
          'That which is lawful is clear and that which is unlawful is clear, and between them are doubtful matters which many people do not know. So whoever avoids doubtful matters clears himself in regard to his religion and his honor...',
      source: 'Sahih Al-Bukhari 52, Sahih Muslim 1599',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.halal,
      remarks:
          'This hadith teaches Muslims to avoid doubtful matters to protect their faith.',
    ),

    Hadith(
      id: 7,
      hadithNumber: '7',
      narrator: 'Tamim Ad-Dari (RA)',
      arabic: 'الدِّينُ النَّصِيحَةُ',
      transliteration: 'Ad-dinu an-nasihah',
      translation: 'The religion is sincerity (and sincere advice).',
      source: 'Sahih Muslim 55',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'When asked "To whom?", the Prophet said: "To Allah, His Book, His Messenger, the leaders of the Muslims, and their common people."',
    ),

    Hadith(
      id: 8,
      hadithNumber: '8',
      narrator: _abdullahIbnUmar,
      arabic:
          'أُمِرْت أَنْ أُقَاتِلَ النَّاسَ حَتَّى يَشْهَدُوا أَنْ لَا إلَهَ إلَّا اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ، وَيُقِيمُوا الصَّلَاةَ، وَيُؤْتُوا الزَّكَاةَ...',
      transliteration:
          'Umirtu an uqatilan-nasa hatta yash-hadu an la ilaha illallah...',
      translation:
          'I have been ordered to fight the people until they testify that there is no god but Allah and that Muhammad is the Messenger of Allah, and establish prayer, and pay zakat...',
      source: 'Sahih Al-Bukhari 25, Sahih Muslim 22',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This hadith establishes the sanctity of life and property for those who embrace Islam.',
    ),

    Hadith(
      id: 9,
      hadithNumber: '9',
      narrator: _abuHurairah,
      arabic:
          'مَا نَهَيْتُكُمْ عَنْهُ فَاجْتَنِبُوهُ، وَمَا أَمَرْتُكُمْ بِهِ فَأْتُوا مِنْهُ مَا اسْتَطَعْتُمْ، فَإِنَّمَا أَهْلَكَ الَّذِينَ مِنْ قَبْلِكُمْ كَثْرَةُ مَسَائِلِهِمْ وَاخْتِلَافُهُمْ عَلَى أَنْبِيَائِهِمْ',
      transliteration:
          'Ma nahaytukum anhu fajtanibuhu, wa ma amartukum bihi fa\'tu minhu mastata\'tum...',
      translation:
          'What I have forbidden you, avoid. What I have commanded you, do as much of it as you can. For verily, what destroyed those before you was their excessive questioning and their disagreeing with their Prophets.',
      source: 'Sahih Al-Bukhari 7288, Sahih Muslim 1337',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This hadith teaches obedience to the Prophet and warns against excessive questioning.',
    ),

    Hadith(
      id: 10,
      hadithNumber: '10',
      narrator: _abuHurairah,
      arabic:
          'إنَّ اللَّهَ طَيِّبٌ لَا يَقْبَلُ إلَّا طَيِّبًا، وَإِنَّ اللَّهَ أَمَرَ الْمُؤْمِنِينَ بِمَا أَمَرَ بِهِ الْمُرْسَلِينَ',
      transliteration:
          'Innallaha tayyibun la yaqbalu illa tayyiban, wa innallaha amaral-mu\'minina bima amara bihil-mursalin',
      translation:
          'Allah is Pure and accepts only that which is pure. And verily Allah has commanded the believers with what He commanded the Messengers.',
      source: 'Sahih Muslim 1015',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.halal,
      remarks:
          'This hadith emphasizes the importance of earning and consuming only what is halal.',
    ),

    Hadith(
      id: 11,
      hadithNumber: '11',
      narrator: 'Al-Hasan ibn Ali (RA)',
      arabic:
          'دَعْ مَا يَرِيبُك إلَى مَا لَا يَرِيبُك',
      transliteration: 'Da\' ma yuribuka ila ma la yuribuk',
      translation:
          'Leave that which makes you doubt for that which does not make you doubt.',
      source: 'Sunan At-Tirmidhi 2518, Sunan An-Nasa\'i 5711',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.halal,
      remarks:
          'This hadith teaches caution and avoiding doubtful matters.',
    ),

    Hadith(
      id: 12,
      hadithNumber: '12',
      narrator: _abuHurairah,
      arabic:
          'مِنْ حُسْنِ إسْلَامِ الْمَرْءِ تَرْكُهُ مَا لَا يَعْنِيهِ',
      transliteration: 'Min husni islami al-mar\'i tarkuhu ma la ya\'nih',
      translation:
          'Part of the perfection of one\'s Islam is leaving that which does not concern him.',
      source: 'Sunan At-Tirmidhi 2317',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.character,
      remarks:
          'This hadith emphasizes focusing on what benefits and avoiding interference in others\' affairs.',
    ),

    Hadith(
      id: 13,
      hadithNumber: '13',
      narrator: _anasIbnMalik,
      arabic:
          'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
      transliteration:
          'La yu\'minu ahadukum hatta yuhibba li-akhihi ma yuhibbu linafsihi',
      translation:
          'None of you truly believes until he loves for his brother what he loves for himself.',
      source: 'Sahih Al-Bukhari 13, Sahih Muslim 45',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.brotherhood,
      remarks:
          'This hadith establishes the foundation of Islamic brotherhood and social ethics.',
    ),

    Hadith(
      id: 14,
      hadithNumber: '14',
      narrator: 'Abdullah ibn Mas\'ud (RA)',
      arabic:
          'لَا يَحِلُّ دَمُ امْرِئٍ مُسْلِمٍ إلَّا بِإِحْدَى ثَلَاثٍ: الثَّيِّبُ الزَّانِي، وَالنَّفْسُ بِالنَّفْسِ، وَالتَّارِكُ لِدِينِهِ الْمُفَارِقُ لِلْجَمَاعَةِ',
      transliteration:
          'La yahillu damu imri\'in muslimin illa bi-ihda thalath...',
      translation:
          'It is not permissible to spill the blood of a Muslim except in three cases: the married person who commits adultery, a life for a life, and the one who forsakes his religion and separates from the community.',
      source: 'Sahih Al-Bukhari 6878, Sahih Muslim 1676',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.halal,
      remarks: 'This hadith establishes the sanctity of Muslim blood.',
    ),

    Hadith(
      id: 15,
      hadithNumber: '15',
      narrator: _abuHurairah,
      arabic:
          'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيُكْرِمْ جَارَهُ، وَمَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيُكْرِمْ ضَيْفَهُ',
      transliteration:
          'Man kana yu\'minu billahi wal-yawmil-akhiri falyaqul khayran aw liyasmut...',
      translation:
          'Whoever believes in Allah and the Last Day, let him speak good or remain silent. Whoever believes in Allah and the Last Day, let him honor his neighbor. Whoever believes in Allah and the Last Day, let him honor his guest.',
      source: 'Sahih Al-Bukhari 6018, Sahih Muslim 47',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.manners,
      remarks:
          'This hadith links faith to good speech, neighborly conduct, and hospitality.',
    ),

    Hadith(
      id: 16,
      hadithNumber: '16',
      narrator: _abuHurairah,
      arabic:
          'لَا تَغْضَبْ',
      transliteration: 'La taghdab',
      translation: 'Do not become angry.',
      source: 'Sahih Al-Bukhari 6116',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.character,
      remarks:
          'A man asked the Prophet for advice, and he repeated this several times: "Do not become angry."',
    ),

    Hadith(
      id: 17,
      hadithNumber: '17',
      narrator: 'Shaddad ibn Aws (RA)',
      arabic:
          'إنَّ اللَّهَ كَتَبَ الْإِحْسَانَ عَلَى كُلِّ شَيْءٍ، فَإِذَا قَتَلْتُمْ فَأَحْسِنُوا الْقِتْلَةَ، وَإِذَا ذَبَحْتُمْ فَأَحْسِنُوا الذِّبْحَةَ، وَلْيُحِدَّ أَحَدُكُمْ شَفْرَتَهُ، وَلْيُرِحْ ذَبِيحَتَهُ',
      transliteration:
          'Innallaha kataba al-ihsana \'ala kulli shay\'...',
      translation:
          'Verily Allah has prescribed excellence in all things. So if you kill, kill well; and if you slaughter, slaughter well. Let each one of you sharpen his blade and let him spare suffering to the animal he slaughters.',
      source: 'Sahih Muslim 1955',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.character,
      remarks:
          'This hadith establishes the principle of ihsan (excellence) in all actions.',
    ),

    Hadith(
      id: 18,
      hadithNumber: '18',
      narrator: 'Abu Dharr and Mu\'adh ibn Jabal (RA)',
      arabic:
          'اتَّقِ اللَّهَ حَيْثُمَا كُنْت، وَأَتْبِعْ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا، وَخَالِقْ النَّاسَ بِخُلُقٍ حَسَنٍ',
      transliteration:
          'Ittaqillaha haythuma kunt, wa atbi\' as-sayyi\'ata al-hasanata tamhuha, wa khaliqin-nasa bi-khuluqin hasan',
      translation:
          'Fear Allah wherever you are, follow up a bad deed with a good deed and it will erase it, and behave with people with good character.',
      source: 'Sunan At-Tirmidhi 1987',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.character,
      remarks:
          'This hadith combines taqwa (God-consciousness), repentance, and good character.',
    ),

    Hadith(
      id: 19,
      hadithNumber: '19',
      narrator: _abdullahIbnAbbas,
      arabic:
          'يَا غُلَامُ، إنِّي أُعَلِّمُك كَلِمَاتٍ: احْفَظْ اللَّهَ يَحْفَظْك، احْفَظْ اللَّهَ تَجِدْهُ تُجَاهَك، إذَا سَأَلْت فَاسْأَلْ اللَّهَ، وَإِذَا اسْتَعَنْت فَاسْتَعِنْ بِاللَّهِ...',
      transliteration:
          'Ya ghulam, inni u\'allimuka kalimat: Ihfadhillaha yahfadhk, ihfadhillaha tajidhu tujahak...',
      translation:
          'O young man, I shall teach you some words: Be mindful of Allah and Allah will protect you. Be mindful of Allah and you will find Him before you. When you ask, ask Allah. When you seek help, seek help from Allah...',
      source: 'Sunan At-Tirmidhi 2516',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This hadith teaches reliance upon Allah and contains profound guidance for youth.',
    ),

    Hadith(
      id: 20,
      hadithNumber: '20',
      narrator: 'Abu Mas\'ud Uqbah ibn Amr (RA)',
      arabic:
          'إنَّ مِمَّا أَدْرَكَ النَّاسُ مِنْ كَلَامِ النُّبُوَّةِ الْأُولَى: إذَا لَمْ تَسْتَحِ فَاصْنَعْ مَا شِئْت',
      transliteration:
          'Inna mimma adrakannas min kalamim-nubuwwatil-ula: idha lam tastahi fasna\' ma shi\'t',
      translation:
          'From the sayings of the earlier prophets which people have received is: If you feel no shame, then do as you wish.',
      source: 'Sahih Al-Bukhari 3483',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.character,
      remarks:
          'This hadith emphasizes the importance of haya (modesty/shame) in guiding behavior.',
    ),

    Hadith(
      id: 21,
      hadithNumber: '21',
      narrator: 'Abu Amr Sufyan ibn Abdullah (RA)',
      arabic:
          'قُلْ آمَنْت بِاللَّهِ ثُمَّ اسْتَقِمْ',
      transliteration: 'Qul amantu billahi thumma istaqim',
      translation: 'Say: "I believe in Allah," and then be steadfast.',
      source: 'Sahih Muslim 38',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'When asked for comprehensive advice, the Prophet gave this concise guidance.',
    ),

    Hadith(
      id: 22,
      hadithNumber: '22',
      narrator: 'Abu Abdullah Jabir ibn Abdullah (RA)',
      arabic:
          'أَرَأَيْت إذَا صَلَّيْت الْمَكْتُوبَاتِ، وَصُمْت رَمَضَانَ، وَأَحْلَلْت الْحَلَالَ، وَحَرَّمْت الْحَرَامَ، وَلَمْ أَزِدْ عَلَى ذَلِكَ شَيْئًا، أَأَدْخُلُ الْجَنَّةَ؟ قَالَ: نَعَمْ',
      transliteration:
          'Ara\'ayta idha sallaytu al-maktubat, wa sumtu Ramadan, wa ahlaltu al-halal, wa harramtu al-haram...',
      translation:
          'Tell me, if I pray the obligatory prayers, fast Ramadan, treat as lawful what is lawful and treat as forbidden what is forbidden, and do not add anything to that, will I enter Paradise? He said: Yes.',
      source: 'Sahih Muslim 15',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.pillars,
      remarks:
          'This hadith shows that fulfilling the basic obligations is sufficient for Paradise.',
    ),

    Hadith(
      id: 23,
      hadithNumber: '23',
      narrator: 'Abu Malik Al-Harith ibn Asim Al-Ash\'ari (RA)',
      arabic:
          'الطُّهُورُ شَطْرُ الْإِيمَانِ، وَالْحَمْدُ لِلَّهِ تَمْلَأُ الْمِيزَانَ، وَسُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ تَمْلَآنِ - أَوْ تَمْلَأُ - مَا بَيْنَ السَّمَاءِ وَالْأَرْضِ...',
      transliteration:
          'At-tuhuru shatrul-iman, wal-hamdu lillahi tamla\'ul-mizan...',
      translation:
          'Purification is half of faith. "Al-hamdu lillah" fills the scale. "SubhanAllah wal-hamdu lillah" fills what is between the heavens and earth. Prayer is light. Charity is proof. Patience is illumination. The Quran is evidence for or against you.',
      source: 'Sahih Muslim 223',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This hadith highlights the virtues of various acts of worship.',
    ),

    Hadith(
      id: 24,
      hadithNumber: '24',
      narrator: 'Abu Dharr Al-Ghifari (RA)',
      arabic:
          'يَا عِبَادِي، إنِّي حَرَّمْت الظُّلْمَ عَلَى نَفْسِي وَجَعَلْتُهُ بَيْنَكُمْ مُحَرَّمًا فَلَا تَظَالَمُوا...',
      transliteration:
          'Ya \'ibadi, inni harramtu adh-dhulma \'ala nafsi wa ja\'altuhu baynakum muharraman fala tadhalamu...',
      translation:
          'O My servants, I have forbidden oppression for Myself and have made it forbidden amongst you, so do not oppress one another. O My servants, all of you are astray except for those I have guided, so seek guidance from Me and I shall guide you...',
      source: 'Sahih Muslim 2577',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This is known as Hadith Qudsi, where Allah speaks through the Prophet. It is one of the most comprehensive hadith.',
    ),

    Hadith(
      id: 25,
      hadithNumber: '25',
      narrator: 'Abu Dharr (RA)',
      arabic:
          'يُصْبِحُ عَلَى كُلِّ سُلَامَى مِنْ أَحَدِكُمْ صَدَقَةٌ، فَكُلُّ تَسْبِيحَةٍ صَدَقَةٌ، وَكُلُّ تَحْمِيدَةٍ صَدَقَةٌ، وَكُلُّ تَهْلِيلَةٍ صَدَقَةٌ، وَكُلُّ تَكْبِيرَةٍ صَدَقَةٌ، وَأَمْرٌ بِالْمَعْرُوفِ صَدَقَةٌ، وَنَهْيٌ عَنْ الْمُنْكَرِ صَدَقَةٌ...',
      transliteration:
          'Yusbihu \'ala kulli sulama min ahadikum sadaqah...',
      translation:
          'Every joint of a person must perform charity every day the sun rises. Judging justly between two people is charity. Helping a man with his mount is charity. A good word is charity. Every step taken to prayer is charity. Removing harm from the road is charity.',
      source: 'Sahih Al-Bukhari 2989, Sahih Muslim 1009',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.charity,
      remarks:
          'This hadith shows that many everyday actions can be considered charity.',
    ),

    Hadith(
      id: 26,
      hadithNumber: '26',
      narrator: _abuHurairah,
      arabic:
          'كُلُّ سُلَامَى مِنْ النَّاسِ عَلَيْهِ صَدَقَةٌ، كُلَّ يَوْمٍ تَطْلُعُ فِيهِ الشَّمْسُ تَعْدِلُ بَيْنَ اثْنَيْنِ صَدَقَةٌ...',
      transliteration:
          'Kullu sulama minan-nasi \'alayhi sadaqah, kulla yawmin tatlu\'u fihish-shams...',
      translation:
          'Every joint of a person owes charity every day. Judging fairly between two people is charity. Helping a man onto his mount or lifting his luggage onto it is charity. A good word is charity. Every step taken towards prayer is charity. Removing harm from the road is charity.',
      source: 'Sahih Al-Bukhari 2989',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.charity,
      remarks:
          'Expansion on the concept that all good deeds are charity.',
    ),

    Hadith(
      id: 27,
      hadithNumber: '27',
      narrator: 'An-Nawwas ibn Sam\'an (RA)',
      arabic:
          'الْبِرُّ حُسْنُ الْخُلُقِ، وَالْإِثْمُ مَا حَاكَ فِي صَدْرِك، وَكَرِهْت أَنْ يَطَّلِعَ عَلَيْهِ النَّاسُ',
      transliteration:
          'Al-birru husnul-khuluq, wal-ithmu ma haka fi sadrik, wa karihta an yattali\'a \'alayhin-nas',
      translation:
          'Righteousness is good character, and sin is that which wavers in your heart and which you dislike for people to find out about.',
      source: 'Sahih Muslim 2553',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.character,
      remarks:
          'This hadith gives a simple definition of righteousness and sin.',
    ),

    Hadith(
      id: 28,
      hadithNumber: '28',
      narrator: 'Abu Najih Al-Irbad ibn Sariyah (RA)',
      arabic:
          'أُوصِيكُمْ بِتَقْوَى اللَّهِ، وَالسَّمْعِ وَالطَّاعَةِ وَإِنْ تَأَمَّرَ عَلَيْكُمْ عَبْدٌ، فَإِنَّهُ مَنْ يَعِشْ مِنْكُمْ فَسَيَرَى اخْتِلَافًا كَثِيرًا، فَعَلَيْكُمْ بِسُنَّتِي وَسُنَّةِ الْخُلَفَاءِ الرَّاشِدِينَ الْمَهْدِيِّينَ، عَضُّوا عَلَيْهَا بِالنَّوَاجِذِ...',
      transliteration:
          'Usikum bi-taqwallah, was-sam\'i wat-ta\'ah wa in ta\'ammara \'alaykum \'abd...',
      translation:
          'I advise you to have taqwa of Allah, and to listen and obey even if a slave is made your leader. Whoever among you lives will see great disagreement. So adhere to my Sunnah and the way of the rightly-guided caliphs. Bite onto it with your molars...',
      source: 'Sunan Abu Dawud 4607, Sunan At-Tirmidhi 2676',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This hadith was given as a farewell sermon and warns against innovation.',
    ),

    Hadith(
      id: 29,
      hadithNumber: '29',
      narrator: 'Mu\'adh ibn Jabal (RA)',
      arabic:
          'يَا رَسُولَ اللَّهِ، أَخْبِرْنِي بِعَمَلٍ يُدْخِلُنِي الْجَنَّةَ وَيُبَاعِدُنِي مِنْ النَّارِ؟ قَالَ: لَقَدْ سَأَلْت عَنْ عَظِيمٍ، وَإِنَّهُ لَيَسِيرٌ عَلَى مَنْ يَسَّرَهُ اللَّهُ عَلَيْهِ...',
      transliteration:
          'Ya Rasulallah, akhbirni bi-\'amalin yudkhiluniy al-jannah wa yuba\'iduni minan-nar...',
      translation:
          '"O Messenger of Allah, tell me of an action that will admit me to Paradise and keep me away from the Fire." He said: "You have asked about something great, yet it is easy for the one whom Allah makes it easy: Worship Allah without associating anything with Him, establish prayer, pay zakat, fast Ramadan, and make pilgrimage to the House..."',
      source: 'Sunan At-Tirmidhi 2616',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.pillars,
      remarks:
          'This hadith outlines the actions leading to Paradise.',
    ),

    Hadith(
      id: 30,
      hadithNumber: '30',
      narrator: 'Abu Tha\'labah Al-Khushani (RA)',
      arabic:
          'إنَّ اللَّهَ فَرَضَ فَرَائِضَ فَلَا تُضَيِّعُوهَا، وَحَدَّ حُدُودًا فَلَا تَعْتَدُوهَا، وَحَرَّمَ أَشْيَاءَ فَلَا تَنْتَهِكُوهَا، وَسَكَتَ عَنْ أَشْيَاءَ رَحْمَةً لَكُمْ غَيْرَ نِسْيَانٍ فَلَا تَبْحَثُوا عَنْهَا',
      transliteration:
          'Innallaha farada fara\'ida fala tudayyi\'uha, wa hadda hududan fala ta\'taduha...',
      translation:
          'Allah has prescribed certain obligations, so do not neglect them. He has set certain limits, so do not transgress them. He has forbidden certain things, so do not violate them. And He has remained silent about some things, out of mercy for you, not out of forgetfulness, so do not ask about them.',
      source: 'Sunan Ad-Daraqutni',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.halal,
      remarks:
          'This hadith teaches the comprehensive nature of Islamic law.',
    ),

    Hadith(
      id: 31,
      hadithNumber: '31',
      narrator: 'Sahl ibn Sa\'d As-Sa\'idi (RA)',
      arabic:
          'ازْهَدْ فِي الدُّنْيَا يُحِبَّك اللَّهُ، وَازْهَدْ فِيمَا عِنْدَ النَّاسِ يُحِبَّك النَّاسُ',
      transliteration:
          'Izhad fid-dunya yuhibbukallah, wazhad fima \'indan-nasi yuhibbukannas',
      translation:
          'Be detached from the world and Allah will love you. Be detached from what people have and people will love you.',
      source: 'Sunan Ibn Majah 4102',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.heart,
      remarks:
          'This hadith teaches the virtue of zuhd (asceticism/detachment).',
    ),

    Hadith(
      id: 32,
      hadithNumber: '32',
      narrator: 'Abu Sa\'id Al-Khudri (RA)',
      arabic:
          'لَا ضَرَرَ وَلَا ضِرَارَ',
      transliteration: 'La darara wa la dirar',
      translation: 'There should be no harm nor reciprocating harm.',
      source: 'Sunan Ibn Majah 2341',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.halal,
      remarks:
          'This is a fundamental principle in Islamic jurisprudence (fiqh).',
    ),

    Hadith(
      id: 33,
      hadithNumber: '33',
      narrator: _abdullahIbnAbbas,
      arabic:
          'لَوْ يُعْطَى النَّاسُ بِدَعْوَاهُمْ، لَادَّعَى رِجَالٌ أَمْوَالَ قَوْمٍ وَدِمَاءَهُمْ، لَكِنَّ الْبَيِّنَةَ عَلَى الْمُدَّعِي، وَالْيَمِينَ عَلَى مَنْ أَنْكَرَ',
      transliteration:
          'Law yu\'tan-nasu bi-da\'wahum, ladda\'a rijalun amwala qawmin wa dima\'ahum...',
      translation:
          'If people were given everything they claimed, men would claim the wealth and blood of others. But the burden of proof is on the claimant, and the oath is on the one who denies.',
      source: 'Sahih Al-Bukhari 4552, Sahih Muslim 1711',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.halal,
      remarks:
          'This hadith establishes principles of justice and burden of proof.',
    ),

    Hadith(
      id: 34,
      hadithNumber: '34',
      narrator: 'Abu Sa\'id Al-Khudri (RA)',
      arabic:
          'مَنْ رَأَى مِنْكُمْ مُنْكَرًا فَلْيُغَيِّرْهُ بِيَدِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِلِسَانِهِ، فَإِنْ لَمْ يَسْتَطِعْ فَبِقَلْبِهِ، وَذَلِكَ أَضْعَفُ الْإِيمَانِ',
      transliteration:
          'Man ra\'a minkum munkaran falyughayyirhu bi-yadihi, fa-in lam yastati\' fa-bi-lisanih, fa-in lam yastati\' fa-bi-qalbih, wa dhalika ad\'aful-iman',
      translation:
          'Whoever among you sees an evil, let him change it with his hand. If he cannot, then with his tongue. If he cannot, then with his heart, and that is the weakest of faith.',
      source: 'Sahih Muslim 49',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.character,
      remarks:
          'This hadith establishes the obligation of enjoining good and forbidding evil.',
    ),

    Hadith(
      id: 35,
      hadithNumber: '35',
      narrator: _abuHurairah,
      arabic:
          'لَا تَحَاسَدُوا، وَلَا تَنَاجَشُوا، وَلَا تَبَاغَضُوا، وَلَا تَدَابَرُوا، وَلَا يَبِعْ بَعْضُكُمْ عَلَى بَيْعِ بَعْضٍ، وَكُونُوا عِبَادَ اللَّهِ إخْوَانًا...',
      transliteration:
          'La tahasadu, wa la tanajashu, wa la tabaghadu, wa la tadabaru...',
      translation:
          'Do not envy one another, do not artificially inflate prices, do not hate one another, do not turn away from one another, and do not undercut one another in sales. Be, O servants of Allah, brothers. A Muslim is the brother of a Muslim. He does not wrong him, abandon him, or despise him...',
      source: 'Sahih Muslim 2564',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.brotherhood,
      remarks:
          'This hadith establishes the ethics of Muslim brotherhood.',
    ),

    Hadith(
      id: 36,
      hadithNumber: '36',
      narrator: _abuHurairah,
      arabic:
          'مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا نَفَّسَ اللَّهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ الْقِيَامَةِ...',
      transliteration:
          'Man naffasa \'an mu\'minin kurbatan min kurabi ad-dunya naffasallahu \'anhu kurbatan min kurabi yawmil-qiyamah...',
      translation:
          'Whoever relieves a believer of a hardship of this world, Allah will relieve him of a hardship of the Day of Resurrection. Whoever makes things easy for one in difficulty, Allah will make things easy for him in this world and the Hereafter...',
      source: 'Sahih Muslim 2699',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.brotherhood,
      remarks:
          'This hadith encourages helping others and seeking knowledge.',
    ),

    Hadith(
      id: 37,
      hadithNumber: '37',
      narrator: _abdullahIbnAbbas,
      arabic:
          'إنَّ اللَّهَ كَتَبَ الْحَسَنَاتِ وَالسَّيِّئَاتِ، ثُمَّ بَيَّنَ ذَلِكَ، فَمَنْ هَمَّ بِحَسَنَةٍ فَلَمْ يَعْمَلْهَا كَتَبَهَا اللَّهُ عِنْدَهُ حَسَنَةً كَامِلَةً...',
      transliteration:
          'Innallaha katabal-hasanati was-sayyi\'at, thumma bayyana dhalik...',
      translation:
          'Allah has recorded good deeds and bad deeds. Then He made it clear: Whoever intends a good deed but does not do it, Allah records it as a complete good deed. Whoever intends a good deed and does it, Allah records it as ten to seven hundred good deeds or more...',
      source: 'Sahih Al-Bukhari 6491, Sahih Muslim 131',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.intentions,
      remarks:
          'This hadith explains how deeds are recorded and the mercy of Allah.',
    ),

    Hadith(
      id: 38,
      hadithNumber: '38',
      narrator: _abuHurairah,
      arabic:
          'إنَّ اللَّهَ تَعَالَى قَالَ: مَنْ عَادَى لِي وَلِيًّا فَقَدْ آذَنْتُهُ بِالْحَرْبِ، وَمَا تَقَرَّبَ إلَيَّ عَبْدِي بِشَيْءٍ أَحَبَّ إلَيَّ مِمَّا افْتَرَضْتُ عَلَيْهِ...',
      transliteration:
          'Innallaha ta\'ala qal: man \'ada li waliyyan faqad adhantahu bil-harb...',
      translation:
          'Allah, the Exalted, said: "Whoever shows hostility to a friend of Mine, I have declared war on him. My servant does not draw near to Me with anything more beloved to Me than what I have made obligatory upon him. And My servant continues to draw near to Me with voluntary acts until I love him..."',
      source: 'Sahih Al-Bukhari 6502',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
      remarks:
          'This Hadith Qudsi explains how to attain Allah\'s love through worship.',
    ),

    Hadith(
      id: 39,
      hadithNumber: '39',
      narrator: _abdullahIbnAbbas,
      arabic:
          'إنَّ اللَّهَ تَجَاوَزَ لِي عَنْ أُمَّتِي الْخَطَأَ وَالنِّسْيَانَ وَمَا اُسْتُكْرِهُوا عَلَيْهِ',
      transliteration:
          'Innallaha tajawaza li \'an ummati al-khata\' wan-nisyan wa ma ustukrihu \'alayh',
      translation:
          'Allah has forgiven my ummah for mistakes, forgetfulness, and what they are forced to do.',
      source: 'Sunan Ibn Majah 2043',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.repentance,
      remarks:
          'This hadith shows Allah\'s mercy for unintentional sins.',
    ),

    Hadith(
      id: 40,
      hadithNumber: '40',
      narrator: _abdullahIbnUmar,
      arabic:
          'كُنْ فِي الدُّنْيَا كَأَنَّك غَرِيبٌ أَوْ عَابِرُ سَبِيلٍ',
      transliteration:
          'Kun fid-dunya ka-annaka gharibun aw \'abiru sabil',
      translation:
          'Be in this world as if you were a stranger or a traveler.',
      source: 'Sahih Al-Bukhari 6416',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.sahih,
      topic: HadithTopic.hereafter,
      remarks:
          'This hadith teaches detachment from worldly life and focus on the Hereafter.',
    ),

    Hadith(
      id: 41,
      hadithNumber: '41',
      narrator: 'Abu Muhammad Abdullah ibn Amr (RA)',
      arabic:
          'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يَكُونَ هَوَاهُ تَبَعًا لِمَا جِئْت بِهِ',
      transliteration:
          'La yu\'minu ahadukum hatta yakuna hawahu taba\'an lima ji\'tu bihi',
      translation:
          'None of you truly believes until his desires are in accordance with what I have brought.',
      source: 'Sharh As-Sunnah',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.faith,
      remarks:
          'This hadith establishes that true faith requires submission of desires to the Sunnah.',
    ),

    Hadith(
      id: 42,
      hadithNumber: '42',
      narrator: _anasIbnMalik,
      arabic:
          'يَا ابْنَ آدَمَ، إِنَّكَ مَا دَعَوْتَنِي وَرَجَوْتَنِي غَفَرْت لَك عَلَى مَا كَانَ مِنْك وَلَا أُبَالِي، يَا ابْنَ آدَمَ، لَوْ بَلَغَتْ ذُنُوبُك عَنَانَ السَّمَاءِ ثُمَّ اسْتَغْفَرْتَنِي غَفَرْت لَك...',
      transliteration:
          'Ya ibna Adam, innaka ma da\'awtani wa rajawtani ghafart laka \'ala ma kana minka wa la ubali...',
      translation:
          'O son of Adam, as long as you call upon Me and put your hope in Me, I will forgive you for what you have done and I will not mind. O son of Adam, if your sins were to reach the clouds of the sky and then you sought My forgiveness, I would forgive you...',
      source: 'Sunan At-Tirmidhi 3540',
      collection: HadithCollection.nawawi,
      grade: HadithGrade.hasan,
      topic: HadithTopic.repentance,
      remarks:
          'This Hadith Qudsi emphasizes Allah\'s immense mercy and forgiveness.',
    ),

    // ══════════════════════════════════════════════════════════════════════
    // SELECTED BUKHARI HADITH - Famous and Beneficial
    // ══════════════════════════════════════════════════════════════════════

    Hadith(
      id: 43,
      hadithNumber: '6018',
      narrator: _abuHurairah,
      arabic:
          'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلاَ يُؤْذِ جَارَهُ',
      transliteration:
          'Man kana yu\'minu billahi wal-yawmil-akhiri fala yu\'dhi jarahu',
      translation:
          'Whoever believes in Allah and the Last Day should not harm his neighbor.',
      source: 'Sahih Al-Bukhari 6018',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.manners,
    ),

    Hadith(
      id: 44,
      hadithNumber: '6116',
      narrator: _abuHurairah,
      arabic:
          'لَيْسَ الشَّدِيدُ بِالصُّرَعَةِ، إِنَّمَا الشَّدِيدُ الَّذِي يَمْلِكُ نَفْسَهُ عِنْدَ الْغَضَبِ',
      transliteration:
          'Laysa ash-shadidu bis-sur\'ah, innama ash-shadidu alladhi yamliku nafsahu \'indal-ghadab',
      translation:
          'The strong person is not the one who wrestles, but the strong person is the one who controls himself when he is angry.',
      source: 'Sahih Al-Bukhari 6114',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.character,
    ),

    Hadith(
      id: 45,
      hadithNumber: '6094',
      narrator: _abuHurairah,
      arabic:
          'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ',
      transliteration: 'Tabassumuka fi wajhi akhika laka sadaqah',
      translation: 'Your smile to your brother is charity.',
      source: 'Sunan At-Tirmidhi 1956',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.charity,
    ),

    Hadith(
      id: 46,
      hadithNumber: '5063',
      narrator: _anasIbnMalik,
      arabic:
          'حُبِّبَ إِلَيَّ مِنَ الدُّنْيَا النِّسَاءُ وَالطِّيبُ، وَجُعِلَتْ قُرَّةُ عَيْنِي فِي الصَّلاَةِ',
      transliteration:
          'Hubbiba ilayya minad-dunya an-nisa\' wat-tib, wa ju\'ilat qurratu \'ayni fis-salah',
      translation:
          'Made beloved to me from this world are women and perfume, and the coolness of my eyes has been made in prayer.',
      source: 'Sunan An-Nasa\'i 3939',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.prayer,
    ),

    Hadith(
      id: 47,
      hadithNumber: '6137',
      narrator: 'Aisha (RA)',
      arabic:
          'إِنَّ اللَّهَ رَفِيقٌ يُحِبُّ الرِّفْقَ فِي الأَمْرِ كُلِّهِ',
      transliteration:
          'Innallaha rafiqun yuhibbur-rifqa fil-amri kullihi',
      translation:
          'Indeed Allah is Kind and loves kindness in all matters.',
      source: 'Sahih Al-Bukhari 6927',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.character,
    ),

    Hadith(
      id: 48,
      hadithNumber: '2442',
      narrator: _abdullahIbnUmar,
      arabic:
          'الْمُسْلِمُ أَخُو الْمُسْلِمِ، لاَ يَظْلِمُهُ وَلاَ يُسْلِمُهُ',
      transliteration:
          'Al-Muslimu akhul-Muslim, la yadhlimuhu wa la yuslimuhu',
      translation:
          'A Muslim is a brother of another Muslim. He should not wrong him nor abandon him.',
      source: 'Sahih Al-Bukhari 2442',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.brotherhood,
    ),

    Hadith(
      id: 49,
      hadithNumber: '481',
      narrator: _abuHurairah,
      arabic:
          'صَلاَةُ الرَّجُلِ فِي جَمَاعَةٍ تَزِيدُ عَلَى صَلاَتِهِ فِي بَيْتِهِ وَصَلاَتِهِ فِي سُوقِهِ بِضْعًا وَعِشْرِينَ دَرَجَةً',
      transliteration:
          'Salatur-rajuli fi jama\'atin tazidu \'ala salatihi fi baytihi wa salatihi fi suqihi bid\'an wa \'ishrina darajah',
      translation:
          'The prayer of a man in congregation is twenty-five degrees more excellent than his prayer in his house or his shop.',
      source: 'Sahih Al-Bukhari 647',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.prayer,
    ),

    Hadith(
      id: 50,
      hadithNumber: '5997',
      narrator: _abuHurairah,
      arabic:
          'مَنْ لاَ يَشْكُرُ النَّاسَ لاَ يَشْكُرُ اللَّهَ',
      transliteration: 'Man la yashkurun-nasa la yashkurullah',
      translation:
          'He who does not thank people does not thank Allah.',
      source: 'Sunan At-Tirmidhi 1954',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.manners,
    ),

    Hadith(
      id: 51,
      hadithNumber: '52',
      narrator: 'An-Nu\'man ibn Bashir (RA)',
      arabic:
          'مَثَلُ الْمُؤْمِنِينَ فِي تَوَادِّهِمْ وَتَرَاحُمِهِمْ وَتَعَاطُفِهِمْ مَثَلُ الْجَسَدِ، إِذَا اشْتَكَى مِنْهُ عُضْوٌ تَدَاعَى لَهُ سَائِرُ الْجَسَدِ بِالسَّهَرِ وَالْحُمَّى',
      transliteration:
          'Mathalul-mu\'minina fi tawaddihim wa tarahumihim wa ta\'atufihim mathalul-jasad...',
      translation:
          'The believers in their mutual kindness, compassion and sympathy are like one body. When one limb aches, the whole body reacts with sleeplessness and fever.',
      source: 'Sahih Al-Bukhari 6011, Sahih Muslim 2586',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.brotherhood,
    ),

    Hadith(
      id: 52,
      hadithNumber: '71',
      narrator: 'Mu\'awiyah (RA)',
      arabic:
          'مَنْ يُرِدِ اللَّهُ بِهِ خَيْرًا يُفَقِّهْهُ فِي الدِّينِ',
      transliteration:
          'Man yuridillahu bihi khayran yufaqqihhu fid-din',
      translation:
          'When Allah wishes good for someone, He grants him understanding in the religion.',
      source: 'Sahih Al-Bukhari 71',
      collection: HadithCollection.bukhari,
      grade: HadithGrade.sahih,
      topic: HadithTopic.knowledge,
    ),

    // ══════════════════════════════════════════════════════════════════════
    // SELECTED MUSLIM HADITH - Famous and Beneficial
    // ══════════════════════════════════════════════════════════════════════

    Hadith(
      id: 53,
      hadithNumber: '2699',
      narrator: _abuHurairah,
      arabic:
          'مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ، وَمَا زَادَ اللَّهُ عَبْدًا بِعَفْوٍ إِلاَّ عِزًّا، وَمَا تَوَاضَعَ أَحَدٌ لِلَّهِ إِلاَّ رَفَعَهُ اللَّهُ',
      transliteration:
          'Ma naqasat sadaqatun min mal, wa ma zadallahu \'abdan bi\'afwin illa \'izzan, wa ma tawada\'a ahadun lillahi illa rafa\'ahullah',
      translation:
          'Charity does not decrease wealth. Allah does not increase a servant who forgives except in honor. And no one humbles himself before Allah except that Allah raises him.',
      source: 'Sahih Muslim 2588',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.charity,
    ),

    Hadith(
      id: 54,
      hadithNumber: '34',
      narrator: _abuHurairah,
      arabic:
          'الإِيمَانُ بِضْعٌ وَسَبْعُونَ - أَوْ بِضْعٌ وَسِتُّونَ - شُعْبَةً، فَأَفْضَلُهَا قَوْلُ لاَ إِلَهَ إِلاَّ اللَّهُ، وَأَدْنَاهَا إِمَاطَةُ الأَذَى عَنِ الطَّرِيقِ، وَالْحَيَاءُ شُعْبَةٌ مِنَ الإِيمَانِ',
      transliteration:
          'Al-imanu bid\'un wa sab\'una - aw bid\'un wa sittuna - shu\'bah...',
      translation:
          'Faith has over seventy - or sixty - branches. The highest is "La ilaha illallah," and the lowest is removing harm from the road. And modesty is a branch of faith.',
      source: 'Sahih Muslim 35',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
    ),

    Hadith(
      id: 55,
      hadithNumber: '2865',
      narrator: _abuHurairah,
      arabic:
          'إِذَا مَاتَ الإِنْسَانُ انْقَطَعَ عَنْهُ عَمَلُهُ إِلاَّ مِنْ ثَلاَثَةٍ: إِلاَّ مِنْ صَدَقَةٍ جَارِيَةٍ، أَوْ عِلْمٍ يُنْتَفَعُ بِهِ، أَوْ وَلَدٍ صَالِحٍ يَدْعُو لَهُ',
      transliteration:
          'Idha mata al-insanu inqata\'a \'anhu \'amaluhu illa min thalathah...',
      translation:
          'When a person dies, his deeds come to an end except for three: ongoing charity, beneficial knowledge, or a righteous child who prays for him.',
      source: 'Sahih Muslim 1631',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.charity,
    ),

    Hadith(
      id: 56,
      hadithNumber: '2594',
      narrator: _abuHurairah,
      arabic:
          'أَكْمَلُ الْمُؤْمِنِينَ إِيمَانًا أَحْسَنُهُمْ خُلُقًا، وَخِيَارُكُمْ خِيَارُكُمْ لِنِسَائِهِمْ',
      transliteration:
          'Akmalul-mu\'minina imanan ahsanuhum khuluqan, wa khiyarukum khiyarukum linisa\'ihim',
      translation:
          'The most complete of believers in faith are those with the best character, and the best of you are those who are best to their wives.',
      source: 'Sunan At-Tirmidhi 1162',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.family,
    ),

    Hadith(
      id: 57,
      hadithNumber: '2674',
      narrator: _abuHurairah,
      arabic:
          'مَنْ دَعَا إِلَى هُدًى كَانَ لَهُ مِنَ الأَجْرِ مِثْلُ أُجُورِ مَنْ تَبِعَهُ، لاَ يَنْقُصُ ذَلِكَ مِنْ أُجُورِهِمْ شَيْئًا',
      transliteration:
          'Man da\'a ila hudan kana lahu minal-ajri mithlu ujuri man tabi\'ahu...',
      translation:
          'Whoever calls to guidance will have a reward like the rewards of those who follow him, without that decreasing their rewards at all.',
      source: 'Sahih Muslim 2674',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.knowledge,
    ),

    Hadith(
      id: 58,
      hadithNumber: '2999',
      narrator: 'Suhaib (RA)',
      arabic:
          'عَجَبًا لأَمْرِ الْمُؤْمِنِ، إِنَّ أَمْرَهُ كُلَّهُ خَيْرٌ، وَلَيْسَ ذَاكَ لأَحَدٍ إِلاَّ لِلْمُؤْمِنِ: إِنْ أَصَابَتْهُ سَرَّاءُ شَكَرَ فَكَانَ خَيْرًا لَهُ، وَإِنْ أَصَابَتْهُ ضَرَّاءُ صَبَرَ فَكَانَ خَيْرًا لَهُ',
      transliteration:
          '\'Ajaban li-amril-mu\'min, inna amrahu kullahu khayrun...',
      translation:
          'How wonderful is the affair of the believer, for all his affairs are good. This is not the case for anyone except the believer. If something good happens to him, he is grateful and that is good for him. If something bad happens to him, he is patient and that is good for him.',
      source: 'Sahih Muslim 2999',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
    ),

    Hadith(
      id: 59,
      hadithNumber: '2607',
      narrator: _abuHurairah,
      arabic:
          'لاَ تَدْخُلُونَ الْجَنَّةَ حَتَّى تُؤْمِنُوا، وَلاَ تُؤْمِنُوا حَتَّى تَحَابُّوا، أَوَلاَ أَدُلُّكُمْ عَلَى شَيْءٍ إِذَا فَعَلْتُمُوهُ تَحَابَبْتُمْ؟ أَفْشُوا السَّلاَمَ بَيْنَكُمْ',
      transliteration:
          'La tadkhulul-jannata hatta tu\'minu, wa la tu\'minu hatta tahabbu...',
      translation:
          'You will not enter Paradise until you believe, and you will not believe until you love one another. Shall I not tell you of something that, if you do it, you will love one another? Spread the greeting of peace amongst yourselves.',
      source: 'Sahih Muslim 54',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.brotherhood,
    ),

    Hadith(
      id: 60,
      hadithNumber: '2687',
      narrator: _abuHurairah,
      arabic:
          'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ',
      transliteration:
          'Man salaka tariqan yaltamisu fihi \'ilman sahhalallahu lahu bihi tariqan ilal-jannah',
      translation:
          'Whoever takes a path seeking knowledge, Allah will make easy for him a path to Paradise.',
      source: 'Sahih Muslim 2699',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.knowledge,
    ),

    Hadith(
      id: 61,
      hadithNumber: '223',
      narrator: 'Abu Malik Al-Ash\'ari (RA)',
      arabic:
          'الطُّهُورُ شَطْرُ الإِيمَانِ',
      transliteration: 'At-tuhuru shatrul-iman',
      translation: 'Purification is half of faith.',
      source: 'Sahih Muslim 223',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.prayer,
    ),

    Hadith(
      id: 62,
      hadithNumber: '2626',
      narrator: _abuHurairah,
      arabic:
          'الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللَّهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ، وَفِي كُلٍّ خَيْرٌ',
      transliteration:
          'Al-mu\'minul-qawiyyu khayrun wa ahabbu ilallahi minal-mu\'minid-da\'if, wa fi kullin khayr',
      translation:
          'The strong believer is better and more beloved to Allah than the weak believer, while there is good in both.',
      source: 'Sahih Muslim 2664',
      collection: HadithCollection.muslim,
      grade: HadithGrade.sahih,
      topic: HadithTopic.faith,
    ),
  ];

  /// Get all hadith from a specific collection
  static List<Hadith> getByCollection(String collection) {
    return allHadiths
        .where((h) => h.collection == collection)
        .toList();
  }

  /// Get all hadith by topic
  static List<Hadith> getByTopic(String topic) {
    return allHadiths.where((h) => h.topic == topic).toList();
  }

  /// Get hadith by ID
  static Hadith? getById(int id) {
    try {
      return allHadiths.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Group hadith by collection
  static Map<String, List<Hadith>> get groupedByCollection {
    final Map<String, List<Hadith>> grouped = {};
    for (final collection in HadithCollection.all) {
      final items = getByCollection(collection);
      if (items.isNotEmpty) {
        grouped[collection] = items;
      }
    }
    return grouped;
  }

  /// Group hadith by topic
  static Map<String, List<Hadith>> get groupedByTopic {
    final Map<String, List<Hadith>> grouped = {};
    for (final topic in HadithTopic.all) {
      final items = getByTopic(topic);
      if (items.isNotEmpty) {
        grouped[topic] = items;
      }
    }
    return grouped;
  }
}
