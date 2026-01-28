import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../config/constants.dart';
import '../../config/responsive.dart';

class ExploreScreen extends StatelessWidget {
  final void Function(int screenIndex, String title)? onNavigate;

  const ExploreScreen({super.key, this.onNavigate});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigate(
    BuildContext context,
    int screenIndex,
    String title,
    String route,
  ) {
    if (onNavigate != null) {
      onNavigate!(screenIndex, title);
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = Responsive.screenPadding(context);
    final gridSpacing = Responsive.gridSpacing(context);
    final gridColumns = Responsive.gridColumns(
      context,
      compact: 2,
      medium: 3,
      expanded: 4,
    );

    // Aspect ratio tuned per breakpoint
    final aspectRatio = Responsive.value<double>(
      context,
      compact: 1.1,
      medium: 1.0,
      expanded: 1.1,
    );

    return SafeArea(
      child: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Explore',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              'Discover programs, events, and ways to get involved',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Responsive Grid of feature cards
            Expanded(
              child: GridView.count(
                crossAxisCount: gridColumns,
                mainAxisSpacing: gridSpacing,
                crossAxisSpacing: gridSpacing,
                childAspectRatio: aspectRatio,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _ExploreCard(
                    customIcon: _QuranExploreIcon(color: const Color(0xFF1B5E20)),
                    title: 'Quran',
                    subtitle: 'Read & listen',
                    color: const Color(0xFF1B5E20),
                    onTap: () => _navigate(context, 17, 'Quran', '/quran'),
                  ),
                  _ExploreCard(
                    customIcon: _DuaExploreIcon(color: const Color(0xFF9C27B0)),
                    title: 'Daily Duaa',
                    subtitle: 'Supplications',
                    color: const Color(0xFF9C27B0),
                    onTap: () => _navigate(context, 15, 'Daily Duaa', '/duaa'),
                  ),
                  _ExploreCard(
                    customIcon: _TasbihExploreIcon(color: const Color(0xFF00695C)),
                    title: 'Tasbih',
                    subtitle: 'Dhikr counter',
                    color: const Color(0xFF00695C),
                    onTap: () => _navigate(context, 18, 'Tasbih Counter', '/tasbih'),
                  ),
                  _ExploreCard(
                    icon: Icons.auto_awesome,
                    title: '99 Names',
                    subtitle: 'Names of Allah',
                    color: const Color(0xFFFFB300),
                    onTap: () => _navigate(context, 19, '99 Names of Allah', '/names-of-allah'),
                  ),
                  _ExploreCard(
                    icon: Icons.event,
                    title: 'Events',
                    subtitle: 'Upcoming programs',
                    color: const Color(0xFF4CAF50),
                    onTap: () => _navigate(context, 10, 'Events', '/events'),
                  ),
                  _ValuesCard(
                    onTap: () =>
                        _navigate(context, 11, AppConstants.ourValuesTitle, '/values'),
                  ),
                  _ExploreCard(
                    icon: Icons.people,
                    title: 'Volunteer',
                    subtitle: 'Join our team',
                    color: const Color(0xFF2196F3),
                    onTap: () =>
                        _navigate(context, 13, 'Volunteer', '/volunteer'),
                  ),
                  _ExploreCard(
                    icon: Icons.play_circle_filled,
                    title: 'Media',
                    subtitle: 'Videos & content',
                    color: const Color(0xFFFF5722),
                    onTap: () => _navigate(context, 12, 'Media', '/media'),
                  ),
                  _ExploreCard(
                    icon: Icons.calendar_month,
                    title: 'Islamic Calendar',
                    subtitle: 'Important dates',
                    color: const Color(0xFF795548),
                    onTap: () => _navigate(
                      context,
                      16,
                      'Islamic Calendar',
                      '/islamic-calendar',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Social Media Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SocialButton(
                  icon: FontAwesomeIcons.facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchUrl(AppConstants.facebookUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.instagram,
                  color: const Color(0xFFE4405F),
                  onTap: () => _launchUrl(AppConstants.instagramUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.youtube,
                  color: const Color(0xFFFF0000),
                  onTap: () => _launchUrl(AppConstants.youtubeUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.xTwitter,
                  color: const Color(0xFF000000),
                  onTap: () => _launchUrl(AppConstants.twitterUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.tiktok,
                  color: const Color(0xFF000000),
                  onTap: () => _launchUrl(AppConstants.tiktokUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.whatsapp,
                  color: const Color(0xFF25D366),
                  onTap: () => _launchUrl(AppConstants.whatsappUrl),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Support Qiam button - at bottom with gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _launchUrl(AppConstants.donateUrl),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volunteer_activism,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Support Qiam Institute',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Main explore card with enhanced styling
class _ExploreCard extends StatelessWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ExploreCard({
    this.icon,
    this.customIcon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  }) : assert(icon != null || customIcon != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: customIcon ?? Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dua icon - 8-pointed star with crescent and hands for Explore card
class _DuaExploreIcon extends StatelessWidget {
  final Color color;

  const _DuaExploreIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        size: const Size(28, 28),
        painter: _DuaExploreIconPainter(color: color),
      ),
    );
  }
}

/// Custom painter for Dua explore icon
class _DuaExploreIconPainter extends CustomPainter {
  final Color color;

  _DuaExploreIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw 8-pointed star outline
    final starPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05;

    final outerRadius = size.width * 0.45;
    final innerRadius = outerRadius * 0.55;

    final starPath = Path();
    const int points = 8;
    const double startAngle = -math.pi / 2;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = startAngle + (i * math.pi / points);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    canvas.drawPath(starPath, starPaint);

    // Draw crescent moon
    final moonPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final moonRadius = size.width * 0.08;
    final moonCenter = Offset(center.dx, center.dy - size.height * 0.12);

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawCircle(moonCenter, moonRadius, moonPaint);
    final erasePaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawCircle(
      Offset(moonCenter.dx + moonRadius * 0.4, moonCenter.dy),
      moonRadius * 0.75,
      erasePaint,
    );
    canvas.restore();

    // Draw simplified hands
    final handPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Left hand (simple oval)
    canvas.save();
    canvas.translate(
      center.dx - size.width * 0.12,
      center.dy + size.height * 0.08,
    );
    canvas.rotate(-0.3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.15,
        height: size.width * 0.22,
      ),
      handPaint,
    );
    canvas.restore();

    // Right hand (simple oval)
    canvas.save();
    canvas.translate(
      center.dx + size.width * 0.12,
      center.dy + size.height * 0.08,
    );
    canvas.rotate(0.3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.15,
        height: size.width * 0.22,
      ),
      handPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Quran icon - open book with Arabic text for Explore card
class _QuranExploreIcon extends StatelessWidget {
  final Color color;

  const _QuranExploreIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        size: const Size(28, 28),
        painter: _QuranExploreIconPainter(color: color),
      ),
    );
  }
}

/// Custom painter for Quran explore icon (open book with star)
class _QuranExploreIconPainter extends CustomPainter {
  final Color color;

  _QuranExploreIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw open book shape
    final bookPath = Path();

    // Left page
    bookPath.moveTo(size.width * 0.5, size.height * 0.2);
    bookPath.quadraticBezierTo(
      size.width * 0.25, size.height * 0.15,
      size.width * 0.1, size.height * 0.25,
    );
    bookPath.lineTo(size.width * 0.1, size.height * 0.8);
    bookPath.quadraticBezierTo(
      size.width * 0.3, size.height * 0.75,
      size.width * 0.5, size.height * 0.85,
    );

    // Right page
    bookPath.quadraticBezierTo(
      size.width * 0.7, size.height * 0.75,
      size.width * 0.9, size.height * 0.8,
    );
    bookPath.lineTo(size.width * 0.9, size.height * 0.25);
    bookPath.quadraticBezierTo(
      size.width * 0.75, size.height * 0.15,
      size.width * 0.5, size.height * 0.2,
    );

    canvas.drawPath(bookPath, paint);

    // Draw spine line
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.85),
      paint,
    );

    // Draw small star/decorative element on the book
    final starCenter = Offset(size.width * 0.5, size.height * 0.5);
    final starRadius = size.width * 0.08;

    // Simple 4-pointed star
    final starPath = Path();
    starPath.moveTo(starCenter.dx, starCenter.dy - starRadius);
    starPath.lineTo(starCenter.dx + starRadius * 0.3, starCenter.dy - starRadius * 0.3);
    starPath.lineTo(starCenter.dx + starRadius, starCenter.dy);
    starPath.lineTo(starCenter.dx + starRadius * 0.3, starCenter.dy + starRadius * 0.3);
    starPath.lineTo(starCenter.dx, starCenter.dy + starRadius);
    starPath.lineTo(starCenter.dx - starRadius * 0.3, starCenter.dy + starRadius * 0.3);
    starPath.lineTo(starCenter.dx - starRadius, starCenter.dy);
    starPath.lineTo(starCenter.dx - starRadius * 0.3, starCenter.dy - starRadius * 0.3);
    starPath.close();

    canvas.drawPath(starPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Tasbih icon - prayer beads for Explore card
class _TasbihExploreIcon extends StatelessWidget {
  final Color color;

  const _TasbihExploreIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        size: const Size(28, 28),
        painter: _TasbihExploreIconPainter(color: color),
      ),
    );
  }
}

/// Custom painter for Tasbih explore icon (prayer beads)
class _TasbihExploreIconPainter extends CustomPainter {
  final Color color;

  _TasbihExploreIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;

    final center = Offset(size.width / 2, size.height / 2);
    final beadRadius = size.width * 0.08;
    final ringRadius = size.width * 0.32;

    // Draw the string/ring
    canvas.drawCircle(center, ringRadius, strokePaint);

    // Draw beads around the circle
    const beadCount = 8;
    for (int i = 0; i < beadCount; i++) {
      final angle = (i * 2 * math.pi / beadCount) - math.pi / 2;
      final beadCenter = Offset(
        center.dx + ringRadius * math.cos(angle),
        center.dy + ringRadius * math.sin(angle),
      );
      canvas.drawCircle(beadCenter, beadRadius, paint);
    }

    // Draw the tassel/marker bead at top
    final tasselY = center.dy - ringRadius - beadRadius * 2;
    canvas.drawLine(
      Offset(center.dx, center.dy - ringRadius - beadRadius),
      Offset(center.dx, tasselY),
      strokePaint,
    );
    canvas.drawCircle(
      Offset(center.dx, tasselY - beadRadius),
      beadRadius * 1.2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Special Values card showing mini value images
class _ValuesCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ValuesCard({required this.onTap});

  static const List<String> _valueImages = [
    'assets/images/values/Tawado3.png',
    'assets/images/values/3adl.png',
    'assets/images/values/Rahma.png',
  ];

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFFE91E63);

    return Card(
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row of 3 value images - compact layout
              SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _valueImages.map((imagePath) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) =>
                              Icon(Icons.favorite, color: color, size: 14),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppConstants.ourValuesTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                'What we stand for',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Social media button
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(child: FaIcon(icon, color: color, size: 20)),
      ),
    );
  }
}
