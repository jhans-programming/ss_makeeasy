// File: favorites_notifier.dart
import 'package:flutter/material.dart';
import 'package:makeeasy/utils/makeup_data.dart';
import 'package:tuple/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteFiltersNotifier extends ChangeNotifier {
  final String uid;
  final List<Tuple2<MakeupCategory, int>> _favoriteFilters = [];

  bool isLoading = true;

  FavoriteFiltersNotifier(this.uid) {
    fetchFavoriteFilters();
  }

  List<Tuple2<MakeupCategory, int>> get getFavoriteFilters => _favoriteFilters;
  List<int> get favoriteIndices => _favoriteFilters.map((e) => e.item2).toList();

  Future<void> fetchFavoriteFilters() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final favList = doc.data()?['favorites'] ?? [];

      _favoriteFilters.clear();

      if (favList is List) {
        for (var i in favList) {
          if (i is int) {
            _favoriteFilters.add(
              Tuple2(MakeupCategory.Category1, i),
            );
          }
        }
      }
    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int index) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await docRef.get();

    List<dynamic> favs = doc.data()?['favorites'] ?? [];

    if (favs.contains(index)) {
      favs.remove(index);
    } else {
      favs.add(index);
    }

    await docRef.update({'favorites': favs});
    await fetchFavoriteFilters();
  }

  bool isFavorite(int index) {
    return favoriteIndices.contains(index);
  }
}
