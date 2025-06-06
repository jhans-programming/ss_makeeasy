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

    String? _title;
    String? _desc;

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
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    // Save state
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$_title + $_desc'),
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

          body: Padding(
            padding: const EdgeInsets.all(32),
            child: Card(
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
                              fit: BoxFit.cover, // Important: Use BoxFit.cover
                            ),
                          ),

                          SizedBox(width: 24),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Title",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Enter a title",
                                    hintStyle: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withAlpha(50),
                                    ),
                                    fillColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceDim,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
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
                                    fontSize: 16,
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
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "Enter a description",
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(50),
                          ),
                          fillColor: Theme.of(context).colorScheme.surfaceDim,
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
          ),
        );
      },
    );
  }
}
