import 'package:flutter/material.dart';

class BodySubreddit extends StatefulWidget {
  const BodySubreddit({Key? key}) : super(key: key);

  @override
  State<BodySubreddit> createState() => _BodySubredditState();
}

class _BodySubredditState extends State<BodySubreddit> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Body Subreddit'),
    );
  }
}
