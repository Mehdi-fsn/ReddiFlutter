import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/constants/app_path.dart';
import 'package:redditech/modules/home/home_screen.dart';
import 'package:redditech/modules/message/message_screen.dart';
import 'package:redditech/modules/profile/profile_screen.dart';
import 'package:redditech/widget/navbar.dart';

class HomeModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      AppPath.basePath,
      child: (context, args) => const HomeMainScreen(),
      children: [
        ChildRoute(
          AppPath.homeScreenPath,
          transition: TransitionType.fadeIn,
          child: (context, args) => const HomeScreen(),
        ),
        ChildRoute(
          AppPath.profileScreenPath,
          transition: TransitionType.fadeIn,
          child: (context, args) => const ProfileScreen(),
        ),
        ChildRoute(
          AppPath.messageScreenPath,
          transition: TransitionType.fadeIn,
          child: (context, args) => const MessageScreen(),
        ),
      ],
    )
  ];
}

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NavBar(
      body: SafeArea(child: RouterOutlet()),
    );
  }
}
