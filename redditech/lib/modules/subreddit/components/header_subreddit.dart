import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:redditech/constants/app_theme.dart';
import 'package:redditech/constants/reddit_info.dart';
import 'package:redditech/services/api/reddit_api.dart';
import 'package:redditech/utils/format_number.dart';

class HeaderSubreddit extends StatefulWidget {
  const HeaderSubreddit({Key? key, required this.subredditName})
      : super(key: key);

  final String? subredditName;

  @override
  State<HeaderSubreddit> createState() => _HeaderSubredditState();
}

class _HeaderSubredditState extends State<HeaderSubreddit> {
  late String _name;
  late String _subscribers;
  late String _description;
  late String _iconUrl;
  late String _bannerUrl;
  late String _createdUtc;
  late bool _userIsSubscriber;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          RedditAPI.fetchInfoSubreddit(subredditName: widget.subredditName!),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            _name = 'r/${widget.subredditName}';
            _subscribers = FormatNumber.formatNumber(snapshot.data!['subscribers']);
            _description = snapshot.data!['public_description'];
            _iconUrl = (snapshot.data!['icon_img'] != '')
                ? snapshot.data!['icon_img']
                : RedditInfo.urlIcon;
            _bannerUrl = (snapshot.data!['banner_background_image'] != '')
                ? snapshot.data!['banner_background_image']
                : RedditInfo.urlBanner;
            _createdUtc = '${DateTime.fromMillisecondsSinceEpoch(snapshot.data!['created_utc'].toInt() * 1000).day} ${DateTime.fromMillisecondsSinceEpoch(snapshot.data!['created_utc'].toInt() * 1000).month} ${DateTime.fromMillisecondsSinceEpoch(snapshot.data!['created_utc'].toInt() * 1000).year}';
            _userIsSubscriber = snapshot.data!['user_is_subscriber'];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              _bannerUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 10,
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(_iconUrl),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100,
                            left: 135,
                            right: 10,
                            child: SizedBox(
                              height: 60,
                              child: Center(
                                child: Text(_name,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: 5,
                            child: IconButton(
                              iconSize: 30,
                              color: Colors.black,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_description,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,),
                          softWrap: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '$_subscribers subscribers',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Created $_createdUtc',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          TextButton(
                            onPressed: () {
                              setState(() {
                                _userIsSubscriber = !_userIsSubscriber;
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: (_userIsSubscriber)
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                (_userIsSubscriber)
                                    ? Colors.white
                                    : AppTheme.primary,
                              ),
                            ),
                            child: Text(
                              (_userIsSubscriber) ? 'Subscribed' : 'Subscribe',
                              style: TextStyle(
                                color: (_userIsSubscriber)
                                    ? AppTheme.primary
                                    : Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
