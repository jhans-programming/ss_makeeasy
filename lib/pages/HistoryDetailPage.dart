import 'package:flutter/material.dart';
import 'package:makeeasy/states/history_notifier.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeeasy/pages/InstructionsPage.dart';

class HistoryDetailPage extends StatefulWidget {
  final String historyDate; // use a unique field like date or ID

  const HistoryDetailPage({
    super.key,
    required this.historyDate,
  });

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _title;
  String? _desc;
  String? _imageUrl;
  String? _date;
  String? _category;
  bool _loading = true;

  String _getCategoryName(String? category) {
    switch (category) {
      case '0':
        return "Party in the USA";
      case '1':
        return "Last Friday Night";
      case '2':
        return "Work from Home";
      default:
        return "Unknown Style";
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchHistoryDetail();
  }

  Future<void> _fetchHistoryDetail() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final historyList = doc.data()?['history'] ?? [];

    final entry = historyList.firstWhere(
      (item) => item['date'].toDate().toString() == widget.historyDate,
      orElse: () => null,
    );

    if (entry != null) {
      setState(() {
        _title = entry['title'];
        _desc = entry['description'];
        _imageUrl = entry['image'];
        _category = entry['category'].toString();
        _date = entry['date'].toDate().toString();
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("Edit History", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        actions: [
          ElevatedButton(
            onPressed: _loading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Provider.of<UserHistoryNotifier>(context, listen: false)
                          .updateHistory(_date!, _title!, _desc!, _imageUrl!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Changes saved.')),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
            ),
            child: const Text("Save"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_imageUrl != null)
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(_imageUrl!),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text("Title", style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        initialValue: _title,
                        decoration: const InputDecoration(hintText: 'Enter a title'),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                        onSaved: (value) => _title = value,
                      ),
                      const SizedBox(height: 12),
                      Text("Saved on $_date", style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      Text("Description", style: Theme.of(context).textTheme.titleMedium),
                      TextFormField(
                        initialValue: _desc,
                        maxLines: 10,
                        decoration: const InputDecoration(hintText: 'Enter a description'),
                        onSaved: (value) => _desc = value,
                      ),
                      const SizedBox(height: 24),

                      if (_category != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Center(
                            child: Text(
                              "Style Used: ${_getCategoryName(_category)}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_category != null) {
                              try {
                                int selectedCategory = int.parse(_category!); // assuming stored as string in Firestore
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InstructionsPage(selectedCategory: selectedCategory),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid category data.")),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No category found in this history item.")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          icon: const Icon(Icons.replay),
                          label: const Text("Recreate", style: TextStyle(fontSize: 16)),
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
