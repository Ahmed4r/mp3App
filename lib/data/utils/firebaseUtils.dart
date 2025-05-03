import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noon/data/model/favorites.dart';
import 'package:noon/data/model/myuser.dart';

class FirebaseUtils {
  // Get the favorites collection with the proper converter
  static CollectionReference<Favorites> getFavoritesCollection() {
    return FirebaseFirestore.instance
        .collection(Favorites
            .collectionName) // Ensure 'collectionName' is defined correctly
        .withConverter<Favorites>(
      fromFirestore: (snapshot, options) {
        return Favorites.fromFirestore(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toFirestore();
      },
    );
  }

  // Add a favorite to Firestore
  static Future<void> addSurahToFirestore(
      Favorites favorite) async {
    try {
      final existingFavorite = await getFavoritesCollection()
          .where('surahName', isEqualTo: favorite.surahName)
          .where('reciterName', isEqualTo: favorite.reciterName)
          .get();

      if (existingFavorite.docs.isEmpty) {
        // Add the favorite only if it doesn't exist
        final docRef =
            getFavoritesCollection().doc(); // Generate a new document reference
        await docRef.set(favorite); // Save the favorite
        print(
            'Favorite added: ${favorite.surahName} by ${favorite.reciterName}');
      } else {
        print(
            'Favorite already exists: ${favorite.surahName} by ${favorite.reciterName}');
      }
    } catch (e) {
      print('Error adding favorite: $e'); // Logging the error
      throw Exception('Failed to add favorite: $e');
    }
  }

  // Fetch all favorites from Firestore
  static Future<List<Favorites>> fetchFavorites() async {
    try {
      QuerySnapshot<Favorites> snapshot = await getFavoritesCollection().get();
      for (var doc in snapshot.docs) {
        print('Fetched favorite: ${doc.data()}'); // Log each fetched favorite
      }
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching favorites: $e'); // Improved logging
      throw Exception('Failed to load favorites: ${e.toString()}');
    }
  }

  // Remove a favorite from Firestore
  static Future<void> removeFavorite(Favorites favorite) async {
    try {
      // Query to find the document with matching surah and reciter names
      final existingFavorite = await getFavoritesCollection()
          .where('surahName', isEqualTo: favorite.surahName)
          .where('reciterName', isEqualTo: favorite.reciterName)
          .get();

      if (existingFavorite.docs.isNotEmpty) {
        // Remove the document by ID
        await getFavoritesCollection()
            .doc(existingFavorite.docs.first.id)
            .delete();
        print(
            'Favorite removed: ${favorite.surahName} by ${favorite.reciterName}');
      } else {
        print(
            'Favorite not found: ${favorite.surahName} by ${favorite.reciterName}');
      }
    } catch (e) {
      print('Error removing favorite: $e'); // Logging the error
      throw Exception('Failed to remove favorite: $e');
    }
  }

  // User management
  static CollectionReference<Myuser> readuserCollection() {
    return FirebaseFirestore.instance
        .collection(Myuser.collectionName)
        .withConverter<Myuser>(
      fromFirestore: (snapshot, options) {
        return Myuser.fromFirestore(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toFirestore();
      },
    );
  }

  static Future<void> addUserToFireStore(Myuser user) async {
    try {
      await readuserCollection().doc(user.id).set(user);
    } catch (e) {
      print('Error adding user: $e');
      throw Exception('Failed to add user: $e');
    }
  }

  static Future<Myuser?> readUserFromFirestore(String uid) async {
    try {
      var snapshot = await readuserCollection().doc(uid).get();
      return snapshot.data();
    } catch (e) {
      print('Error reading user from Firestore: $e');
      return null; // Handle null case appropriately in the calling function
    }
  }

  static Future<Myuser?> readuserfromFireStore(String Uid) async {
    var snapshot = await readuserCollection().doc(Uid).get();
    return snapshot.data();
  }
}
