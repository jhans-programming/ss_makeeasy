import 'package:flutter/material.dart';
import 'package:makeeasy/models/user_history.dart';
import 'package:makeeasy/utils/firestore_fetch_status.dart';

class UserHistory {
  final String title;
  final String date;
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
  List<UserHistory> _userHistory = [
    //dummy data
    UserHistory(
      title: "Makeup 1",
      description: "This is a description",
      date: "4/12 09:18",
      imagePath: "example_url",
      style: 0,
      id: "1",
    ),
    UserHistory(
      title: "AAA",
      description: "This ",
      date: "4/13 09:18",
      imagePath: "example_url",
      style: 1,
      id: "2",
    ),
  ];

  List<UserHistory> get userHistory => _userHistory;

  void addHistory(UserHistory history) {
    _userHistory.add(history);
    notifyListeners();
  }

  void updateHistory(
    String originalDate,
    String newTitle,
    String newDesc,
    String newImagePath,
  ) {
    final index = _userHistory.indexWhere((e) => e.date == originalDate);
    if (index != -1) {
      _userHistory[index] = UserHistory(
        title: newTitle,
        date: _userHistory[index].date,
        description: newDesc,
        imagePath: newImagePath,
        style: _userHistory[index].style,
        id: _userHistory[index].id,
      );
      notifyListeners();
    }
  }

  Future<void> fetchUserHistory() async {}

  Future<void> saveUserHistory() async {}
}
