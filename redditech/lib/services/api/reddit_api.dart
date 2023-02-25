import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/constants/reddit_info.dart';
import 'package:redditech/services/repositories/user_repository.dart';

class RedditAPI {
  RedditAPI();

  Future<Map<String, dynamic>> fetchRedditUserInfo() async {
    final token = await Modular.get<UserRepository>().getToken();
    final url = Uri.parse('https://oauth.reddit.com/api/v1/me');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-agent': RedditInfo.userAgent,
    };
    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user information (/api/v1/me)');
    }

    final jsonBody = jsonDecode(response.body);
    Map<String, dynamic> res = {
      'username': jsonBody['name'],
      'description': jsonBody['subreddit']['public_description'],
      'avatarUrl': jsonBody['icon_img'],
      'bannerUrl': jsonBody['subreddit']['banner_img'],
      "subscribers": jsonBody['subreddit']['subscribers'],
      'totalKarma': jsonBody['total_karma'],
      'preferences': jsonBody['pref'],
      'friends': jsonBody['subreddit_friends'],
    };
    return res;
  }
}

Future<Map<String, dynamic>> fetchUserPostSubmitted(username) async {
  final token = await Modular.get<UserRepository>().getToken();
  final url =
      Uri.parse('https://oauth.reddit.com/user/$username/submitted?limit=25');
  final headers = {
    'Authorization': 'Bearer $token',
    'User-agent': RedditInfo.userAgent,
  };
  http.Response response = await http.get(
    url,
    headers: headers,
  );

  if (response.statusCode != 200) {
    throw Exception(
        'Failed to load user information (/user/$username/submitted)');
  }

  final jsonBody = jsonDecode(response.body);
  print("jsonBodyPost $jsonBody");
  for(var i = 0; i < jsonBody['data']['children'].length; i++) {
    print("jsonBodyPost ${jsonBody['data']['children'][i]['data']['title']}");
  }

  return {};
}

