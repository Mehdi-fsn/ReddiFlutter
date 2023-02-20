import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/main_module.dart';

void main() {
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}
