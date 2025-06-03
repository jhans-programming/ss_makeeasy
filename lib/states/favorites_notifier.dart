import 'package:flutter/material.dart';
import 'package:makeeasy/utils/makeup_data.dart';
import 'package:tuple/tuple.dart';

class FavoriteFiltersNotifier extends ChangeNotifier {
  List<Tuple2<MakeupCategory, int>> _favoriteFilters = [
    Tuple2(MakeupCategory.Category1, 0),
  ];

  List<Tuple2<MakeupCategory, int>> get getFavoriteFilters => _favoriteFilters;

  void fetchFavoriteFilters() async {
    // fetch user favorites from firestore
  }
}
