import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:makeeasy/models/user_history.dart';
import 'package:makeeasy/pages/HistoryDetailPage.dart';
import 'package:makeeasy/pages/HomePage.dart';
import 'package:makeeasy/pages/ProfilePage.dart';
import 'package:makeeasy/states/history_notifier.dart';
import 'package:makeeasy/utils/firestore_fetch_status.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserHistoryNotifier>(context, listen: false).fetchUserHistory();
    });
  }

  bool showSortOverlay = false;
  bool sortByNewest = true;
  bool isAToZ = true;

  Widget buildHistoryListItem(BuildContext context, UserHistory entry) {
    final String truncated = entry.description.length > 25
        ? '${entry.description.substring(0, 25)}... show more'
        : entry.description;

    return InkWell(
      splashColor: Theme.of(context).colorScheme.primary.withAlpha(50),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HistoryDetailPage(
            historyDate: entry.date.toString(),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                CircleAvatar(
                 radius: 28,
                backgroundColor: Colors.grey.shade200,
                // backgroundImage: (entry.imagePath.startsWith('http'))
                // ? NetworkImage(entry.imagePath)
                // : AssetImage('assets/images/profile.jpg') as ImageProvider,
                backgroundImage: (entry.imagePath != null && entry.imagePath.startsWith('http'))
                  ? NetworkImage(entry.imagePath)
                  : AssetImage('assets/images/profile.jpg') as ImageProvider, //tania modify

                onBackgroundImageError: (_, __) {}, // optional: suppress error crash
              ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(truncated, style: const TextStyle(fontSize: 14)),
                      Text(
                        'saved on ${entry.date}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.secondary.withAlpha(50),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserHistoryNotifier>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0, // Prevent appbar
            title: Text(
              "History",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  // setState(() {
                  //   showSortOverlay = !showSortOverlay;
                  // });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(),
                    ),
                  );
                },
                icon: Icon(Icons.swap_vert),
              ),
            ],

          ),
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: value.userHistory == null || value.userHistory!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                Text(
                                  "Your make-up history will be listed here!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : AnimationLimiter(
                            child: ListView.builder(
                              itemCount: value.userHistory!.length,
                              itemBuilder: (context, index) {
                                final entry = value.userHistory![index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 250),
                                  child: SlideAnimation(
                                    verticalOffset: 0.0,
                                    horizontalOffset: 50.0,
                                    child: Dismissible(
                                      key: Key(entry.title + entry.date.toString()),
                                      direction: DismissDirection.horizontal,
                                      background: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 20),
                                        color: Colors.pink.shade50,
                                        child: const Icon(Icons.delete, color: Colors.pink),
                                      ),
                                      secondaryBackground: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 20),
                                        color: Colors.pink.shade50,
                                        child: const Icon(Icons.delete, color: Colors.pink),
                                      ),
                                      onDismissed: (_) async {
                                         await value.removeHistoryItem(entry);
                                        },

                                      child: buildHistoryListItem(context, entry),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
              if (showSortOverlay)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
  onPressed: () {
    value.sortByDate(newestFirst: sortByNewest);
  },
  child: Text(
    sortByNewest ? 'Oldest' : 'Newest',
    style: const TextStyle(color: Colors.pink),
  ),
),
TextButton(
  onPressed: () {
    value.sortByTitle(aToZ: isAToZ);
  },
  child: Text(
    isAToZ ? 'Z-A' : 'A-Z',
    style: const TextStyle(color: Colors.pink),
  ),
),

                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
