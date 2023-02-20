import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:redditech/constants/app_path.dart';
import 'package:redditech/modules/home_module.dart';
import 'package:redditech/modules/login/authentification_guard.dart';
import 'package:redditech/modules/login/login_screen.dart';
import 'package:redditech/services/repositories/user_repository.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => UserRepository()),
      ];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute(
          AppPath.basePath,
          transition: TransitionType.fadeIn,
          guards: [IsAuthenticateGuard()],
          module: HomeModule(),
        ),
        ChildRoute(
          AppPath.loginScreenPath,
          transition: TransitionType.fadeIn,
          guards: [IsNotAuthenticatedGuard()],
          child: (context, args) => const LoginScreen(),
        ),
        WildcardRoute(
          child: (BuildContext context, _) {
            return const SizedBox(
              child: Center(
                child: Text("404"),
              ),
            );
          },
        ),
      ];
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Redditech',
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
