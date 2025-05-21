import 'package:flutter/material.dart';
import 'package:makeeasy/pages/HistoryPage.dart';
import 'package:makeeasy/utils/appStyle.dart';

class HistoryDetailPage extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imagePath;

  const HistoryDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(
      text: title,
    );
    // final TextEditingController dateController = TextEditingController(
    //   text: "May 6, 2025",
    // );
    final TextEditingController descriptionController = TextEditingController(
      text: description,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors['primaryLight4'],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              color: appColors['primaryDark1'],
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors['primaryDark1'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: appColors['primaryLight4'],
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withAlpha(128),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          imagePath,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180,
                            child: Column(
                              children: [
                                TextField(
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    labelText: "Title",
                                    border: UnderlineInputBorder(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 90),
                                Text(
                                  date, //the date is not editable
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: UnderlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
