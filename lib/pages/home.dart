import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/pages/settings.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';
import 'package:twitter_clone/providers/user_provider.dart';

import '../models/tweet.dart';
import 'create_tweet.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider); // As used at many places
    return Scaffold(
      appBar: AppBar(
        // To create separation between appbar and content i.e. list view builder
        bottom: PreferredSize(preferredSize: Size.fromHeight(4.0), child: Container(color: Colors.blueGrey,height: 1,)),
        title: FaIcon(FontAwesomeIcons.twitter),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.user.profilePic),
              ),
            ),
          );
        }),
      ),
      body: ref.watch(feedProvider).when(
          data: (List<Tweet> tweets) {
            return ListView.separated(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(tweets[index].profilePic),
                  ),
                  title: Text(
                    tweets[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    tweets[index].tweet,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                );
              },
            );
          },
          error: (error, stackTrace) => Center(
                child: Text("error"),
              ),
          loading: () => Center(child: CircularProgressIndicator())),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(currentUser.user.profilePic),
            ListTile(
              title: Text(
                "Hello , ${currentUser.user.name}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Settings()));
              },
              title: Text('Settings'),
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).clearUserInfo();
              },
              title: Text('Sign Out'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateTweet()),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
