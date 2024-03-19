import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
              if(pickedImage != null){
                ref.read(userProvider.notifier).updateImage(File(pickedImage.path));
              }
            },
            child: CircleAvatar(
              radius: 100,
              foregroundImage: NetworkImage(currentUser.user.profilePic),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(child: Text('Tap Image to Change')),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Enter your name",
            ),
          ),
          TextButton(
              onPressed: () {
                ref
                    .read(userProvider.notifier)
                    .updateName(_nameController.text);
              },
              child: Text("Update")),
        ],
      ),
    );
  }
}
