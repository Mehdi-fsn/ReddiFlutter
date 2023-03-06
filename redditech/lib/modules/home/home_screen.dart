import 'package:flutter/material.dart';

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
    return Scaffold(
            appBar: AppBar(
              title: Text('Home'),
              centerTitle: false,
              actions: [
                IconButton(onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  icon:CircleAvatar(
                    backgroundImage: NetworkImage("https://worldissmall.fr/wp-content/uploads/2021/08/reddit.png"),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          body : FutureBuilder(
            future: RedditAPI.fetchSubReddit(type: _type),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const SizedBox(
                      height: 500,
                      child: Center(child: CircularProgressIndicator()));
                default:
                  if(snapshot.hasError) {
                    const Center(child:Text('Error loading'));
                  }
                  return  ListView.builder(
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
                  );
              }
            },
          ),
    );
  }
}
