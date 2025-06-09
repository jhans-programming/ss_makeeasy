import 'package:flutter/material.dart';
import 'package:makeeasy/pages/HistoryPage.dart';
import 'package:makeeasy/states/history_notifier.dart';
import 'package:makeeasy/utils/appStyle.dart';
import 'package:provider/provider.dart';

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
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String? _title = title;
    String? _desc = description;

    return Consumer<UserHistoryNotifier>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              "Edit History",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // _formKey.currentState!.save();
                  // if (_formKey.currentState!.validate()) {
                  //   // Save state
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text('$_title + $_desc'),
                  //       duration: const Duration(seconds: 1),
                  //     ),
                  //   );
                  // }
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    value.updateHistory(date, _title!, _desc!, imagePath);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Changes saved.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                child: Text("Save"),
              ),
              SizedBox(width: 16),
            ],
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Image(
                                    image: const AssetImage(
                                      'assets/images/profile.jpg',
                                    ), // Use your asset image
                                    width: 150,
                                    height: 150,
                                    fit:
                                        BoxFit
                                            .cover, // Important: Use BoxFit.cover
                                  ),
                                ),

                                SizedBox(width: 24),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Title",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        ),
                                      ),
                                      TextFormField(
                                        initialValue: title,
                                        decoration: InputDecoration(
                                          hintText: "Enter a title",
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(50),
                                          ),
                                          fillColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.surfaceDim,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),

                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a title';
                                          }
                                          return null;
                                        },

                                        onSaved: (value) {
                                          _title = value;
                                        },
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        "Saved on $date", //the date is not editable
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                            Text(
                              "Description",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            TextFormField(
                              initialValue: description,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: "Enter a description",
                                hintStyle: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(50),
                                ),
                                fillColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),

                              validator: (value) {
                                return null;
                              },

                              onSaved: (value) {
                                _desc = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Recreate logic goes here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pink,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.refresh, color: Colors.pink),
                        SizedBox(width: 8),
                        Text(
                          "Recreate",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
