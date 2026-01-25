import 'package:flutter/material.dart';

class ValuesScreen extends StatelessWidget {
  const ValuesScreen({super.key});

  static const List<Map<String, String>> _coreValues = [
    {
      'name': 'Humility',
      'description': 'Recognizing one\'s smallness before Allah, avoiding pride always.',
      'icon': 'self_improvement',
    },
    {
      'name': 'Justice',
      'description': 'Upholding fairness, equity, and truth in all dealings—personal and societal.',
      'icon': 'balance',
    },
    {
      'name': 'Forbearance',
      'description': 'Restraining anger with calm wisdom.',
      'icon': 'spa',
    },
    {
      'name': 'Faithfulness',
      'description': 'Keeping promises and commitments to Allah and others.',
      'icon': 'handshake',
    },
    {
      'name': 'Forgiveness',
      'description': 'Pardoning others\' wrongs, seeking Allah\'s mercy and reward.',
      'icon': 'healing',
    },
    {
      'name': 'Gratitude',
      'description': 'Recognizing and appreciating the blessings of Allah, big and small.',
      'icon': 'favorite',
    },
    {
      'name': 'Cooperation',
      'description': 'Working together in goodness, supporting others for collective benefit.',
      'icon': 'groups',
    },
    {
      'name': 'Honesty',
      'description': 'Speaking truth, avoiding deception in all matters always.',
      'icon': 'verified',
    },
    {
      'name': 'Patience',
      'description': 'Enduring hardships with faith, trusting Allah\'s perfect timing.',
      'icon': 'hourglass_empty',
    },
    {
      'name': 'Compassion',
      'description': 'Emulating the mercy of Allah in our interactions with all of creation.',
      'icon': 'volunteer_activism',
    },
    {
      'name': 'Integrity',
      'description': 'Adhering to truth and righteousness in every situation.',
      'icon': 'shield',
    },
    {
      'name': 'Warmth',
      'description': 'Showing genuine care, kindness, and compassion toward all people.',
      'icon': 'wb_sunny',
    },
    {
      'name': 'Love',
      'description': 'Deep care and affection for others.',
      'icon': 'favorite_border',
    },
    {
      'name': 'Trustworthiness',
      'description': 'Honoring responsibilities and being worthy of trust in relationships, roles, and duties.',
      'icon': 'security',
    },
    {
      'name': 'Generosity',
      'description': 'Willingness to give and share freely.',
      'icon': 'card_giftcard',
    },
    {
      'name': 'Sympathy',
      'description': 'Feeling and showing care for others\' pain.',
      'icon': 'sentiment_satisfied',
    },
    {
      'name': 'Sincerity',
      'description': 'Being honest and genuine in actions.',
      'icon': 'loyalty',
    },
    {
      'name': 'Modesty',
      'description': 'Humility and decency in behavior and appearance.',
      'icon': 'person',
    },
    {
      'name': 'Benevolence',
      'description': 'Kindness and willingness to help others.',
      'icon': 'emoji_people',
    },
    {
      'name': 'Dignity',
      'description': 'Respecting yourself and others with good manners.',
      'icon': 'stars',
    },
  ];

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'self_improvement':
        return Icons.self_improvement;
      case 'balance':
        return Icons.balance;
      case 'spa':
        return Icons.spa;
      case 'handshake':
        return Icons.handshake;
      case 'healing':
        return Icons.healing;
      case 'favorite':
        return Icons.favorite;
      case 'groups':
        return Icons.groups;
      case 'verified':
        return Icons.verified;
      case 'hourglass_empty':
        return Icons.hourglass_empty;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      case 'shield':
        return Icons.shield;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'security':
        return Icons.security;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'sentiment_satisfied':
        return Icons.sentiment_satisfied;
      case 'loyalty':
        return Icons.loyalty;
      case 'person':
        return Icons.person;
      case 'emoji_people':
        return Icons.emoji_people;
      case 'stars':
        return Icons.stars;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Values'),
      ),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Divine & Islamic Core Values',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The principles that guide our community and spiritual growth',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          // Values Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final value = _coreValues[index];
                  return _ValueCard(
                    name: value['name']!,
                    description: value['description']!,
                    icon: _getIcon(value['icon']!),
                  );
                },
                childCount: _coreValues.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;

  const _ValueCard({
    required this.name,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text(name)),
                ],
              ),
              content: Text(
                description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
