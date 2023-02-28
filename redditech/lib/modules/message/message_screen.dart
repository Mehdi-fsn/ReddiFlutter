import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';
import '../../services/api/reddit_api.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var userSearch = "";
  var showSubreddit = false;

  @override
  Widget build(BuildContext context) {
    final reddit = RedditAPI();

    TextEditingController textController = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, right: 10, left: 10),

          /// In AnimSearchBar widget, the width, textController, onSuffixTap are required properties.
          /// You have also control over the suffixIcon, prefixIcon, helpText and animationDurationInMilli
          child: AnimSearchBar(
            width: 400,
            textController: textController,
            onSuffixTap: () {
              setState(() {
                textController.clear();
              });
            },
            onSubmitted: (String variable) {
              print(showSubreddit);
              setState(() {
                showSubreddit = true;
                userSearch = variable;
              });
            },
          ),
        ),
        showSubreddit ?
        FutureBuilder(
            future: reddit.fetchSubreddit(userSearch),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              print("Search : $userSearch");
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primary,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Loading error: ${snapshot.error}'),
                    );
                  }
                  return Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.blue,
                  );
              }
            })
            :
            const Text("Veuillez effectuer une recherche")
      ],
    );
  }
}
