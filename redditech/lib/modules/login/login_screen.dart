import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/constants/app_path.dart';
import 'package:redditech/services/repositories/user_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Modular.get<UserRepository>().login();
          Modular.to.navigate(AppPath.homeScreenPath);
        },
        child: const Text("Login"),
      ),
    );
  }
}
