import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/constants/app_path.dart';
import 'package:redditech/services/repositories/user_repository.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key, required Widget body})
      : _body = body,
        super(key: key);

  final Widget _body;
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body,
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.orange,
        activeColor: Colors.white,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.settings, title: 'Profile'),
          TabItem(icon: Icons.message, title: 'Message'),
          TabItem(icon: Icons.logout, title: 'Logout'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          switch (index) {
            case 0:
              Modular.to.navigate(AppPath.homeScreenPath);
              break;
            case 1:
              Modular.to.navigate(AppPath.profileScreenPath);
              break;
            case 2:
              Modular.to.navigate(AppPath.messageScreenPath);
              break;
            case 3:
              Modular.get<UserRepository>().deleteToken();
              Modular.to.navigate(AppPath.loginScreenPath);
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
