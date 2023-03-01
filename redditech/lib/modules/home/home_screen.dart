import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:redditech/constants/app_theme.dart';
import 'package:redditech/models/reddit_post.dart';
import 'package:redditech/services/api/reddit_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _type = 'hot';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                const Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(child: Text('Search Bar')),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _type = 'hot';
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: (_type == 'hot')
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'Hot',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: (_type == 'hot')
                                    ? Colors.white
                                    : AppTheme.textColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _type = 'new';
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: (_type == 'new')
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'New',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: (_type == 'new')
                                    ? Colors.white
                                    : AppTheme.textColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _type = 'top';
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: (_type == 'top')
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'Top',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: (_type == 'top')
                                    ? Colors.white
                                    : AppTheme.textColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _type = 'rising';
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: (_type == 'rising')
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'Rising',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: (_type == 'rising')
                                    ? Colors.white
                                    : AppTheme.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: RedditAPI.fetchSubReddit(type: _type),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const SizedBox(
                      height: 500,
                      child: Center(child: CircularProgressIndicator()));
                default:
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return RedditPost(
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
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
