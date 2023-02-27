import 'package:flutter/material.dart';

import 'package:redditech/modules/profile/components/profil_bottom_component.dart';
import 'package:redditech/modules/profile/components/profile_top_component.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          ProfilTopComponent(),
          ProfileBottomComponent(),
        ],
      ),
    );
  }
}
