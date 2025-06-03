import 'package:flutter/material.dart';
import 'package:makeeasy/models/user_history.dart';
import 'package:makeeasy/pages/HistoryDetailPage.dart';
import 'package:makeeasy/pages/HomePage.dart';
import 'package:makeeasy/states/history_notifier.dart';
import 'package:makeeasy/utils/firestore_fetch_status.dart';
import 'package:provider/provider.dart';
// class HistoryPage extends StatelessWidget {
//   const HistoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text("HistoryPage"));
//   }
// }
// import your HomePage

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // List<Map<String, String>> historyData = [
  //   {
  //     "title": "Goof",
  //     "date": "4/10 09:18", // month/day hh:mm
  //     "description":
  //         "I love how silly and carefree the moment felt. It reminded me of simpler times.",
  //   },
  //   {
  //     "title": "Themepark",
  //     "date": "4/15 09:18",
  //     "description":
  //         "I love how vibrant and fun the colors were, and the excitement was unforgettable.",
  //   },
  // ];
  // List<Map<String, String>> historyData = List.generate(10, (index) {
  //   return {
  //     "title": "Entry ${index + 1}",
  //     "date": "4/${10 + index} 09:18", // 4/10 to 4/19
  //     "description":
  //         "This is a description for Entry ${index + 1}. It might contain some longer content to preview.",
  //   };
  // });

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserHistoryNotifier>(
        context,
        listen: false,
      ).fetchUserHistory();
    });
  }

  DateTime parseCustomDate(String dateStr) {
    // Assumes format "M/d HH:mm"
    final parts = dateStr.split(' ');
    final dateParts = parts[0].split('/');
    final timeParts = parts[1].split(':');

    final now = DateTime.now(); // use current year
    return DateTime(
      now.year,
      int.parse(dateParts[0]), // month
      int.parse(dateParts[1]), // day
      int.parse(timeParts[0]), // hour
      int.parse(timeParts[1]), // minute
    );
  }

  bool showSortOverlay = false;
  bool sortByNewest = true;
  bool isAToZ = true;

  Widget buildHistoryListItem(
    BuildContext context,
    String title,
    String date,
    String description,
  ) {
    final String truncated =
        description.length > 25
            ? '${description.substring(0, 25)}... show more'
            : description;

    return InkWell(
      splashColor: Theme.of(context).colorScheme.primary.withAlpha(50),
      hoverColor: Theme.of(context).colorScheme.primary.withAlpha(50),
      highlightColor: Theme.of(context).colorScheme.primary.withAlpha(50),
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => HistoryDetailPage(
                    title: title,
                    date: date,
                    description: description,
                    imagePath: "assets/images/dummylook1.jpg",
                  ),
            ),
          ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 28,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(truncated, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        'saved on $date',
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
                  setState(() {
                    showSortOverlay = !showSortOverlay;
                  });
                },
                icon: Icon(Icons.swap_vert),
              ),
            ],
          ),
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child:
                        value.userHistory!.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 64,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  Text(
                                    "Your make-up history will be listed here!",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView(
                              children:
                                  value.userHistory!
                                      .map(
                                        (entry) => buildHistoryListItem(
                                          context,
                                          entry.title,
                                          entry.date,
                                          entry.description,
                                        ),
                                      )
                                      .toList(),
                            ),
                  ),
                ),
              ),

              // Overlay Popup Menu
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
                              setState(() {
                                sortByNewest = !sortByNewest;
                                showSortOverlay = false;

                                value.userHistory!.sort((a, b) {
                                  final dateA = parseCustomDate(a.date!);
                                  final dateB = parseCustomDate(b.date!);
                                  return sortByNewest
                                      ? dateB.compareTo(dateA) // Newest first
                                      : dateA.compareTo(dateB); // Oldest first
                                });
                              });
                            },
                            child: Text(
                              sortByNewest ? 'Oldest' : 'Newest',
                              style: const TextStyle(color: Colors.pink),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isAToZ = !isAToZ;
                                showSortOverlay = false;

                                value.userHistory!.sort((a, b) {
                                  return isAToZ
                                      ? a.title.compareTo(b.title) // A to Z
                                      : b.title.compareTo(a.title); // Z to A
                                });
                              });
                            },
                            child: Text(
                              isAToZ
                                  ? 'Z-A'
                                  : 'A-Z', // what the button will toggle to
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
