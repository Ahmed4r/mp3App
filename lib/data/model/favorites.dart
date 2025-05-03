class Favorites {
  final String surahName;
  final String reciterName;
  final String url;

  static String collectionName = 'fav';

  Favorites({
    required this.surahName,
    required this.reciterName,
    required this.url,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'surahName': surahName,
      'reciterName': reciterName,
      'url': url,
    };
  }

  static Favorites fromFirestore(Map<String, dynamic> data) {
    return Favorites(
      surahName: data['surahName'] ?? '',
      reciterName: data['reciterName'] ?? '',
      url: data['url'] ?? '',
    );
  }
}
