import 'package:flutter/material.dart';

class ValuesScreen extends StatelessWidget {
  const ValuesScreen({super.key});

  static const String _baseImageUrl = 'https://qiaminstitute.org/wp-content/uploads/2025/07/';

  static const List<Map<String, String>> _coreValues = [
    {
      'name': 'Humility',
      'arabic': 'تواضع',
      'description': 'Recognizing one\'s smallness before Allah, avoiding pride always.',
      'image': 'Tawado3.png',
    },
    {
      'name': 'Justice',
      'arabic': 'عدل',
      'description': 'Upholding fairness, equity, and truth in all dealings—personal and societal.',
      'image': '3adl.png',
    },
    {
      'name': 'Forbearance',
      'arabic': 'حلم',
      'description': 'Restraining anger with calm wisdom.',
      'image': '7elm.png',
    },
    {
      'name': 'Faithfulness',
      'arabic': 'وفاء',
      'description': 'Keeping promises and commitments to Allah and others.',
      'image': 'Wafaa.png',
    },
    {
      'name': 'Forgiveness',
      'arabic': 'تسامح',
      'description': 'Pardoning others\' wrongs, seeking Allah\'s mercy and reward.',
      'image': 'Tasamo7.png',
    },
    {
      'name': 'Gratitude',
      'arabic': 'شكر',
      'description': 'Recognizing and appreciating the blessings of Allah, big and small.',
      'image': 'Shokr.png',
    },
    {
      'name': 'Cooperation',
      'arabic': 'تعاون',
      'description': 'Working together in goodness, supporting others for collective benefit.',
      'image': 'Ta3awn.png',
    },
    {
      'name': 'Honesty',
      'arabic': 'صدق',
      'description': 'Speaking truth, avoiding deception in all matters always.',
      'image': 'Sedq.png',
    },
    {
      'name': 'Patience',
      'arabic': 'صبر',
      'description': 'Enduring hardships with faith, trusting Allah\'s perfect timing.',
      'image': 'Sabr.png',
    },
    {
      'name': 'Compassion',
      'arabic': 'رحمة',
      'description': 'Emulating the mercy of Allah in our interactions with all of creation.',
      'image': 'Rahma.png',
    },
    {
      'name': 'Integrity',
      'arabic': 'نزاهة',
      'description': 'Adhering to truth and righteousness in every situation.',
      'image': 'Nazaha.png',
    },
    {
      'name': 'Warmth',
      'arabic': 'مودة',
      'description': 'Showing genuine care, kindness, and compassion toward all people.',
      'image': 'Mawada.png',
    },
    {
      'name': 'Love',
      'arabic': 'محبة',
      'description': 'Deep care and affection for others.',
      'image': 'Ma7aba.png',
    },
    {
      'name': 'Trustworthiness',
      'arabic': 'أمانة',
      'description': 'Honoring responsibilities and being worthy of trust in relationships, roles, and duties.',
      'image': 'Amana.png',
    },
    {
      'name': 'Generosity',
      'arabic': 'كرم',
      'description': 'Willingness to give and share freely.',
      'image': 'Karam.png',
    },
    {
      'name': 'Sympathy',
      'arabic': 'عطف',
      'description': 'Feeling and showing care for others\' pain.',
      'image': '3atf.png',
    },
    {
      'name': 'Sincerity',
      'arabic': 'إخلاص',
      'description': 'Being honest and genuine in actions.',
      'image': 'Ikhlas.png',
    },
    {
      'name': 'Modesty',
      'arabic': 'حياء',
      'description': 'Humility and decency in behavior and appearance.',
      'image': '7ayaa.png',
    },
    {
      'name': 'Benevolence',
      'arabic': 'إحسان',
      'description': 'Kindness and willingness to help others.',
      'image': 'E7san.png',
    },
    {
      'name': 'Dignity',
      'arabic': 'عفة',
      'description': 'Respecting yourself and others with good manners.',
      'image': '3efah.png',
    },
  ];

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
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final value = _coreValues[index];
                  return _ValueCard(
                    name: value['name']!,
                    arabic: value['arabic']!,
                    description: value['description']!,
                    imageUrl: '$_baseImageUrl${value['image']}',
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
  final String arabic;
  final String description;
  final String imageUrl;

  const _ValueCard({
    required this.name,
    required this.arabic,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Column(
                children: [
                  Image.network(
                    imageUrl,
                    height: 80,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.star,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(name),
                  Text(
                    arabic,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
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
              Image.network(
                imageUrl,
                height: 60,
                errorBuilder: (_, __, ___) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              Text(
                arabic,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
