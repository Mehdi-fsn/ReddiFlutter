import 'dart:async';

import 'package:redditech/models/user_context.dart';

class UserRepository {
  UserContext? userContext;

  UserRepository();

  /*final StreamController<bool> _loggedStreamController = StreamController<bool>();

  Stream<bool> get loggedStream => _loggedStreamController.stream;*/

  void login() => userContext = UserContext(username: "mehdi");

  void logout() => userContext = null;

  Future<bool> get isLogged async => (userContext) != null;
}
