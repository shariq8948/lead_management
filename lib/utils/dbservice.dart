import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref(); // Use instance to get the reference

  // Function to upload user data
  Future<void> uploadUserData(Map<String, dynamic> userData) async {
    try {
      await dbRef.child("users").set(userData);
      print("User data uploaded successfully.");
    } catch (e) {
      print("Failed to upload user data: $e");
    }
  }

  // Function to fetch user data
  Future<DataSnapshot?> fetchUserData() async {
    try {
      return await dbRef.child("users").get();
    } catch (e) {
      print("Failed to fetch user data: $e");
      return null; // Return null in case of failure
    }
  }
}
