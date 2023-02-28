import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/constants/app_path.dart';

class HomeGuard extends RouteGuard {
  HomeGuard() : super(redirectTo: AppPath.homeScreenPath);

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return false;
  }
}