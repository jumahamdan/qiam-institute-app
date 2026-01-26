import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/prayer/prayer_service.dart';

class YearlyPrayerTimesScreen extends StatefulWidget {
  const YearlyPrayerTimesScreen({super.key});

  @override
  State<YearlyPrayerTimesScreen> createState() => _YearlyPrayerTimesScreenState();
}

class _YearlyPrayerTimesScreenState extends State<YearlyPrayerTimesScreen> {
  final PrayerService _prayerService = PrayerService();
  late int _selectedYear;
  late int _selectedMonth;
  bool _isLoading = true;
  List<DailyPrayerTimes> _monthPrayerTimes = [];

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() => _isLoading = true);

    final times = await _prayerService.getMonthPrayerTimes(_selectedYear, _selectedMonth);

    setState(() {
      _monthPrayerTimes = times;
      _isLoading = false;
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth += delta;
      if (_selectedMonth > 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else if (_selectedMonth < 1) {
        _selectedMonth = 12;
        _selectedYear--;
      }
    });
    _loadPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times Calendar'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Month/Year selector
          _buildMonthSelector(),

          // Prayer times table header
          _buildTableHeader(),

          // Prayer times list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildPrayerTimesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _changeMonth(-1),
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          GestureDetector(
            onTap: _showMonthYearPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    '${_months[_selectedMonth - 1]} $_selectedYear',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => _changeMonth(1),
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonthYearPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 350,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Month & Year',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            // Year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() => _selectedYear--);
                    Navigator.pop(context);
                    _loadPrayerTimes();
                  },
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_selectedYear',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _selectedYear++);
                    Navigator.pop(context);
                    _loadPrayerTimes();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Month grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final isSelected = index + 1 == _selectedMonth;
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedMonth = index + 1);
                      Navigator.pop(context);
                      _loadPrayerTimes();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _months[index].substring(0, 3),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 50,
            child: Text(
              'Date',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          _buildHeaderCell('Fajr'),
          _buildHeaderCell('Sunrise'),
          _buildHeaderCell('Dhuhr'),
          _buildHeaderCell('Asr'),
          _buildHeaderCell('Maghrib'),
          _buildHeaderCell('Isha'),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    final today = DateTime.now();

    return ListView.builder(
      itemCount: _monthPrayerTimes.length,
      itemBuilder: (context, index) {
        final dayTimes = _monthPrayerTimes[index];
        final isToday = dayTimes.date.year == today.year &&
            dayTimes.date.month == today.month &&
            dayTimes.date.day == today.day;
        final isWeekend = dayTimes.date.weekday == DateTime.saturday ||
            dayTimes.date.weekday == DateTime.sunday;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isToday
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                : isWeekend
                    ? Colors.grey[50]
                    : Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayTimes.date.day.toString(),
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                        fontSize: 14,
                        color: isToday
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[800],
                      ),
                    ),
                    Text(
                      DateFormat('EEE').format(dayTimes.date),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              _buildTimeCell(dayTimes.fajr),
              _buildTimeCell(dayTimes.sunrise),
              _buildTimeCell(dayTimes.dhuhr),
              _buildTimeCell(dayTimes.asr),
              _buildTimeCell(dayTimes.maghrib),
              _buildTimeCell(dayTimes.isha),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeCell(DateTime time) {
    return Expanded(
      child: Text(
        DateFormat('h:mm').format(time),
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
