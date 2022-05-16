import 'package:book_list_sample/login/login_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ログイン'),
        ),
        body: Center(
          child: Consumer<LoginModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
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
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'パスワード',
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
                          model.startLoading();
                          try {
                            await model.login();
                            Navigator.of(context).pop();
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } finally {
                            model.endLoading();
                          }
                        },
                        child: const Text('ログインする'),
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
