import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String uid;
  final String profilePic;
  final String name;
  final String tweet;
  final Timestamp postTime;

  Tweet({
    required this.uid,
    required this.profilePic,
    required this.name,
    required this.tweet,
    required this.postTime,
  });

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      uid: map['uid'],
      profilePic: map['profilePic'],
      name: map['name'],
      tweet: map['tweet'],
      postTime: map['postTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'profilePic': profilePic,
      'name': name,
      'tweet': tweet,
      'postTime': postTime,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Tweet &&
              runtimeType == other.runtimeType &&
              uid == other.uid &&
              profilePic == other.profilePic &&
              name == other.name &&
              tweet == other.tweet &&
              postTime == other.postTime;

  @override
  int get hashCode =>
      uid.hashCode ^
      profilePic.hashCode ^
      name.hashCode ^
      tweet.hashCode ^
      postTime.hashCode;

  @override
  String toString() {
    return 'Tweet{uid: $uid, profilePic: $profilePic, name: $name, tweet: $tweet, postTime: $postTime}';
  }
}
