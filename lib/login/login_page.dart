import 'package:book_list_sample/domain/book.dart';
import 'package:book_list_sample/edit_book/edit_book_model.dart';
import 'package:book_list_sample/login/login_model.dart';
import 'package:book_list_sample/register/register_model.dart';
import 'package:book_list_sample/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginkModel>(
      create: (_) => LoginkModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ログイン'),
        ),
        body: Center(
          child: Consumer<LoginkModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    onChanged: (text) {
                      model.setEmail(text);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    onChanged: (text) {
                      model.setPassword(text);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await model.login();
                        Navigator.of(context).pop();
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('ログインする'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: const Text('新規登録の方はこちら'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
