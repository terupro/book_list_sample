import 'package:book_list_sample/book_list/book_list_model.dart';
import 'package:book_list_sample/domain/book.dart';
import 'package:book_list_sample/edit_profile/edit_profile_page.dart';
import 'package:book_list_sample/profile/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileModel>(
      create: (_) => ProfileModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('マイページ'),
          actions: [
            Consumer<ProfileModel>(builder: (context, model, child) {
              return IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfilePage(model.name, model.description),
                    ),
                  );
                  model.fetchUser();
                },
                icon: const Icon(Icons.edit),
              );
            }),
          ],
        ),
        body: Center(
          child: Consumer<ProfileModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        model.name ?? '名前',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(model.email ?? 'メールアドレスなし'),
                      Text(model.description ?? '説明文'),
                      TextButton(
                        onPressed: () async {
                          await model.logout();
                          Navigator.pop(context);
                        },
                        child: const Text('ログアウト'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
