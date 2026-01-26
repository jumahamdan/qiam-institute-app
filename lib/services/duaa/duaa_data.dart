import '../../models/duaa.dart';

class DuaaData {
  static const List<Duaa> allDuaas = [
    // ============================================
    // MORNING & EVENING ADHKAR
    // ============================================
    Duaa(
      id: 1,
      duaNumber: '1.1',
      title: 'Morning Remembrance',
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: "Asbahnā wa asbahal-mulku lillāh, wal-hamdu lillāh, lā ilāha illallāhu wahdahu lā sharīka lah, lahul-mulku wa lahul-hamd, wa huwa 'alā kulli shay'in qadīr",
      translation: 'We have reached the morning and at this very time the whole kingdom belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent.',
      source: 'Sahih Muslim 4/2088',
      category: DuaaCategory.morningEvening,
      remarks: 'Recite this dua when you wake up in the morning. This comprehensive supplication acknowledges Allah\'s complete sovereignty and is one of the most important morning adhkar.',
    ),
    Duaa(
      id: 2,
      duaNumber: '1.2',
      title: 'Evening Remembrance',
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration: "Amsaynā wa amsal-mulku lillāh, wal-hamdu lillāh, lā ilāha illallāhu wahdahu lā sharīka lah, lahul-mulku wa lahul-hamd, wa huwa 'alā kulli shay'in qadīr",
      translation: 'We have reached the evening and at this very time the whole kingdom belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent.',
      source: 'Sahih Muslim 4/2088',
      category: DuaaCategory.morningEvening,
      remarks: 'The evening counterpart to the morning remembrance. Recite this after Maghrib to acknowledge Allah\'s protection throughout the day.',
    ),
    Duaa(
      id: 3,
      duaNumber: '1.3',
      title: 'Sayyid al-Istighfar (Master of Seeking Forgiveness)',
      arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      transliteration: "Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa ana 'abduk, wa ana 'alā 'ahdika wa wa'dika mastata't, a'ūdhu bika min sharri mā sana't, abū'u laka bini'matika 'alayya, wa abū'u bidhanbī faghfir lī fa innahu lā yaghfirudh-dhunūba illā ant",
      translation: 'O Allah, You are my Lord. None has the right to be worshipped but You. You created me and I am Your slave. I am faithful to my covenant and promise to You as much as I can. I seek refuge in You from the evil of what I have done. I acknowledge before You all the blessings You have bestowed upon me, and I confess my sins to You. So forgive me, for none can forgive sins except You.',
      source: 'Sahih Al-Bukhari 6306',
      category: DuaaCategory.morningEvening,
      remarks: 'This is known as "Sayyid al-Istighfar" - the master of seeking forgiveness. The Prophet ﷺ said: "Whoever says it during the day with conviction and dies that day before evening will enter Paradise, and whoever says it at night with conviction and dies before morning will enter Paradise."',
    ),
    Duaa(
      id: 4,
      duaNumber: '1.4',
      title: 'Morning/Evening Protection (3 times)',
      arabic: 'بِسْمِ اللّٰهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      transliteration: "Bismillāhil-ladhī lā yadurru ma'as-mihi shay'un fil-ardi wa lā fis-samā', wa huwas-samī'ul-'alīm",
      translation: 'In the Name of Allah, with Whose Name nothing on earth or in heaven can cause harm, and He is the All-Hearing, the All-Knowing.',
      source: 'Sunan Abu Dawud 5088; Sunan At-Tirmidhi 3388',
      category: DuaaCategory.morningEvening,
      remarks: 'Recite three times in the morning and evening. The Prophet ﷺ said: "Whoever recites it three times in the morning will not be afflicted by any calamity before evening, and whoever recites it three times in the evening will not be afflicted by any calamity before morning."',
    ),
    Duaa(
      id: 5,
      duaNumber: '1.5',
      title: 'Glorification of Allah (100 times)',
      arabic: 'سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ',
      transliteration: 'Subhānallāhi wa bihamdih',
      translation: 'Glory is to Allah and praise is to Him.',
      source: 'Sahih Al-Bukhari 4/2071; Sahih Muslim 4/2071',
      category: DuaaCategory.morningEvening,
      remarks: 'Recite 100 times in morning and evening. The Prophet ﷺ said: "Whoever says this one hundred times during the day, his sins will be wiped away, even if they are like the foam of the sea."',
    ),

    // ============================================
    // SLEEP
    // ============================================
    Duaa(
      id: 6,
      duaNumber: '2.1',
      title: 'Before Sleep',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allāhumma amūtu wa ahyā',
      translation: 'In Your name, O Allah, I die and I live.',
      source: 'Sahih Al-Bukhari 6324, Fathul-Bari 11/113; Sahih Muslim 4/2083',
      category: DuaaCategory.sleep,
      remarks: 'Sleep is described as a minor death, where the soul temporarily leaves the body. This dua acknowledges that our life and death are in Allah\'s hands. The Prophet ﷺ would say this before sleeping.',
    ),
    Duaa(
      id: 7,
      duaNumber: '2.2',
      title: 'Upon Waking',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      transliteration: "Alhamdu lillāhil-ladhī ahyānā ba'da mā amātanā wa ilayhin-nushūr",
      translation: 'All praise is for Allah who gave us life after having taken it from us, and unto Him is the resurrection.',
      source: 'Sahih Al-Bukhari, Fathul-Bari 11/113; Sahih Muslim 4/2083',
      category: DuaaCategory.sleep,
      remarks: 'Upon waking, we thank Allah for returning our soul to us. This dua also reminds us of the Day of Resurrection when we will be raised from death.',
    ),
    Duaa(
      id: 8,
      duaNumber: '2.3',
      title: 'Ayatul Kursi Before Sleep',
      arabic: 'اللّٰهُ لَا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      transliteration: "Allāhu lā ilāha illā huwal-hayyul-qayyūm, lā ta'khudhuhu sinatun wa lā nawm, lahu mā fis-samāwāti wa mā fil-ard, man dhal-ladhī yashfa'u 'indahu illā bi'idhnih, ya'lamu mā bayna aydīhim wa mā khalfahum, wa lā yuhītūna bishay'in min 'ilmihi illā bimā shā', wasi'a kursiyyuhus-samāwāti wal-ard, wa lā ya'ūduhu hifzuhumā, wa huwal-'aliyyul-'azīm",
      translation: 'Allah! There is no god but He, the Living, the Self-Subsisting. Neither slumber nor sleep overtakes Him. To Him belongs whatever is in the heavens and the earth. Who can intercede with Him except by His permission? He knows what is before them and what is behind them, and they encompass nothing of His knowledge except what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.',
      source: 'Surah Al-Baqarah 2:255; Sahih Al-Bukhari 5010',
      category: DuaaCategory.sleep,
      remarks: 'The Prophet ﷺ said: "When you go to bed, recite Ayatul Kursi. A guardian from Allah will then remain over you, and Satan will not come near you until morning."',
    ),
    Duaa(
      id: 9,
      duaNumber: '2.4',
      title: 'Sleeping on Your Side',
      arabic: 'اللَّهُمَّ بِاسْمِكَ أَحْيَا وَأَمُوتُ',
      transliteration: 'Allāhumma bismika ahyā wa amūt',
      translation: 'O Allah, in Your name I live and die.',
      source: 'Sahih Al-Bukhari 6325',
      category: DuaaCategory.sleep,
      remarks: 'It is Sunnah to sleep on the right side. Place your right hand under your cheek and recite this dua.',
    ),

    // ============================================
    // MASJID
    // ============================================
    Duaa(
      id: 10,
      duaNumber: '3.1',
      title: 'Entering the Masjid',
      arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      transliteration: 'Allāhummaf-tah lī abwāba rahmatik',
      translation: 'O Allah, open for me the doors of Your mercy.',
      source: 'Sahih Muslim 713',
      category: DuaaCategory.masjid,
      remarks: 'Enter with your right foot first. Say "Bismillah" and send salawat upon the Prophet ﷺ. The masjid is the house of Allah where we seek His mercy and blessings.',
    ),
    Duaa(
      id: 11,
      duaNumber: '3.2',
      title: 'Leaving the Masjid',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      transliteration: "Allāhumma innī as'aluka min fadlik",
      translation: 'O Allah, I ask You from Your bounty.',
      source: 'Sahih Muslim 713',
      category: DuaaCategory.masjid,
      remarks: 'Exit with your left foot first. As we leave the masjid to return to worldly affairs, we ask Allah for His bounty in all our endeavors.',
    ),
    Duaa(
      id: 12,
      duaNumber: '3.3',
      title: 'After the Adhan',
      arabic: 'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ',
      transliteration: "Allāhumma rabba hādhihid-da'watit-tāmmah, was-salātil-qā'imah, āti Muhammadanil-wasīlata wal-fadīlah, wab'athhu maqāmam mahmūdanil-ladhī wa'adtah",
      translation: 'O Allah, Lord of this perfect call and established prayer, grant Muhammad the intercession and favor, and raise him to the honored station You have promised him.',
      source: 'Sahih Al-Bukhari 614',
      category: DuaaCategory.masjid,
      remarks: 'The Prophet ﷺ said: "Whoever says this after the call to prayer, my intercession will be granted to him on the Day of Judgment."',
    ),

    // ============================================
    // FOOD
    // ============================================
    Duaa(
      id: 13,
      duaNumber: '4.1',
      title: 'Before Eating',
      arabic: 'بِسْمِ اللّٰهِ',
      transliteration: 'Bismillāh',
      translation: 'In the name of Allah.',
      source: 'Sahih Al-Bukhari 5376; Sahih Muslim 2017',
      category: DuaaCategory.food,
      remarks: 'Say "Bismillah" before eating. The Prophet ﷺ said: "When one of you eats, let him mention the name of Allah. If he forgets to mention the name of Allah at the beginning, let him say: Bismillahi fi awwalihi wa akhirih (In the name of Allah at its beginning and end)."',
    ),
    Duaa(
      id: 14,
      duaNumber: '4.2',
      title: 'Forgot to Say Bismillah',
      arabic: 'بِسْمِ اللّٰهِ فِي أَوَّلِهِ وَآخِرِهِ',
      transliteration: 'Bismillāhi fī awwalihi wa ākhirih',
      translation: 'In the name of Allah at its beginning and end.',
      source: 'Sunan Abu Dawud 3/347; Sunan At-Tirmidhi 4/288',
      category: DuaaCategory.food,
      remarks: 'If you forget to say Bismillah at the beginning of the meal, say this when you remember.',
    ),
    Duaa(
      id: 15,
      duaNumber: '4.3',
      title: 'After Eating',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
      transliteration: "Alhamdu lillāhil-ladhī at'amanī hādhā wa razaqanīhi min ghayri hawlin minnī wa lā quwwah",
      translation: 'All praise is for Allah who has fed me this and provided it for me without any might or power from myself.',
      source: 'Sunan At-Tirmidhi 3458; Sunan Abu Dawud 4023',
      category: DuaaCategory.food,
      remarks: 'The Prophet ﷺ said: "Whoever eats food and then says this, his previous sins will be forgiven."',
    ),
    Duaa(
      id: 16,
      duaNumber: '4.4',
      title: 'When Breaking Fast',
      arabic: 'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللّٰهُ',
      transliteration: "Dhahabaz-zama'u wabtallatil-'urūqu wa thabatal-ajru in shā'Allāh",
      translation: 'The thirst has gone, the veins are moistened, and the reward is confirmed, if Allah wills.',
      source: 'Sunan Abu Dawud 2357; graded Hasan by Al-Albani',
      category: DuaaCategory.food,
      remarks: 'Say this dua when breaking your fast. It acknowledges the physical relief and spiritual reward of fasting.',
    ),
    Duaa(
      id: 17,
      duaNumber: '4.5',
      title: 'When Invited to Eat',
      arabic: 'اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ وَاغْفِرْ لَهُمْ وَارْحَمْهُمْ',
      transliteration: 'Allāhumma bārik lahum fīmā razaqtahum, waghfir lahum, warhamhum',
      translation: 'O Allah, bless them in what You have provided for them, forgive them and have mercy upon them.',
      source: 'Sahih Muslim 2042',
      category: DuaaCategory.food,
      remarks: 'Make this dua for your host when you are invited to eat at someone\'s house.',
    ),

    // ============================================
    // FORGIVENESS & GUIDANCE
    // ============================================
    Duaa(
      id: 18,
      duaNumber: '5.1',
      title: 'Seeking Forgiveness',
      arabic: 'أَسْتَغْفِرُ اللّٰهَ الْعَظِيمَ الَّذِي لَا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
      transliteration: "Astaghfirullāhal-'azīm alladhī lā ilāha illā huwal-hayyul-qayyūmu wa atūbu ilayh",
      translation: 'I seek forgiveness from Allah the Magnificent, there is no god but He, the Living, the Self-Subsisting, and I repent to Him.',
      source: 'Sunan Abu Dawud 1517; Sunan At-Tirmidhi 3577; graded Sahih by Al-Albani',
      category: DuaaCategory.forgivenessGuidance,
      remarks: 'The Prophet ﷺ said: "Whoever says this, his sins will be forgiven, even if he fled from battle."',
    ),
    Duaa(
      id: 19,
      duaNumber: '5.2',
      title: 'For Guidance',
      arabic: 'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',
      transliteration: 'Allāhummahdinī wa saddidnī',
      translation: 'O Allah, guide me and keep me on the right path.',
      source: 'Sahih Muslim 2725',
      category: DuaaCategory.forgivenessGuidance,
      remarks: 'A short but powerful dua asking for both guidance to the truth and steadfastness upon it. "Saddidnī" means to make straight, like an arrow hitting its target.',
    ),
    Duaa(
      id: 20,
      duaNumber: '5.3',
      title: 'For Taqwa (God-Consciousness)',
      arabic: 'اللَّهُمَّ آتِ نَفْسِي تَقْوَاهَا وَزَكِّهَا أَنْتَ خَيْرُ مَنْ زَكَّاهَا أَنْتَ وَلِيُّهَا وَمَوْلَاهَا',
      transliteration: 'Allāhumma āti nafsī taqwāhā wa zakkihā anta khayru man zakkāhā anta waliyyuhā wa mawlāhā',
      translation: 'O Allah, grant my soul its God-consciousness and purify it, for You are the best to purify it. You are its Guardian and Master.',
      source: 'Sahih Muslim 2722',
      category: DuaaCategory.forgivenessGuidance,
      remarks: 'This dua asks Allah for the essential quality of taqwa - consciousness and fear of Allah that leads to righteous action.',
    ),
    Duaa(
      id: 21,
      duaNumber: '5.4',
      title: 'For Good Character',
      arabic: 'اللَّهُمَّ اهْدِنِي لِأَحْسَنِ الْأَخْلَاقِ لَا يَهْدِي لِأَحْسَنِهَا إِلَّا أَنْتَ وَاصْرِفْ عَنِّي سَيِّئَهَا لَا يَصْرِفُ عَنِّي سَيِّئَهَا إِلَّا أَنْتَ',
      transliteration: "Allāhummahdini li ahsanil-akhlāqi lā yahdī li ahsanihā illā ant, wasrif 'annī sayyi'ahā lā yasrifu 'annī sayyi'ahā illā ant",
      translation: 'O Allah, guide me to the best of characters, for none guides to the best of them except You. Turn away from me bad character, for none can turn it away from me except You.',
      source: 'Sahih Muslim 771',
      category: DuaaCategory.forgivenessGuidance,
      remarks: 'The Prophet ﷺ used to say this in his night prayer. Good character is among the heaviest deeds on the scale on the Day of Judgment.',
    ),

    // ============================================
    // TRAVEL
    // ============================================
    Duaa(
      id: 22,
      duaNumber: '6.1',
      title: 'When Starting a Journey',
      arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ',
      transliteration: 'Subhānal-ladhī sakhkhara lanā hādhā wa mā kunnā lahu muqrinīn, wa innā ilā rabbinā lamunqalibūn',
      translation: 'Glory be to Him who has subjected this to us, and we could never have accomplished it ourselves. And indeed, to our Lord we will return.',
      source: 'Surah Az-Zukhruf 43:13-14; Sahih Muslim 1342',
      category: DuaaCategory.travel,
      remarks: 'Recite this when boarding any vehicle - car, plane, ship, etc. It acknowledges that all transport is a blessing from Allah.',
    ),
    Duaa(
      id: 23,
      duaNumber: '6.2',
      title: 'Comprehensive Travel Dua',
      arabic: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ، اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ وَالْخَلِيفَةُ فِي الْأَهْلِ',
      transliteration: "Allāhumma innā nas'aluka fī safarinā hādhal-birra wat-taqwā, wa minal-'amali mā tardā. Allāhumma hawwin 'alaynā safaranā hādhā watwi 'annā bu'dah. Allāhumma antas-sāhibu fis-safari wal-khalīfatu fil-ahl",
      translation: 'O Allah, we ask You in this journey of ours for righteousness, taqwa, and deeds that please You. O Allah, make this journey easy for us and fold up for us the distance. O Allah, You are the Companion on the journey and the Guardian of the family.',
      source: 'Sahih Muslim 1342; Sunan At-Tirmidhi 3447',
      category: DuaaCategory.travel,
      remarks: 'A comprehensive dua that the Prophet ﷺ would say when embarking on a journey, asking for goodness in travel and protection for family left behind.',
    ),
    Duaa(
      id: 24,
      duaNumber: '6.3',
      title: 'Returning from Travel',
      arabic: 'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
      transliteration: "Āyibūna tā'ibūna 'ābidūna lirabbinā hāmidūn",
      translation: 'We return, repenting, worshipping, and praising our Lord.',
      source: 'Sahih Al-Bukhari 1797; Sahih Muslim 1342',
      category: DuaaCategory.travel,
      remarks: 'Say this when returning from a journey. The Prophet ﷺ would repeat this throughout his return journey.',
    ),
    Duaa(
      id: 25,
      duaNumber: '6.4',
      title: 'When Entering a Town',
      arabic: 'اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ وَمَا أَظْلَلْنَ وَرَبَّ الْأَرَضِينَ السَّبْعِ وَمَا أَقْلَلْنَ وَرَبَّ الشَّيَاطِينِ وَمَا أَضْلَلْنَ وَرَبَّ الرِّيَاحِ وَمَا ذَرَيْنَ، أَسْأَلُكَ خَيْرَ هَذِهِ الْقَرْيَةِ وَخَيْرَ أَهْلِهَا وَخَيْرَ مَا فِيهَا وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ أَهْلِهَا وَشَرِّ مَا فِيهَا',
      transliteration: "Allāhumma rabbas-samāwātis-sab'i wa mā azlalna, wa rabbal-aradeenas-sab'i wa mā aqlalna, wa rabbash-shayātīni wa mā adlalna, wa rabbar-riyāhi wa mā dharayna. As'aluka khayra hādhihil-qaryati wa khayra ahlihā wa khayra mā fīhā, wa a'ūdhu bika min sharrihā wa sharri ahlihā wa sharri mā fīhā",
      translation: 'O Allah, Lord of the seven heavens and what they shade, Lord of the seven earths and what they carry, Lord of the devils and those they lead astray, Lord of the winds and what they scatter. I ask You for the goodness of this town, the goodness of its people, and the goodness of what is in it. I seek refuge in You from its evil, the evil of its people, and the evil of what is in it.',
      source: 'Al-Hakim 2/100; Ibn As-Sunni 524; graded Sahih by Al-Albani',
      category: DuaaCategory.travel,
      remarks: 'Recite this dua when entering a new city or town during your travels.',
    ),

    // ============================================
    // HOME
    // ============================================
    Duaa(
      id: 26,
      duaNumber: '7.1',
      title: 'Leaving the Home',
      arabic: 'بِسْمِ اللّٰهِ، تَوَكَّلْتُ عَلَى اللّٰهِ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ',
      transliteration: "Bismillāh, tawakkaltu 'alallāh, wa lā hawla wa lā quwwata illā billāh",
      translation: 'In the name of Allah, I place my trust in Allah, and there is no might nor power except with Allah.',
      source: 'Sunan Abu Dawud 5095; Sunan At-Tirmidhi 3426',
      category: DuaaCategory.home,
      remarks: 'The Prophet ﷺ said: "Whoever says this when leaving his house, it will be said to him: You are guided, defended, and protected. The devils will turn away from him."',
    ),
    Duaa(
      id: 27,
      duaNumber: '7.2',
      title: 'Entering the Home',
      arabic: 'بِسْمِ اللّٰهِ وَلَجْنَا، وَبِسْمِ اللّٰهِ خَرَجْنَا، وَعَلَى اللّٰهِ رَبِّنَا تَوَكَّلْنَا',
      transliteration: "Bismillāhi walajnā, wa bismillāhi kharajnā, wa 'alallāhi rabbinā tawakkalnā",
      translation: 'In the name of Allah we enter, in the name of Allah we leave, and upon Allah our Lord we place our trust.',
      source: 'Sunan Abu Dawud 5096; graded Sahih by Al-Albani',
      category: DuaaCategory.home,
      remarks: 'Say this when entering your home, then greet your family with salam. The Prophet ﷺ encouraged saying bismillah when entering the home.',
    ),
    Duaa(
      id: 28,
      duaNumber: '7.3',
      title: 'For a New Home',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلِجِ وَخَيْرَ الْمَخْرَجِ، بِسْمِ اللّٰهِ وَلَجْنَا، وَبِسْمِ اللّٰهِ خَرَجْنَا، وَعَلَى اللّٰهِ رَبِّنَا تَوَكَّلْنَا',
      transliteration: "Allāhumma innī as'aluka khayral-mawliji wa khayral-makhraji, bismillāhi walajnā, wa bismillāhi kharajnā, wa 'alallāhi rabbinā tawakkalnā",
      translation: 'O Allah, I ask You for the best entrance and the best exit. In the name of Allah we enter, in the name of Allah we leave, and upon Allah our Lord we place our trust.',
      source: 'Sunan Abu Dawud 5096',
      category: DuaaCategory.home,
      remarks: 'This extended version can be recited when entering a new home for the first time, asking Allah for blessings in your dwelling.',
    ),

    // ============================================
    // BATHROOM / TOILET
    // ============================================
    Duaa(
      id: 29,
      duaNumber: '8.1',
      title: 'Before Entering the Bathroom',
      arabic: 'بِسْمِ اللّٰهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبْثِ وَالْخَبَائِثِ',
      transliteration: "Bismillāh, Allāhumma innī a'ūdhu bika minal-khubthi wal-khabā'ith",
      translation: 'In the name of Allah. O Allah, I seek refuge with You from male and female evil spirits.',
      source: 'Sahih Al-Bukhari 142; Sahih Muslim 375',
      category: DuaaCategory.bathroom,
      remarks: 'Enter with your left foot first. The bathroom is a place where evil spirits dwell, so we seek protection before entering. Say bismillah silently before entering.',
    ),
    Duaa(
      id: 30,
      duaNumber: '8.2',
      title: 'After Leaving the Bathroom',
      arabic: 'غُفْرَانَكَ',
      transliteration: 'Ghufrānak',
      translation: 'I seek Your forgiveness.',
      source: 'Sunan Abu Dawud 30; Sunan At-Tirmidhi 7; Sunan Ibn Majah 300',
      category: DuaaCategory.bathroom,
      remarks: 'Exit with your right foot first. The scholars say we seek forgiveness because we were unable to remember Allah while in the bathroom, and we make up for that shortcoming by asking for forgiveness.',
    ),

    // ============================================
    // WUDU (ABLUTION)
    // ============================================
    Duaa(
      id: 31,
      duaNumber: '9.1',
      title: 'Before Wudu',
      arabic: 'بِسْمِ اللّٰهِ',
      transliteration: 'Bismillāh',
      translation: 'In the name of Allah.',
      source: 'Sunan Abu Dawud 101; Sunan Ibn Majah 399; Musnad Ahmad 9418',
      category: DuaaCategory.wudu,
      remarks: 'Begin your ablution by saying bismillah. Some scholars consider this obligatory, while others consider it highly recommended.',
    ),
    Duaa(
      id: 32,
      duaNumber: '9.2',
      title: 'After Completing Wudu',
      arabic: 'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      transliteration: "Ash-hadu an lā ilāha illallāhu wahdahu lā sharīka lah, wa ash-hadu anna Muhammadan 'abduhu wa rasūluh",
      translation: 'I bear witness that none has the right to be worshipped but Allah alone, Who has no partner; and I bear witness that Muhammad is His slave and His Messenger.',
      source: 'Sahih Muslim 234',
      category: DuaaCategory.wudu,
      remarks: 'The Prophet ﷺ said: "Whoever performs wudu and does it well, then says this, the eight gates of Paradise will be opened for him, and he may enter through whichever one he wishes."',
    ),
    Duaa(
      id: 33,
      duaNumber: '9.3',
      title: 'Additional Dua After Wudu',
      arabic: 'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',
      transliteration: 'Allāhummaj\'alnī minat-tawwābīna waj\'alnī minal-mutatahhirīn',
      translation: 'O Allah, make me among those who turn to You in repentance, and make me among those who are purified.',
      source: 'Sunan At-Tirmidhi 55',
      category: DuaaCategory.wudu,
      remarks: 'This dua can be added after the shahada following wudu, asking Allah for spiritual purification along with physical purification.',
    ),

    // ============================================
    // ANXIETY & DISTRESS
    // ============================================
    Duaa(
      id: 34,
      duaNumber: '10.1',
      title: 'For Anxiety and Sorrow',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ',
      transliteration: "Allāhumma innī a'ūdhu bika minal-hammi wal-hazan, wal-'ajzi wal-kasal, wal-bukhli wal-jubn, wa dala'id-dayni wa ghalabatir-rijāl",
      translation: 'O Allah, I seek refuge in You from anxiety and sorrow, from weakness and laziness, from miserliness and cowardice, from the burden of debt and from being overpowered by men.',
      source: 'Sahih Al-Bukhari 2893; Sahih Muslim 2706',
      category: DuaaCategory.anxietyDistress,
      remarks: 'The Prophet ﷺ used to frequently make this comprehensive dua seeking refuge from eight destructive things that affect the heart and circumstances.',
    ),
    Duaa(
      id: 35,
      duaNumber: '10.2',
      title: 'In Times of Distress',
      arabic: 'لَا إِلٰهَ إِلَّا اللّٰهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلٰهَ إِلَّا اللّٰهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلٰهَ إِلَّا اللّٰهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الْأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ',
      transliteration: "Lā ilāha illallāhul-'azīmul-halīm, lā ilāha illallāhu rabbul-'arshil-'azīm, lā ilāha illallāhu rabbus-samāwāti wa rabbul-ardi wa rabbul-'arshil-karīm",
      translation: 'There is no god but Allah, the Most Great, the Forbearing. There is no god but Allah, Lord of the Mighty Throne. There is no god but Allah, Lord of the heavens and Lord of the earth, and Lord of the Noble Throne.',
      source: 'Sahih Al-Bukhari 6345; Sahih Muslim 2730',
      category: DuaaCategory.anxietyDistress,
      remarks: 'The Prophet ﷺ would say this supplication at times of distress and difficulty. It focuses on Allah\'s greatness and sovereignty.',
    ),
    Duaa(
      id: 36,
      duaNumber: '10.3',
      title: 'Dua of Yunus (Jonah)',
      arabic: 'لَا إِلٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      transliteration: 'Lā ilāha illā anta subhānaka innī kuntu minaz-zālimīn',
      translation: 'There is no god but You, glory be to You. Indeed, I have been among the wrongdoers.',
      source: 'Surah Al-Anbiya 21:87; Sunan At-Tirmidhi 3505',
      category: DuaaCategory.anxietyDistress,
      remarks: 'This is the dua Prophet Yunus (Jonah) made from the belly of the whale. The Prophet ﷺ said: "No Muslim makes dua with it for anything but Allah will respond to him."',
    ),
    Duaa(
      id: 37,
      duaNumber: '10.4',
      title: 'When Overwhelmed',
      arabic: 'حَسْبِيَ اللّٰهُ لَا إِلٰهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
      transliteration: "Hasbiyallāhu lā ilāha illā huwa 'alayhi tawakkaltu wa huwa rabbul-'arshil-'azīm",
      translation: 'Allah is sufficient for me. There is no god but He. Upon Him I place my trust, and He is the Lord of the Mighty Throne.',
      source: 'Surah At-Tawbah 9:129; Sunan Abu Dawud 5081',
      category: DuaaCategory.anxietyDistress,
      remarks: 'Recite this seven times in the morning and evening. The Prophet ﷺ said: "Whoever says this seven times, Allah will suffice him in whatever concerns him."',
    ),

    // ============================================
    // PROTECTION
    // ============================================
    Duaa(
      id: 38,
      duaNumber: '11.1',
      title: 'Seeking Protection',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللّٰهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: "A'ūdhu bikalimātillāhit-tāmmāti min sharri mā khalaq",
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      source: 'Sahih Muslim 2708',
      category: DuaaCategory.protection,
      remarks: 'Recite three times in the evening. The Prophet ﷺ said: "Whoever says this three times when he reaches the evening, no poisonous sting will harm him that night."',
    ),
    Duaa(
      id: 39,
      duaNumber: '11.2',
      title: 'For Protection of Family',
      arabic: 'أُعِيذُكُمَا بِكَلِمَاتِ اللّٰهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ',
      transliteration: "U'īdhukumā bikalimātillāhit-tāmmati min kulli shaytānin wa hāmmah, wa min kulli 'aynin lāmmah",
      translation: 'I seek protection for you both in the perfect words of Allah from every devil and every poisonous creature, and from every evil eye.',
      source: 'Sahih Al-Bukhari 3371',
      category: DuaaCategory.protection,
      remarks: 'The Prophet Ibrahim (Abraham) used to seek refuge with Allah for Ismail and Ishaq with these words, and the Prophet ﷺ used to seek refuge for Hasan and Husayn.',
    ),
    Duaa(
      id: 40,
      duaNumber: '11.3',
      title: 'Against the Evil Eye',
      arabic: 'بِسْمِ اللّٰهِ أَرْقِيكَ، مِنْ كُلِّ شَيْءٍ يُؤْذِيكَ، مِنْ شَرِّ كُلِّ نَفْسٍ أَوْ عَيْنِ حَاسِدٍ، اللّٰهُ يَشْفِيكَ، بِسْمِ اللّٰهِ أَرْقِيكَ',
      transliteration: "Bismillāhi arqīk, min kulli shay'in yu'dhīk, min sharri kulli nafsin aw 'ayni hāsid, Allāhu yashfīk, bismillāhi arqīk",
      translation: 'In the name of Allah I perform ruqyah for you. From everything that harms you. From the evil of every soul or envious eye. May Allah heal you. In the name of Allah I perform ruqyah for you.',
      source: 'Sahih Muslim 2186',
      category: DuaaCategory.protection,
      remarks: 'This is the ruqyah (spiritual healing) that Jibreel taught the Prophet ﷺ. It can be recited for oneself or for others.',
    ),

    // ============================================
    // HEALTH & SICKNESS
    // ============================================
    Duaa(
      id: 41,
      duaNumber: '12.1',
      title: 'For the Sick',
      arabic: 'اللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ الْبَأْسَ، وَاشْفِ أَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءً لَا يُغَادِرُ سَقَمًا',
      transliteration: "Allāhumma rabban-nās, adhhibil-ba's, washfi antash-shāfī, lā shifā'a illā shifā'uk, shifā'an lā yughādiru saqamā",
      translation: 'O Allah, Lord of mankind, remove the hardship. Heal, for You are the Healer. There is no healing except Your healing, a healing that leaves no illness behind.',
      source: 'Sahih Al-Bukhari 5675; Sahih Muslim 2191',
      category: DuaaCategory.healthSickness,
      remarks: 'The Prophet ﷺ used to visit the sick and make this dua for them, placing his hand on the place of pain.',
    ),
    Duaa(
      id: 42,
      duaNumber: '12.2',
      title: 'When Visiting the Sick',
      arabic: 'لَا بَأْسَ، طَهُورٌ إِنْ شَاءَ اللّٰهُ',
      transliteration: "Lā ba's, tahūrun in shā'Allāh",
      translation: 'No harm, it is purification, if Allah wills.',
      source: 'Sahih Al-Bukhari 3616',
      category: DuaaCategory.healthSickness,
      remarks: 'Say this to comfort the sick person. Illness expiates sins, so it serves as a purification for the believer.',
    ),
    Duaa(
      id: 43,
      duaNumber: '12.3',
      title: 'When in Pain',
      arabic: 'بِسْمِ اللّٰهِ (ثَلَاثًا) أَعُوذُ بِاللّٰهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ',
      transliteration: "Bismillāh (3 times), a'ūdhu billāhi wa qudratihi min sharri mā ajidu wa uhādhir",
      translation: 'In the name of Allah (3 times). I seek refuge in Allah and His power from the evil of what I am experiencing and what I fear.',
      source: 'Sahih Muslim 2202',
      category: DuaaCategory.healthSickness,
      remarks: 'Place your hand on the place of pain and say bismillah three times, then say this dua seven times.',
    ),
    Duaa(
      id: 44,
      duaNumber: '12.4',
      title: 'For Good Health',
      arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلٰهَ إِلَّا أَنْتَ',
      transliteration: "Allāhumma 'āfinī fī badanī, Allāhumma 'āfinī fī sam'ī, Allāhumma 'āfinī fī basarī, lā ilāha illā ant",
      translation: 'O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight. There is no god but You.',
      source: 'Sunan Abu Dawud 5090; graded Hasan by Al-Albani',
      category: DuaaCategory.healthSickness,
      remarks: 'Recite this three times in the morning and evening, asking Allah to preserve your physical health.',
    ),

    // ============================================
    // CLOTHING
    // ============================================
    Duaa(
      id: 45,
      duaNumber: '13.1',
      title: 'When Wearing New Clothes',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
      transliteration: 'Alhamdu lillāhil-ladhī kasānī hādhā wa razaqanīhi min ghayri hawlin minnī wa lā quwwah',
      translation: 'All praise is for Allah who has clothed me with this and provided it for me without any power or might from myself.',
      source: 'Sunan Abu Dawud 4023; Sunan At-Tirmidhi 3458; Sunan Ibn Majah 3285',
      category: DuaaCategory.clothing,
      remarks: 'The Prophet ﷺ said: "Whoever wears a new garment and says this, his past sins will be forgiven."',
    ),
    Duaa(
      id: 46,
      duaNumber: '13.2',
      title: 'When Someone Wears New Clothes',
      arabic: 'تُبْلِي وَيُخْلِفُ اللّٰهُ تَعَالَى',
      transliteration: "Tublī wa yukhliful-lāhu ta'ālā",
      translation: 'May you wear it out and may Allah replace it.',
      source: 'Sunan Abu Dawud 4020; graded Sahih by Al-Albani',
      category: DuaaCategory.clothing,
      remarks: 'Say this as a blessing when you see someone wearing new clothes, wishing them long life to wear it out and that Allah provides them with more.',
    ),

    // ============================================
    // QURANIC DUAS
    // ============================================
    Duaa(
      id: 47,
      duaNumber: '14.1',
      title: 'For This World and the Hereafter',
      arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      transliteration: "Rabbanā ātinā fid-dunyā hasanatan wa fil-ākhirati hasanatan wa qinā 'adhāban-nār",
      translation: 'Our Lord, give us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.',
      source: 'Surah Al-Baqarah 2:201; Sahih Al-Bukhari 4522; Sahih Muslim 2690',
      category: DuaaCategory.quranic,
      remarks: 'This was the most frequent dua of the Prophet ﷺ. It is comprehensive, asking for good in both this life and the next.',
    ),
    Duaa(
      id: 48,
      duaNumber: '14.2',
      title: 'For Patience and Good End',
      arabic: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
      transliteration: 'Rabbanā afrigh \'alaynā sabran wa tawaffanā muslimīn',
      translation: 'Our Lord, pour upon us patience and let us die as Muslims.',
      source: 'Surah Al-A\'raf 7:126',
      category: DuaaCategory.quranic,
      remarks: 'This was the dua of the magicians of Pharaoh after they believed in Musa (Moses), asking for steadfastness until death.',
    ),
    Duaa(
      id: 49,
      duaNumber: '14.3',
      title: 'For Righteous Offspring',
      arabic: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      transliteration: "Rabbanā hab lanā min azwājinā wa dhurriyyātinā qurrata a'yunin waj'alnā lil-muttaqīna imāmā",
      translation: 'Our Lord, grant us from our spouses and offspring comfort to our eyes and make us leaders for the righteous.',
      source: 'Surah Al-Furqan 25:74',
      category: DuaaCategory.quranic,
      remarks: 'This beautiful dua asks for a righteous family that brings joy to the heart and for the honor of leading others in righteousness.',
    ),
    Duaa(
      id: 50,
      duaNumber: '14.4',
      title: 'For Knowledge',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      transliteration: "Rabbi zidnī 'ilmā",
      translation: 'My Lord, increase me in knowledge.',
      source: 'Surah Ta-Ha 20:114',
      category: DuaaCategory.quranic,
      remarks: 'Allah commanded the Prophet ﷺ to make this dua. Knowledge is the only thing Allah told His Prophet to ask for an increase in.',
    ),
    Duaa(
      id: 51,
      duaNumber: '14.5',
      title: 'For Parents',
      arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      transliteration: 'Rabbir-hamhumā kamā rabbayānī saghīrā',
      translation: 'My Lord, have mercy upon them as they brought me up when I was small.',
      source: 'Surah Al-Isra 17:24',
      category: DuaaCategory.quranic,
      remarks: 'This tender dua for parents acknowledges their care during our childhood and asks Allah to show them the same mercy.',
    ),
    Duaa(
      id: 52,
      duaNumber: '14.6',
      title: 'For Steadfastness in Prayer',
      arabic: 'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلَاةِ وَمِنْ ذُرِّيَّتِي رَبَّنَا وَتَقَبَّلْ دُعَاءِ',
      transliteration: "Rabbij'alnī muqīmas-salāti wa min dhurriyyatī rabbanā wa taqabbal du'ā",
      translation: 'My Lord, make me steadfast in prayer, and my offspring. Our Lord, and accept my supplication.',
      source: 'Surah Ibrahim 14:40',
      category: DuaaCategory.quranic,
      remarks: 'This is from the duas of Prophet Ibrahim (Abraham), asking for himself and his descendants to be devoted to prayer.',
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
