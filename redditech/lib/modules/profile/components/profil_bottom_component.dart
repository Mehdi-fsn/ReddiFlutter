import 'package:flutter/material.dart';

import 'package:redditech/constants/app_theme.dart';
import 'package:redditech/models/reddit_user_post.dart';
import 'package:redditech/services/api/reddit_api.dart';

class ProfileBottomComponent extends StatefulWidget {
  const ProfileBottomComponent({Key? key}) : super(key: key);

  @override
  State<ProfileBottomComponent> createState() => _ProfileBottomComponentState();
}

class _ProfileBottomComponentState extends State<ProfileBottomComponent> {
  int _tabController = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tabController == 0
                          ? Colors.grey.shade300
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      fixedSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                      setState(() {
                        _tabController = 0;
                      });
                    },
                    child: Text(
                      'Posts',
                      style: TextStyle(
                          color: _tabController == 0
                              ? AppTheme.primary
                              : AppTheme.textColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tabController == 1
                          ? Colors.grey.shade300
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      fixedSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                      setState(() {
                        _tabController = 1;
                      });
                    },
                    child: Text(
                      'Settings',
                      style: TextStyle(
                          color: _tabController == 1
                              ? AppTheme.primary
                              : AppTheme.textColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // IndexedStack allow to display only one widget at a time without rebuilding the other
          IndexedStack(
            index: _tabController,
            children: [
              const ListUserPost(),
              Container(
                  height: 100,
                  color: AppTheme.secondary,
                  child: const Text('Contenu de la vue 2')),
            ],
          ),
        ],
      ),
    );
  }
}

class ListUserPost extends StatelessWidget {
  const ListUserPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RedditAPI.fetchUserPostSubmitted(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.secondary,
                  ),
                ),
              );
            default:
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No post found',
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 20,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true, // to limit height
                primary: false, // to disable the scroll
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return RedditUserPost(
                    subreddit: snapshot.data![index]["subreddit"],
                    author: snapshot.data![index]["author"],
                    title: snapshot.data![index]["title"],
                    selfText: snapshot.data![index]["selfText"],
                    thumbnail: snapshot.data![index]["thumbnail"],
                    score: snapshot.data![index]["score"],
                    numComments: snapshot.data![index]["numComments"],
                    createdUtc: snapshot.data![index]["createdUtc"],
                  );
                },
              );
          }
        });
  }
}
