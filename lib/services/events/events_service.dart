import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/event.dart';

/// Service to fetch events from Qiam Institute WordPress API
class EventsService {
  static const String _baseUrl = 'https://qiaminstitute.org/wp-json/tribe/events/v1';

  /// Fetch upcoming events
  /// [perPage] - Number of events to fetch (default 10)
  /// [page] - Page number for pagination (default 1)
  Future<EventsResponse> getUpcomingEvents({int perPage = 10, int page = 1}) async {
    try {
      // Use wide date range to capture all events (past year to next year)
      // This ensures we don't miss events due to timezone or date mismatches
      final now = DateTime.now();
      final startDate = '${now.year - 1}-01-01';
      final endDate = '${now.year + 1}-12-31';

      final uri = Uri.parse('$_baseUrl/events').replace(
        queryParameters: {
          'per_page': perPage.toString(),
          'page': page.toString(),
          'start_date': startDate,
          'end_date': endDate,
          'order': 'desc',
        },
      );

      // Debug: print the URL being called
      print('EventsService: Fetching from ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      // Debug: print response info
      print('EventsService: Response status ${response.statusCode}, body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return EventsResponse.fromJson(data);
      } else {
        throw EventsException(
          'Failed to load events: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is EventsException) rethrow;
      throw EventsException('Network error: $e');
    }
  }

  /// Fetch a single event by ID
  Future<Event?> getEventById(int eventId) async {
    try {
      final uri = Uri.parse('$_baseUrl/events/$eventId');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Event.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw EventsException(
          'Failed to load event: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is EventsException) rethrow;
      throw EventsException('Network error: $e');
    }
  }

  /// Fetch events by category
  Future<EventsResponse> getEventsByCategory(String category, {int perPage = 10}) async {
    try {
      // Use wide date range to capture all events
      final now = DateTime.now();
      final startDate = '${now.year - 1}-01-01';
      final endDate = '${now.year + 1}-12-31';

      final uri = Uri.parse('$_baseUrl/events').replace(
        queryParameters: {
          'per_page': perPage.toString(),
          'categories': category,
          'start_date': startDate,
          'end_date': endDate,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return EventsResponse.fromJson(data);
      } else {
        throw EventsException(
          'Failed to load events: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is EventsException) rethrow;
      throw EventsException('Network error: $e');
    }
  }
}

/// Response wrapper for events API
class EventsResponse {
  final List<Event> events;
  final int totalEvents;
  final int totalPages;
  final int currentPage;

  EventsResponse({
    required this.events,
    required this.totalEvents,
    required this.totalPages,
    this.currentPage = 1,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    final eventsList = <Event>[];

    if (json['events'] != null && json['events'] is List) {
      for (final eventJson in json['events']) {
        try {
          eventsList.add(Event.fromJson(eventJson));
        } catch (e) {
          // Skip invalid events
        }
      }
    }

    // Sort by soonest first (ascending date order)
    eventsList.sort((a, b) => a.startDate.compareTo(b.startDate));

    return EventsResponse(
      events: eventsList,
      totalEvents: json['total'] ?? eventsList.length,
      totalPages: json['total_pages'] ?? 1,
    );
  }

  /// Fetch all events (including past) for a full calendar view
  factory EventsResponse.allFromJson(Map<String, dynamic> json) {
    final eventsList = <Event>[];

    if (json['events'] != null && json['events'] is List) {
      for (final eventJson in json['events']) {
        try {
          eventsList.add(Event.fromJson(eventJson));
        } catch (e) {
          // Skip invalid events
        }
      }
    }

    // Sort by date (newest first for all events view)
    eventsList.sort((a, b) => b.startDate.compareTo(a.startDate));

    return EventsResponse(
      events: eventsList,
      totalEvents: json['total'] ?? eventsList.length,
      totalPages: json['total_pages'] ?? 1,
    );
  }

  bool get isEmpty => events.isEmpty;
  bool get isNotEmpty => events.isNotEmpty;
  bool get hasMore => currentPage < totalPages;
}

/// Custom exception for events API errors
class EventsException implements Exception {
  final String message;
  final int? statusCode;

  EventsException(this.message, {this.statusCode});

  @override
  String toString() => 'EventsException: $message';
}
