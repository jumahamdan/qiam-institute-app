import 'package:flutter/material.dart';

/// A reusable settings tile widget with consistent styling.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  /// Creates a settings tile with a chevron right arrow.
  factory SettingsTile.navigation({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      iconColor: iconColor,
    );
  }

  /// Creates a settings tile with a switch toggle.
  factory SettingsTile.toggle({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? iconColor,
  }) {
    return _SettingsTileToggle(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
      iconColor: iconColor,
    );
  }

  /// Creates a settings tile with a value display (e.g., current theme).
  factory SettingsTile.value({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    required String value,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ],
      ),
      onTap: onTap,
      iconColor: iconColor,
    );
  }

  /// Creates a settings tile with an external link icon.
  factory SettingsTile.external({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return SettingsTile(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Icon(Icons.open_in_new, size: 18, color: Colors.grey[600]),
      onTap: onTap,
      iconColor: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[600]),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// Internal toggle variant of SettingsTile.
class _SettingsTileToggle extends SettingsTile {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTileToggle({
    super.key,
    required super.icon,
    required super.title,
    super.subtitle,
    required this.value,
    required this.onChanged,
    super.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SwitchListTile(
      secondary: Icon(icon, color: iconColor ?? Colors.grey[600]),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      activeTrackColor: primaryColor.withValues(alpha: 0.5),
      activeThumbColor: primaryColor,
      onChanged: onChanged,
    );
  }
}
