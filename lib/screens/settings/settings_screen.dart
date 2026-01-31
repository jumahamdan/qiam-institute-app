import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/constants.dart';
import '../../widgets/settings/settings_section.dart';
import '../../widgets/settings/settings_tile.dart';
import 'adhan_settings_screen.dart';
import 'prayer_times_settings_screen.dart';

/// Redesigned Settings screen with grouped categories.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentTheme = 'System';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareApp() {
    Share.share(
      'Check out Qiam Institute app - Your companion for Islamic learning and practice!\n\n${AppConstants.websiteUrl}',
      subject: 'Qiam Institute App',
    );
  }

  void _showThemePicker() {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final themes = ['Light', 'Dark', 'System'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        return Container(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Theme',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final theme in themes)
                ListTile(
                  leading: _currentTheme == theme
                      ? Icon(Icons.check_circle, color: primaryColor)
                      : Icon(Icons.circle_outlined, color: Colors.grey[400]),
                  title: Text(
                    theme,
                    style: TextStyle(
                      fontWeight: _currentTheme == theme ? FontWeight.w600 : FontWeight.normal,
                      color: _currentTheme == theme ? primaryColor : null,
                    ),
                  ),
                  trailing: Icon(
                    theme == 'Light'
                        ? Icons.light_mode
                        : theme == 'Dark'
                            ? Icons.dark_mode
                            : Icons.brightness_auto,
                    color: Colors.grey[600],
                  ),
                  onTap: () {
                    setState(() => _currentTheme = theme);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Theme switching coming soon!')),
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return ListView(
      padding: EdgeInsets.only(top: 8, bottom: 16 + bottomSafeArea),
      children: [
        // ========== PRAYER & WORSHIP SECTION ==========
        SettingsSection(
          title: 'Prayer & Worship',
          icon: Icons.mosque,
          children: [
            SettingsTile.navigation(
              icon: Icons.access_time,
              title: 'Prayer Times',
              subtitle: 'Location, calculation method, adjustments',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrayerTimesSettingsScreen()),
              ),
            ),
            SettingsTile.navigation(
              icon: Icons.volume_up,
              title: 'Adhan & Notifications',
              subtitle: 'Adhan sounds, prayer alerts, reminders',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdhanSettingsScreen()),
              ),
            ),
          ],
        ),

        // ========== APPEARANCE SECTION ==========
        SettingsSection(
          title: 'Appearance',
          icon: Icons.palette,
          children: [
            SettingsTile.value(
              icon: Icons.brightness_6,
              title: 'Theme',
              subtitle: 'Light, dark, or follow system',
              value: _currentTheme,
              onTap: _showThemePicker,
            ),
          ],
        ),

        // ========== SUPPORT SECTION ==========
        SettingsSection(
          title: 'Support',
          icon: Icons.favorite,
          children: [
            SettingsTile.external(
              icon: Icons.feedback_outlined,
              title: 'Feedback & Suggestions',
              subtitle: 'Help us improve the app',
              onTap: () => _launchUrl(AppConstants.feedbackFormUrl),
            ),
            SettingsTile.external(
              icon: Icons.star_outline,
              title: 'Rate the App',
              subtitle: 'Share your experience on the store',
              onTap: () {
                // TODO: Implement app store link
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App Store link coming soon!')),
                );
              },
            ),
            SettingsTile.navigation(
              icon: Icons.share,
              title: 'Share with Friends',
              subtitle: 'Spread the word about Qiam',
              onTap: _shareApp,
            ),
            SettingsTile.external(
              icon: Icons.volunteer_activism,
              title: 'Donate',
              subtitle: 'Support Qiam Institute',
              onTap: () => _launchUrl(AppConstants.donateUrl),
            ),
          ],
        ),

        // ========== ABOUT SECTION ==========
        SettingsSection(
          title: 'About',
          icon: Icons.info_outline,
          children: [
            SettingsTile.external(
              icon: Icons.mosque,
              title: 'About Qiam Institute',
              subtitle: 'Learn more about our mission',
              onTap: () => _launchUrl(AppConstants.websiteUrl),
            ),
            SettingsTile.external(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => _launchUrl('${AppConstants.websiteUrl}/privacy'),
            ),
            SettingsTile.external(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () => _launchUrl('${AppConstants.websiteUrl}/terms'),
            ),
            SettingsTile(
              icon: Icons.info,
              title: 'Version',
              trailing: Text(
                AppConstants.appVersion,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
