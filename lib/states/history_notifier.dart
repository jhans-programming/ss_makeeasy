import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeeasy/utils/firestore_fetch_status.dart';

class UserHistory {
  final String title;
  final DateTime date;
  final String description;
  final String imagePath;
  final int style;
  final String id;

  UserHistory({
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
    required this.style,
    required this.id,
  });
}

class UserHistoryNotifier extends ChangeNotifier {
  List<UserHistory> _userHistory = [];
  RequestStatus _requestStatus = RequestStatus.loading;

  List<UserHistory> get userHistory => _userHistory;
  RequestStatus get requestStatus => _requestStatus;

  Future<void> fetchUserHistory() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      _requestStatus = RequestStatus.loading;
      notifyListeners();

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();

      if (data == null || data['history'] == null) {
        _userHistory = [];
      } else {
        _userHistory = List<UserHistory>.from((data['history'] as List).map((item) {
          return UserHistory(
            title: item['title'] ?? '',
            description: item['description'] ?? '',
            imagePath: item['image'] ?? '',
            date: (item['date'] as Timestamp).toDate(),
            style: item['category'] ?? 0,
            id: item['date'].toDate().toIso8601String(), // use date as unique ID
          );
        }));
      }

      _requestStatus = RequestStatus.success;
      notifyListeners();
    } catch (e) {
      print('Error fetching user history: $e');
      _requestStatus = RequestStatus.error;
      notifyListeners();
    }
  }

  void addHistory(UserHistory history) {
    _userHistory.add(history);
    notifyListeners();
  }

  void updateHistory(
    String id,
    String newTitle,
    String newDesc,
    String newImagePath,
  ) {
    final index = _userHistory.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updated = UserHistory(
        title: newTitle,
        date: _userHistory[index].date,
        description: newDesc,
        imagePath: newImagePath,
        style: _userHistory[index].style,
        id: _userHistory[index].id,
      );
      _userHistory[index] = updated;
      notifyListeners();
    }
  }
void sortByDate({required bool newestFirst}) {
  if (_userHistory == null) return;
  _userHistory!.sort((a, b) =>
      newestFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
  notifyListeners();
}

void sortByTitle({required bool aToZ}) {
  if (_userHistory == null) return;
  _userHistory!.sort((a, b) =>
      aToZ ? a.title.compareTo(b.title) : b.title.compareTo(a.title));
  notifyListeners();
}

 Future<void> removeHistoryItem(UserHistory item) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final historyList = userDoc.data()?['history'] as List<dynamic>?;

      if (historyList == null) return;

      // Match by unique date (assumed unique per entry)
      final target = historyList.firstWhere(
        (h) => (h['date'] as Timestamp).toDate().toIso8601String() == item.date.toIso8601String(),
        orElse: () => null,
      );

      if (target == null) {
        print("⚠️ No matching entry found for date: ${item.date}");
        return;
      }

      // Remove from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'history': FieldValue.arrayRemove([target])
      });

      // Remove from local list
      _userHistory.removeWhere((h) => h.date.toIso8601String() == item.date.toIso8601String());
      notifyListeners();
    } catch (e) {
      print("❌ Failed to remove history item: $e");
    }
  }



}
