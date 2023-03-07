import 'package:flutter/material.dart';
import 'package:redditech/constants/app_theme.dart';
import 'package:redditech/models/reddit_post.dart';
import 'package:redditech/services/api/reddit_api.dart';

class BodySubreddit extends StatefulWidget {
  const BodySubreddit({Key? key, this.subredditName}) : super(key: key);

  final String? subredditName;

  @override
  State<BodySubreddit> createState() => _BodySubredditState();
}

class _BodySubredditState extends State<BodySubreddit> {
  var _type = 'hot';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RedditAPI.fetchPostsSubreddit(
          subreddit: widget.subredditName!, type: _type),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SizedBox(
              height: 500,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.secondary,
                ),
              ),
            );
          default:
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _type = 'hot';
                        });
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: (_type == 'hot')
                                  ? AppTheme.primary
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
                              ? AppTheme.primary
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: (_type == 'new')
                                  ? AppTheme.primary
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
                              ? AppTheme.primary
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: (_type == 'top')
                                  ? AppTheme.primary
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
                              ? AppTheme.primary
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: (_type == 'rising')
                                  ? AppTheme.primary
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
                              ? AppTheme.primary
                              : AppTheme.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RedditPost(
                      subreddit: snapshot.data![index]['subreddit'],
                      title: snapshot.data![index]['title'],
                      author: snapshot.data![index]['author'],
                      selfText: snapshot.data![index]['selfText'],
                      thumbnail: snapshot.data![index]['thumbnail'],
                      score: snapshot.data![index]['score'],
                      numComments: snapshot.data![index]['numComments'],
                      createdUtc: snapshot.data![index]['createdUtc'],
                    );
                  },
                ),
              ],
            );
        }
      },
    );
  }
}
