import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

// This is created to avoid confusion b/w User we pass to firebase(interface to firebase) and the user we use in our app.
class LocalUser {
  final String id; // To differentiate users
  final FirebaseUser user;

  const LocalUser({required this.id, required this.user});

  // This method is created so user can its name, profilePic etc.
  LocalUser copyWith({String? id, FirebaseUser? user}) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(
          LocalUser(
            // This is default local user
            id: "error",
            user: FirebaseUser(
                email: "error", name: 'error', profilePic: 'error'),
          ),
        );
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> retrieveUserInfo(String email) async {
    QuerySnapshot response = await _firebase
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    if (response.docs.isEmpty) {
      print('No firestore user associated with authenticated email $email');
      return;
    }
    if (response.docs.length != 1) {
      // This won't occur unless some logic is wrong but for double check
      print(
          'More than one firestore user associated with authenticated email $email');
      return;
    }
    // Here we do get the response as snapshot data and NOT reference so NO need to worry.
    state = LocalUser(
        id: response.docs[0].id,
        user: FirebaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));
  }

  Future<void> addUserInfo(String email) async {
    DocumentReference response = await _firebase.collection("users").add(
        FirebaseUser(
                email: email,
                name: 'No Name',
                profilePic:
                    'https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg?auto=compress&cs=tinysrgb&w=600')
            .toMap());
    DocumentSnapshot snapshot = await response
        .get(); // Where response is reference to the data and snapshot is actual data
    state = LocalUser(
        id: response.id,
        user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }
  Future<void> updateImage(File image) async {
    Reference ref = _storage.ref().child("users").child(state.id);
    TaskSnapshot snapshot = await ref.putFile(image);
    String profilePicUrl = await snapshot.ref.getDownloadURL();
    // Thats why we used id , so that we can find the particular user in database.
    await _firebase.collection("users").doc(state.id).update({'profilePic': profilePicUrl });
    // To update in local user stored in our app
    state = state.copyWith(user: state.user.copyWith(profilePic: profilePicUrl));
  }

  Future<void> updateName(String name) async {
    // Thats why we used id , so that we can find the particular user in database.
    await _firebase.collection("users").doc(state.id).update({'name': name});
    // To update in local user stored in our app
    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  void clearUserInfo() {
    state = LocalUser(
        id: "error",
        user: FirebaseUser(email: "error", name: 'error', profilePic: 'error'));
  }
}
