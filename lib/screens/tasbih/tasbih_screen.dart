import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/tasbih/tasbih_service.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  final TasbihService _tasbihService = TasbihService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Dhikr _currentDhikr = TasbihService.dhikrList.first;
  TasbihProgress? _progress;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final lastDhikrId = await _tasbihService.getLastDhikr();
    if (lastDhikrId != null) {
      _currentDhikr = _tasbihService.getDhikr(lastDhikrId);
    }
    final progress = await _tasbihService.getProgress(_currentDhikr.id);
    if (mounted) {
      setState(() {
        _progress = progress;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDhikr(Dhikr dhikr) async {
    await _tasbihService.saveLastDhikr(dhikr.id);
    final progress = await _tasbihService.getProgress(dhikr.id);
    if (mounted) {
      setState(() {
        _currentDhikr = dhikr;
        _progress = progress;
      });
    }
  }

  Future<void> _incrementCount() async {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Animation
    await _animationController.forward();
    await _animationController.reverse();

    final progress = await _tasbihService.increment(_currentDhikr.id);
    if (mounted) {
      setState(() => _progress = progress);

      // Check if target reached
      if (progress.count == progress.target) {
        _showTargetReachedDialog();
      }
    }
  }

  Future<void> _resetCount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Counter?'),
        content:
            const Text('This will reset the current count to 0. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final progress = await _tasbihService.resetCount(_currentDhikr.id);
      if (mounted) {
        setState(() => _progress = progress);
      }
    }
  }

  void _showTargetReachedDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.celebration,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Target Reached!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You completed ${_progress!.target} ${_currentDhikr.transliteration}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'May Allah accept your dhikr.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetCount();
            },
            child: const Text('Reset & Continue'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Going'),
          ),
        ],
      ),
    );
  }

  void _showDhikrSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Dhikr',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: bottomPadding + 16),
                  itemCount: TasbihService.dhikrList.length,
                  itemBuilder: (context, index) {
                    final dhikr = TasbihService.dhikrList[index];
                    final isSelected = dhikr.id == _currentDhikr.id;
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${dhikr.defaultTarget}',
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        dhikr.arabic,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: Text(
                        '${dhikr.transliteration} - ${dhikr.translation}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        _selectDhikr(dhikr);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTargetSelector() {
    final targets = [33, 66, 99, 100, 200, 500, 1000];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Container(
          padding: EdgeInsets.only(top: 20, bottom: bottomPadding + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Set Target',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: targets.map((target) {
                  final isSelected = target == _progress?.target;
                  return ChoiceChip(
                    label: Text('$target'),
                    selected: isSelected,
                    onSelected: (_) async {
                      Navigator.pop(context);
                      final progress = await _tasbihService.setTarget(
                          _currentDhikr.id, target);
                      if (mounted) {
                        setState(() => _progress = progress);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showVirtue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentDhikr.transliteration),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentDhikr.arabic,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _currentDhikr.translation,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Divider(height: 24),
              const Text(
                'Virtue:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_currentDhikr.virtue),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final progress = _progress!;
    final progressPercent =
        progress.target > 0 ? progress.count / progress.target : 0.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Dhikr selector button
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: _showDhikrSelector,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _currentDhikr.arabic,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_currentDhikr.transliteration} - ${_currentDhikr.translation}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.keyboard_arrow_down, color: primaryColor),
                    ],
                  ),
                ),
              ),
            ),

            // Main counter area
            Expanded(
              child: GestureDetector(
                onTap: _incrementCount,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Progress ring
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CustomPaint(
                            painter: _ProgressRingPainter(
                              progress: progressPercent.clamp(0.0, 1.0),
                              color: primaryColor,
                              backgroundColor:
                                  primaryColor.withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                        // Count display
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${progress.count}',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: _showTargetSelector,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'of ${progress.target}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Tap hint
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Tap anywhere to count',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ControlButton(
                    icon: Icons.info_outline,
                    label: 'Virtue',
                    onTap: _showVirtue,
                  ),
                  _ControlButton(
                    icon: Icons.refresh,
                    label: 'Reset',
                    onTap: _resetCount,
                  ),
                  _ControlButton(
                    icon: Icons.flag_outlined,
                    label: 'Target',
                    onTap: _showTargetSelector,
                  ),
                ],
              ),
            ),

            // Lifetime count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
              ),
              child: Column(
                children: [
                  Text(
                    'Total: ${progress.totalCount}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Lifetime count for ${_currentDhikr.transliteration}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the progress ring
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 12.0;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
