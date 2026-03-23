class HistoryItem {
  const HistoryItem({
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
  });

  final String title;
  final String description;
  final DateTime date;
  final String imagePath;
}
