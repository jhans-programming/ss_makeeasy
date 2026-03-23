import 'dart:io';
import 'package:flutter/material.dart';
import 'package:makeeasy/models/user_history.dart';
import 'package:makeeasy/pages/HomePage.dart';
import 'package:makeeasy/pages/ProfilePage.dart';
import 'package:makeeasy/pages/HistoryPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeeasy/states/history_notifier.dart';

class ResultSelfiePage extends StatefulWidget {
  final UserHistory history;
  //final HistoryItem history;
  final int selectedCategory;

  const ResultSelfiePage({
    super.key,
    required this.history,
    required this.selectedCategory,
  });

  @override
  State<ResultSelfiePage> createState() => _ResultSelfiePageState();
}

class _ResultSelfiePageState extends State<ResultSelfiePage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.history.title);
    _descController = TextEditingController(text: widget.history.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _uploadAndSaveHistory() async {
    try {
      setState(() => _isUploading = true);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw "User not signed in.";

      final file = File(widget.history.imagePath);
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('selfies/$uid/$fileName.jpg');

      final uploadTask = await ref.putFile(file);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      final entry = {
        'title': _titleController.text,
        'description': _descController.text,
        'image': imageUrl, //tania modify
        //'imagePath': imageUrl,
        'date': Timestamp.fromDate(widget.history.date),
        'category': widget.selectedCategory,
      };

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'history': FieldValue.arrayUnion([entry])
      }, SetOptions(merge: true));

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HistoryPage()),
      // );

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const HistoryPage()),
      //   (route) => false, // removes all previous routes from the stack
      // );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ProfilePage()),
        (route) => false,
      );

      // Then after a short delay, navigate to HistoryPage
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HistoryPage()),
        );
      });

    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _cancelChanges() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Discard Selfie?"),
        content: const Text(
          "Are you sure you want to discard this selfie? Your progress will be lost.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // pop this page
            },
            child: const Text("Yes, discard"),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Result & Edit')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           Image.file(File(widget.history.imagePath), height: 250),
  //           const SizedBox(height: 20),
  //           TextField(
  //             controller: _titleController,
  //             decoration: const InputDecoration(labelText: 'Title'),
  //           ),
  //           const SizedBox(height: 10),
  //           TextField(
  //             controller: _descController,
  //             maxLines: 3,
  //             decoration: const InputDecoration(labelText: 'Description'),
  //           ),
  //           const SizedBox(height: 20),
  //           Text("Style ID: ${widget.selectedCategory}"),
  //           const SizedBox(height: 20),
  //           if (_isUploading)
  //             const CircularProgressIndicator()
  //           else
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 ElevatedButton(
  //                   onPressed: _uploadAndSaveHistory,
  //                   child: const Text("Save"),
  //                 ),
  //                 OutlinedButton(
  //                   onPressed: _cancelChanges,
  //                   child: const Text("Cancel"),
  //                 ),
  //               ],
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
Widget build(BuildContext context) {
  bool isAssetPath = !widget.history.imagePath.startsWith('/');

  Widget imageWidget = isAssetPath
      ? Image.asset(widget.history.imagePath, height: 250)
      : Image.file(File(widget.history.imagePath), height: 250);

  return Scaffold(
    appBar: AppBar(title: const Text('Result & Edit')),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    imageWidget,
                    const SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 20),
                    Text("Style ID: " +
                        ((widget.selectedCategory == 0)
                            ? "Party in the USA"
                            : "Last Friday Night")),
                    const SizedBox(height: 20),
                    if (_isUploading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: _uploadAndSaveHistory,
                            child: const Text("Save"),
                          ),
                          OutlinedButton(
                            onPressed: _cancelChanges,
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}


}
