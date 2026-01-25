/// Event model for Qiam Institute events from WordPress API
class Event {
  final int id;
  final String title;
  final String description;
  final String? excerpt;
  final DateTime startDate;
  final DateTime endDate;
  final bool allDay;
  final String? imageUrl;
  final EventVenue? venue;
  final String? url;
  final List<String> categories;
  final String? cost;
  final bool isFree;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.excerpt,
    required this.startDate,
    required this.endDate,
    this.allDay = false,
    this.imageUrl,
    this.venue,
    this.url,
    this.categories = const [],
    this.cost,
    this.isFree = true,
  });

  /// Parse from WordPress Tribe Events API response
  factory Event.fromJson(Map<String, dynamic> json) {
    // Parse dates
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) {
        return DateTime.now();
      }
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    // Parse venue
    EventVenue? parseVenue(dynamic venueData) {
      if (venueData == null) return null;
      if (venueData is Map<String, dynamic>) {
        return EventVenue.fromJson(venueData);
      }
      return null;
    }

    // Parse categories
    List<String> parseCategories(dynamic cats) {
      if (cats == null) return [];
      if (cats is List) {
        return cats
            .map((c) => c is Map ? (c['name'] ?? '').toString() : c.toString())
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return [];
    }

    // Get image URL
    String? getImageUrl(Map<String, dynamic> json) {
      // Try different image fields
      if (json['image'] != null) {
        if (json['image'] is Map && json['image']['url'] != null) {
          return json['image']['url'];
        }
        if (json['image'] is String) {
          return json['image'];
        }
      }
      return null;
    }

    // Strip HTML tags from description
    String stripHtml(String? html) {
      if (html == null || html.isEmpty) return '';
      return html
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .trim();
    }

    return Event(
      id: json['id'] ?? 0,
      title: stripHtml(json['title'] ?? ''),
      description: stripHtml(json['description'] ?? ''),
      excerpt: stripHtml(json['excerpt'] ?? json['short_description']),
      startDate: parseDate(json['start_date'] ?? json['utc_start_date']),
      endDate: parseDate(json['end_date'] ?? json['utc_end_date']),
      allDay: json['all_day'] == true,
      imageUrl: getImageUrl(json),
      venue: parseVenue(json['venue']),
      url: json['url'] ?? json['website'],
      categories: parseCategories(json['categories']),
      cost: json['cost']?.toString(),
      isFree: json['cost'] == 'Free' || json['cost'] == null || json['cost'] == '',
    );
  }

  /// Check if event is happening today
  bool get isToday {
    final now = DateTime.now();
    return startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day;
  }

  /// Check if event is upcoming (hasn't started yet)
  bool get isUpcoming => startDate.isAfter(DateTime.now());

  /// Check if event is currently happening
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Get formatted date string
  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final day = days[startDate.weekday - 1];
    final month = months[startDate.month - 1];
    return '$day, $month ${startDate.day}';
  }

  /// Get formatted time string
  String get formattedTime {
    if (allDay) return 'All Day';

    String formatHour(DateTime dt) {
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    return '${formatHour(startDate)} - ${formatHour(endDate)}';
  }
}

/// Event venue information
class EventVenue {
  final int? id;
  final String name;
  final String? address;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;

  EventVenue({
    this.id,
    required this.name,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  factory EventVenue.fromJson(Map<String, dynamic> json) {
    return EventVenue(
      id: json['id'],
      name: json['venue'] ?? json['name'] ?? 'Unknown Venue',
      address: json['address'],
      city: json['city'],
      state: json['state'] ?? json['province'],
      zip: json['zip'] ?? json['postal_code'],
      country: json['country'],
    );
  }

  /// Get formatted address string
  String get formattedAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);

    final cityState = <String>[];
    if (city != null && city!.isNotEmpty) cityState.add(city!);
    if (state != null && state!.isNotEmpty) cityState.add(state!);
    if (cityState.isNotEmpty) parts.add(cityState.join(', '));

    if (zip != null && zip!.isNotEmpty) parts.add(zip!);

    return parts.join('\n');
  }
}
