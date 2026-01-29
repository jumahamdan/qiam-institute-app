import 'package:flutter/material.dart';

class Hadith {
  final int id;
  final String hadithNumber; // e.g., "1", "2", for Nawawi: "1", for Bukhari: "1234"
  final String narrator; // e.g., "Abu Hurairah (RA)"
  final String arabic;
  final String transliteration;
  final String translation;
  final String source; // e.g., "Sahih Al-Bukhari 6018"
  final String collection; // nawawi, bukhari, muslim
  final String grade; // sahih, hasan, daif
  final String? topic; // character, prayer, fasting, etc.
  final String? remarks; // Additional context or explanation

  const Hadith({
    required this.id,
    required this.hadithNumber,
    required this.narrator,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.source,
    required this.collection,
    required this.grade,
    this.topic,
    this.remarks,
  });

  Hadith copyWith({
    int? id,
    String? hadithNumber,
    String? narrator,
    String? arabic,
    String? transliteration,
    String? translation,
    String? source,
    String? collection,
    String? grade,
    String? topic,
    String? remarks,
  }) {
    return Hadith(
      id: id ?? this.id,
      hadithNumber: hadithNumber ?? this.hadithNumber,
      narrator: narrator ?? this.narrator,
      arabic: arabic ?? this.arabic,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      source: source ?? this.source,
      collection: collection ?? this.collection,
      grade: grade ?? this.grade,
      topic: topic ?? this.topic,
      remarks: remarks ?? this.remarks,
    );
  }

  /// Get formatted hadith number display
  String get formattedNumber => 'Hadith #$hadithNumber';
}

class HadithCollection {
  static const String nawawi = 'nawawi';
  static const String bukhari = 'bukhari';
  static const String muslim = 'muslim';
  static const String tirmidhi = 'tirmidhi';
  static const String abuDawud = 'abu_dawud';
  static const String nasai = 'nasai';
  static const String ibnMajah = 'ibn_majah';

  static String getDisplayName(String collection) {
    switch (collection) {
      case nawawi:
        return '40 Nawawi';
      case bukhari:
        return 'Sahih Bukhari';
      case muslim:
        return 'Sahih Muslim';
      case tirmidhi:
        return 'Jami at-Tirmidhi';
      case abuDawud:
        return 'Sunan Abu Dawud';
      case nasai:
        return 'Sunan an-Nasai';
      case ibnMajah:
        return 'Sunan Ibn Majah';
      default:
        return collection;
    }
  }

  static String getArabicName(String collection) {
    switch (collection) {
      case nawawi:
        return 'الأربعون النووية';
      case bukhari:
        return 'صحيح البخاري';
      case muslim:
        return 'صحيح مسلم';
      case tirmidhi:
        return 'جامع الترمذي';
      case abuDawud:
        return 'سنن أبي داود';
      case nasai:
        return 'سنن النسائي';
      case ibnMajah:
        return 'سنن ابن ماجه';
      default:
        return collection;
    }
  }

  static String getIcon(String collection) {
    switch (collection) {
      case nawawi:
        return '📜';
      case bukhari:
        return '📗';
      case muslim:
        return '📕';
      case tirmidhi:
        return '📘';
      case abuDawud:
        return '📙';
      case nasai:
        return '📓';
      case ibnMajah:
        return '📔';
      default:
        return '📖';
    }
  }

  static List<String> get all => [
        nawawi,
        bukhari,
        muslim,
      ];
}

class HadithGrade {
  static const String sahih = 'sahih';
  static const String hasan = 'hasan';
  static const String daif = 'daif';
  static const String unknown = 'unknown';

  static String getDisplayName(String grade) {
    switch (grade) {
      case sahih:
        return 'Sahih (Authentic)';
      case hasan:
        return 'Hasan (Good)';
      case daif:
        return 'Da\'if (Weak)';
      case unknown:
        return 'Grade Unknown';
      default:
        return grade;
    }
  }

  static String getShortName(String grade) {
    switch (grade) {
      case sahih:
        return 'Sahih';
      case hasan:
        return 'Hasan';
      case daif:
        return 'Da\'if';
      case unknown:
        return 'Unknown';
      default:
        return grade;
    }
  }

  static Color getColor(String grade) {
    switch (grade) {
      case sahih:
        return Colors.green;
      case hasan:
        return Colors.teal;
      case daif:
        return Colors.orange;
      case unknown:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  static List<String> get all => [
        sahih,
        hasan,
        daif,
      ];
}

class HadithTopic {
  static const String intentions = 'intentions';
  static const String faith = 'faith';
  static const String pillars = 'pillars';
  static const String prayer = 'prayer';
  static const String fasting = 'fasting';
  static const String charity = 'charity';
  static const String hajj = 'hajj';
  static const String character = 'character';
  static const String family = 'family';
  static const String knowledge = 'knowledge';
  static const String repentance = 'repentance';
  static const String duaa = 'duaa';
  static const String hereafter = 'hereafter';
  static const String manners = 'manners';
  static const String brotherhood = 'brotherhood';
  static const String halal = 'halal';
  static const String heart = 'heart';

  static String getDisplayName(String topic) {
    switch (topic) {
      case intentions:
        return 'Intentions';
      case faith:
        return 'Faith (Iman)';
      case pillars:
        return 'Pillars of Islam';
      case prayer:
        return 'Prayer (Salah)';
      case fasting:
        return 'Fasting (Sawm)';
      case charity:
        return 'Charity (Zakat/Sadaqah)';
      case hajj:
        return 'Hajj & Umrah';
      case character:
        return 'Character';
      case family:
        return 'Family';
      case knowledge:
        return 'Knowledge';
      case repentance:
        return 'Repentance (Tawbah)';
      case duaa:
        return 'Dua & Remembrance';
      case hereafter:
        return 'Hereafter (Akhirah)';
      case manners:
        return 'Manners (Adab)';
      case brotherhood:
        return 'Brotherhood';
      case halal:
        return 'Halal & Haram';
      case heart:
        return 'Purification of Heart';
      default:
        return topic;
    }
  }

  static String getIcon(String topic) {
    switch (topic) {
      case intentions:
        return '💭';
      case faith:
        return '💎';
      case pillars:
        return '🕋';
      case prayer:
        return '🤲';
      case fasting:
        return '🌙';
      case charity:
        return '💝';
      case hajj:
        return '🕌';
      case character:
        return '⭐';
      case family:
        return '👨‍👩‍👧‍👦';
      case knowledge:
        return '📚';
      case repentance:
        return '🙏';
      case duaa:
        return '🤲';
      case hereafter:
        return '🌅';
      case manners:
        return '🌟';
      case brotherhood:
        return '🤝';
      case halal:
        return '✅';
      case heart:
        return '❤️';
      default:
        return '📿';
    }
  }

  static List<String> get all => [
        intentions,
        faith,
        pillars,
        prayer,
        fasting,
        charity,
        hajj,
        character,
        family,
        knowledge,
        repentance,
        duaa,
        hereafter,
        manners,
        brotherhood,
        halal,
        heart,
      ];
}
