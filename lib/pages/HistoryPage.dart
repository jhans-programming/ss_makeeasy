import 'package:flutter/material.dart';
import 'package:makeeasy/pages/HistoryDetailPage.dart';
import 'package:makeeasy/pages/HomePage.dart';
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
  List<Map<String, String>> historyData = List.generate(10, (index) {
    return {
      "title": "Entry ${index + 1}",
      "date": "4/${10 + index} 09:18", // 4/10 to 4/19
      "description":
          "This is a description for Entry ${index + 1}. It might contain some longer content to preview.",
    };
  });

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

  void sortByDate() {
    setState(() {
      sortByNewest = !sortByNewest;
      showSortOverlay = false;

      historyData.sort((a, b) {
        final dateA = parseCustomDate(a["date"]!);
        final dateB = parseCustomDate(b["date"]!);
        return sortByNewest
            ? dateB.compareTo(dateA) // Newest first
            : dateA.compareTo(dateB); // Oldest first
      });
    });
  }

  void sortByTitle() {
    setState(() {
      isAToZ = !isAToZ;
      showSortOverlay = false;

      historyData.sort((a, b) {
        return isAToZ
            ? a["title"]!.compareTo(b["title"]!) // A to Z
            : b["title"]!.compareTo(a["title"]!); // Z to A
      });
    });
  }

  Widget fancyHistoryButton(
    BuildContext context,
    String title,
    String date,
    String description,
  ) {
    final String truncated =
        description.length > 25
            ? '${description.substring(0, 25)}... show more'
            : description;

    return GestureDetector(
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
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.pink, width: 1.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(truncated, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    'saved on $date',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                      ),
                      const Text(
                        'HISTORY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.pink,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_vert, color: Colors.pink),
                        onPressed: () {
                          setState(() {
                            showSortOverlay = !showSortOverlay;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // History List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children:
                        historyData
                            .map(
                              (entry) => fancyHistoryButton(
                                context,
                                entry["title"]!,
                                entry["date"]!,
                                entry["description"]!,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),

          // Overlay Popup Menu
          if (showSortOverlay)
            Positioned(
              top: 60,
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
                        onPressed: sortByDate,
                        child: Text(
                          sortByNewest ? 'Oldest' : 'Newest',
                          style: const TextStyle(color: Colors.pink),
                        ),
                      ),
                      TextButton(
                        onPressed: sortByTitle,
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
  }
}
