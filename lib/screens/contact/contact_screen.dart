import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../config/constants.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with logo
            Image.asset(
              'assets/images/logo.png',
              height: 56,
              errorBuilder: (_, _, _) => Icon(
                Icons.mosque,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Get in Touch',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Reach out to us through any of the following methods',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Contact Cards - Compact
            _ContactCard(
              icon: Icons.phone,
              title: 'Phone',
              subtitle: AppConstants.contactPhone,
              onTap: () => _launchUrl('tel:${AppConstants.contactPhone}'),
            ),
            const SizedBox(height: 8),
            _ContactCard(
              icon: Icons.email,
              title: 'Email',
              subtitle: AppConstants.contactEmail,
              onTap: () => _launchUrl('mailto:${AppConstants.contactEmail}'),
            ),
            const SizedBox(height: 8),
            _ContactCard(
              icon: Icons.location_on,
              title: 'Address',
              subtitle: AppConstants.address,
              onTap: () => _launchUrl(AppConstants.directionsUrl),
            ),
            const SizedBox(height: 20),

            // Social Media Section
            Text(
              'Connect With Us',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SocialButton(
                  icon: FontAwesomeIcons.facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchUrl(AppConstants.facebookUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.xTwitter,
                  color: const Color(0xFF000000),
                  onTap: () => _launchUrl(AppConstants.twitterUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.youtube,
                  color: const Color(0xFFFF0000),
                  onTap: () => _launchUrl(AppConstants.youtubeUrl),
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.instagram,
                  color: const Color(0xFFE4405F),
                  onTap: () => _launchUrl(AppConstants.instagramUrl),
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

            const Spacer(),

            // Bottom buttons
            ElevatedButton.icon(
              onPressed: () => _launchUrl(AppConstants.directionsUrl),
              icon: const Icon(Icons.directions, size: 20),
              label: const Text('Get Directions'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _launchUrl(AppConstants.donateUrl),
              icon: const Icon(Icons.volunteer_activism, size: 20),
              label: const Text('Support Qiam Institute'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(icon, color: color, size: 18),
        ),
      ),
    );
  }
}
