import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:redditech/constants/app_path.dart';

import 'package:redditech/constants/app_theme.dart';
import 'package:redditech/models/reddit_post.dart';
import 'package:redditech/models/subreddit_suggestion.dart';
import 'package:redditech/services/api/reddit_api.dart';
import 'package:redditech/utils/error_catch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _type = 'best';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _type = 'best';
                          });
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                color: (_type == 'best')
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Best',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: (_type == 'best')
                                ? Colors.white
                                : AppTheme.textColor,
                          ),
                        ),
                      ),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                      IconButton(
                        onPressed: () {
                          setState(() {
                            Modular.to.pushNamed(AppPath.searchScreenPath);
                          });
                        },
                        icon: const Icon(
                          Icons.search,
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: RedditAPI.fetchPostsSubreddit(type: _type),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Expanded(
                  child: SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.secondary,
                      ),
                    ),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  ErrorCatch.catchError(snapshot, context);
                  return const SizedBox.shrink();
                }
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return RedditPost(
                        subreddit: snapshot.data![index]["subreddit"],
                        author: snapshot.data![index]["author"],
                        title: snapshot.data![index]["title"],
                        media: snapshot.data![index]["media"],
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
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: TypeAheadField<SubredditSuggestion>(
            suggestionsBoxDecoration: const SuggestionsBoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                focusColor: AppTheme.secondary,
                prefixIcon: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                suffixIcon: const Icon(Icons.search),
                hintText: 'Search subreddit',
              ),
            ),
            suggestionsCallback: (pattern) async {
              return await RedditAPI.fetchSubredditSuggestions(pattern);
            },
            itemBuilder: (context, SubredditSuggestion suggestion) {
              if (!suggestion.name.startsWith('u_')) {
                return ListTile(
                    title: Text(
                  suggestion.name,
                  style: const TextStyle(color: Colors.black),
                ));
              } else {
                return const SizedBox.shrink();
              }
            },
            noItemsFoundBuilder: (context) => const ListTile(
              title: Text('No Subreddits Found'),
            ),
            loadingBuilder: (context) => const ListTile(
              title: Text('Loading...'),
            ),
            errorBuilder: (context, error) => Text('$error'),
            minCharsForSuggestions: 2,
            onSuggestionSelected: (SubredditSuggestion suggestion) {
              Modular.to.pushNamed(
                  '${AppPath.subredditScreenPath}/${suggestion.name}');
            },
          ),
        ),
      ),
    );
  }
}
