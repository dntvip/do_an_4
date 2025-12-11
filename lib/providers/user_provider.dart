import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _user;
  bool _isLoading = false; // Start with false to avoid initial loading screen issues
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DatabaseEvent>? _userSubscription;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;

  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  UserProvider() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _userSubscription?.cancel();

      if (firebaseUser == null) {
        // User is signed out
        _user = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // User is signed in, show loading and start listening
      _isLoading = true;
      notifyListeners();

      // A timer to prevent getting stuck in loading state indefinitely.
      Timer? loadingTimeout = Timer(const Duration(seconds: 5), () {
        if (_isLoading) {
          debugPrint("User data loading timed out. Finalizing state.");
          _isLoading = false;
          notifyListeners();
        }
      });

      _userSubscription = _usersRef.child(firebaseUser.uid).onValue.listen(
        (event) {
          loadingTimeout.cancel(); // Data received, cancel the timeout

          if (event.snapshot.exists && event.snapshot.value != null) {
            // Case 1: User data exists in DB.
            _user = AppUser.fromMap(firebaseUser.uid, Map<String, dynamic>.from(event.snapshot.value as Map));
            _isLoading = false;
            notifyListeners();
          } else {
            // Case 2: User data does NOT exist in DB.
            final isGoogleProvider = firebaseUser.providerData.any((p) => p.providerId == 'google.com');
            if (isGoogleProvider) {
              // Sub-case 2a: It's a Google user's first login. Create their profile.
              final newAppUser = AppUser(
                uid: firebaseUser.uid,
                name: firebaseUser.displayName ?? 'Người dùng mới',
                email: firebaseUser.email!,
                avatarUrl: firebaseUser.photoURL,
              );
              _usersRef.child(newAppUser.uid).set(newAppUser.toMap());
              // The stream will pick up the new user data automatically, so we just set it here.
              _user = newAppUser;
              _isLoading = false;
              notifyListeners();
            } else {
               // Sub-case 2b: It's likely an email/pass user who has just registered.
               // The data might be slightly delayed. The stream will eventually pick it up.
               // The timeout will handle the case where data never arrives.
               debugPrint("User data not found for email user, waiting for stream...");
            }
          }
        },
        onError: (error) {
          loadingTimeout.cancel();
          debugPrint('Error listening to user data: $error');
          _user = null;
          _isLoading = false;
          notifyListeners();
        },
      );
    });
  }


  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? address,
  }) async {
    final Map<String, dynamic> dataToUpdate = {};
    if (name != null) dataToUpdate['name'] = name;
    if (phoneNumber != null) dataToUpdate['phoneNumber'] = phoneNumber;
    if (address != null) dataToUpdate['address'] = address;

    if (dataToUpdate.isNotEmpty) {
      try {
        await _usersRef.child(userId).update(dataToUpdate);
        // The stream will automatically update the UI, but we can do it optimistically
        _user = _user?.copyWith(
          name: name,
          phoneNumber: phoneNumber,
          address: address,
        );
        notifyListeners();
      } catch (e) {
        debugPrint('Error updating user profile: $e');
        rethrow;
      }
    }
  }

  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
    } catch (e) {
      debugPrint("Google sign out attempt failed (this is often okay): $e");
    }
    await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.dispose();
  }
}
