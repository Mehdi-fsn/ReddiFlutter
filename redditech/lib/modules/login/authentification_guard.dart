import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/constants/app_path.dart';
import 'package:redditech/services/repositories/user_repository.dart';

class IsAuthenticateGuard extends RouteGuard {
  IsAuthenticateGuard() : super(redirectTo: AppPath.loginScreenPath);
  
  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return Modular.get<UserRepository>().isLogged;
  }
}

class IsNotAuthenticatedGuard extends RouteGuard {
  IsNotAuthenticatedGuard() : super(redirectTo: AppPath.basePath);

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    return !(await Modular.get<UserRepository>().isLogged);
  }
}