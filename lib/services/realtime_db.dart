import 'package:firebase_database/firebase_database.dart';
import '../models/food_item.dart';

class RealtimeDatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Stream<List<FoodItem>> getFoodItems() {
    return _db.child('foodItems').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final map = Map<String, dynamic>.from(data as Map);

      return map.entries.map((e) {
        final foodData = Map<String, dynamic>.from(e.value);
        return FoodItem.fromMap(foodData, e.key);
      }).toList();
    });
  }
}