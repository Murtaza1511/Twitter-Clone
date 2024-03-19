import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';

class CreateTweet extends ConsumerWidget {
  const CreateTweet({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final TextEditingController _tweetController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("Post a Tweet"),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          TextField(
            maxLines: 4,
            controller: _tweetController,
            decoration: InputDecoration(border: OutlineInputBorder()),
            maxLength: 280,
          ),
            TextButton(onPressed: (){
              ref.read(tweetProvider).postTweet(_tweetController.text);
              Navigator.pop(context);
            }, child: Text("Post Tweet"))
        ],),
      ),
    );
  }
}
