import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/models/tweet.dart';
import 'package:twitter_clone/providers/user_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/*final feedProvider = StreamProvider.autoDispose<List<Tweet>>((ref) => {
    return FirebaseFirestore.instance.collection("tweets").orderBy(
    'postTime', descending: true).snapshots().map((event) {
  List<Tweet> tweets = [];
  for(int i=0; i<event.docs.length; i++0{
  tweets.add(Tweet.fromMap(event.docs[i].data()));
  }
      return tweets;
  });
});*/

final feedProvider = StreamProvider.autoDispose<List<Tweet>>((ref) {
  return FirebaseFirestore.instance
      .collection("tweets")
      .orderBy('postTime', descending: true)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) => Tweet.fromMap(doc.data())).toList();
  });
});


final tweetProvider = Provider<TwitterApi>((ref) => TwitterApi(ref));

class TwitterApi {
  TwitterApi(this._ref);

  final ProviderRef _ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postTweet(String tweet) async {
    // Reading userProvider
    final currentUser = _ref.read(userProvider);

    await _firestore.collection("tweets").add({
      'uid': currentUser.id,
      'profilePic': currentUser.user.profilePic,
      'name': currentUser.user.name,
      'tweet': tweet,
      'postTime': Timestamp.now(),
    });
  }
}
