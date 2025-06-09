import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:makeeasy/utils/makeup_data.dart';
import 'package:tuple/tuple.dart';
import 'package:makeeasy/states/favorites_notifier.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  Widget buildSection(
    BuildContext context,
    String title,
    List<String> images,
    Set<String> likedIds,
    void Function(String) onToggle,
  ) {
    final accentPink = Theme.of(context).colorScheme.secondary;

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
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    images[i],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => FavoriteFiltersNotifier(user.uid),
      child: Consumer<FavoriteFiltersNotifier>(
        builder: (context, notifier, _) {
          if (notifier.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final likedIds = <String>{};

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
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          for (var fav in notifier.getFavoriteFilters)
                            if (fav.item2 == 1)
                              buildSection(
                                context,
                                'Party',
                                ['assets/images/party.png'],
                                likedIds,
                                (_) {},
                              )
                            else if (fav.item2 == 0)
                              buildSection(
                                context,
                                'Daily',
                                ['assets/images/daily.png'],
                                likedIds,
                                (_) {},
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
