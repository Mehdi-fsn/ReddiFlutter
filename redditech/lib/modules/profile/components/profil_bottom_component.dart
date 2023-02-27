import 'package:flutter/material.dart';

import 'package:redditech/constants/app_theme.dart';

class ProfileBottomComponent extends StatefulWidget {
  const ProfileBottomComponent({Key? key}) : super(key: key);

  @override
  State<ProfileBottomComponent> createState() => _ProfileBottomComponentState();
}

class _ProfileBottomComponentState extends State<ProfileBottomComponent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              padding: const EdgeInsets.all(0),
              controller: _tabController,
              tabs: const [
                Tab(text: 'Posts'),
                Tab(text: 'Settings'),
              ],
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade300,
              ),
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Center(
                        child: Container(
                            height: 400,
                            color: AppTheme.primary,
                            child: const Center(
                                child: Text('Contenu de la vue 1')))),
                  ),
                  SingleChildScrollView(
                    child: Center(
                        child: Container(
                            height: 400,
                            color: AppTheme.secondary,
                            child: const Center(
                                child: Text('Contenu de la vue 2')))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
