import 'package:flutter/material.dart';
import 'package:makeeasy/utils/appStyle.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final List<String> dailyImages = [
    'assets/images/daily1.png',
    'assets/images/daily1.png',
    'assets/images/daily1.png',
    'assets/images/daily1.png',
  ];
  final List<String> partyImages = [
    'assets/images/daily1.png',
    'assets/images/daily1.png',
    'assets/images/daily1.png',
  ];

  final Set<String> _likedIds = {};

  void _toggleLike(String id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryPink = Theme.of(context).colorScheme.primary;
    final accentPink = Theme.of(context).colorScheme.secondary;

    Widget buildSection(String title, List<String> images) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentPink,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: accentPink, thickness: 2),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final id = '$title-$i';
                  final isLiked = _likedIds.contains(id);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          images[i],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => _toggleLike(id),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.favorite,
                                size: 16,
                                color: isLiked ? primaryPink : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: appGradients['primary']!),
      width: MediaQuery.sizeOf(context).width,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'FAVOURITE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryPink,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    buildSection('Daily', dailyImages),
                    buildSection('Party', partyImages),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}