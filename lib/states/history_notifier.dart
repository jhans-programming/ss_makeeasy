import 'package:flutter/material.dart';
import 'package:makeeasy/models/user_history.dart';
import 'package:makeeasy/utils/firestore_fetch_status.dart';

class UserHistoryNotifier extends ChangeNotifier {
  List<HistoryItem> _userHistory = [
    HistoryItem(
      title: "Makeup 1",
      description: "This is a description",
      date: "4/12 09:18",
      imagePath: "example_url",
    ),
    HistoryItem(
      title: "AAA",
      description: "This ",
      date: "4/13 09:18",
      imagePath: "example_url",
    ),
  ];
  RequestStatus _requestStatus = RequestStatus.success;

  List<HistoryItem>? get userHistory => _userHistory;
  RequestStatus? get requestStatus => _requestStatus;

  Future<void> fetchUserHistory() async {
    // fetch user history from firestore
  }

  Future<void> saveUserHistory() async {}
}
