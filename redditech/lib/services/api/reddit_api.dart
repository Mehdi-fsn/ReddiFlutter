import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:redditech/constants/reddit_info.dart';
import 'package:redditech/utils/format_date.dart';
import 'package:redditech/services/repositories/user_repository.dart';

abstract class RedditAPI {
  static Future<Map<String, dynamic>> fetchRedditUserInfo() async {
    final token = await Modular.get<UserRepository>().getToken();
    final url = Uri.parse('https://oauth.reddit.com/api/v1/me');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.userAgentHeader: RedditInfo.userAgent,
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
      'avatarUrl': jsonBody['snoovatar_img'],
      "subscribers": jsonBody['subreddit']['subscribers'],
      'totalKarma': jsonBody['total_karma'],
      'preferences': jsonBody['pref'],
      'friends': jsonBody['subreddit_friends'],
    };
    print(res);
    return res;
  }

  static Future<List<Map<String, dynamic>>> fetchUserPostSubmitted(
      {username}) async {
    final token = await Modular.get<UserRepository>().getToken();
    username ??= await Modular.get<UserRepository>().getUsername();
    final url =
        Uri.parse('https://oauth.reddit.com/user/$username/submitted?limit=25');
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.userAgentHeader: RedditInfo.userAgent,
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user posts (/user/$username/submitted)');
    }

    final jsonBody = jsonDecode(response.body);
    final List<Map<String, dynamic>> posts = [];
    for (var i = 0; i < jsonBody['data']['dist']; i++) {
      var date = FormatDate.toDateTime(
          jsonBody['data']['children'][i]['data']['created_utc']);
      Map<String, dynamic> post = {
        'subreddit': jsonBody['data']['children'][i]['data']
            ['subreddit_name_prefixed'],
        'author': 'u/${jsonBody['data']['children'][i]['data']['author']}',
        'title': jsonBody['data']['children'][i]['data']['title'],
        'selfText': jsonBody['data']['children'][i]['data']['selftext'],
        'thumbnail': jsonBody['data']['children'][i]['data']['thumbnail'],
        'score': jsonBody['data']['children'][i]['data']['score'],
        'numComments': jsonBody['data']['children'][i]['data']['num_comments'],
        'createdUtc': date,
      };
      posts.add(post);
    }

    return posts;
  }

  static Future<Map<String, dynamic>> fetchUserPreferences() async {
    final token = await Modular.get<UserRepository>().getToken();
    final url = Uri.parse('https://oauth.reddit.com/api/v1/me/prefs');
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.userAgentHeader: RedditInfo.userAgent,
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user settings (/api/v1/me/prefs)');
    }

    final jsonBody = jsonDecode(response.body);
    Map<String, dynamic> res = {
      'lang': jsonBody['lang'],
      'over_18': jsonBody['over_18'],
      'allow_clicktracking': jsonBody['allow_clicktracking'],
      'show_location_based_recommendations':
          jsonBody['show_location_based_recommendations'],
    };

    print(res);
    return res;
  }

  static Future<bool> updateRedditPreferences(
      Map<String, dynamic> prefs) async {
    final token = await Modular.get<UserRepository>().getToken();
    final url = Uri.parse('https://oauth.reddit.com/api/v1/me/prefs');
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.userAgentHeader: RedditInfo.userAgent,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    http.Response response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode(prefs),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user settings (/api/v1/me/prefs)');
    }

    return true;
  }

  static Future<List<Map<String, dynamic>>> fetchSubReddit(
      {required String type, String? subreddit}) async {
    final token = await Modular.get<UserRepository>().getToken();
    Uri url;
    if (subreddit != null) {
      url = Uri.parse('https://oauth.reddit.com/$subreddit/$type?limit=50');
    } else {
      url = Uri.parse('https://oauth.reddit.com/$type?limit=50');
    }
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.userAgentHeader: RedditInfo.userAgent,
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user posts (/hot|new|top|best)');
    }

    final jsonBody = jsonDecode(response.body);
    final List<Map<String, dynamic>> posts = [];
    for (var i = 0; i < jsonBody['data']['dist']; i++) {
      var date = FormatDate.toDateTime(
          jsonBody['data']['children'][i]['data']['created_utc']);
      Map<String, dynamic> post = {
        'subreddit': jsonBody['data']['children'][i]['data']
            ['subreddit_name_prefixed'],
        'author': 'u/${jsonBody['data']['children'][i]['data']['author']}',
        'title': jsonBody['data']['children'][i]['data']['title'],
        'selfText': jsonBody['data']['children'][i]['data']['selftext'],
        'thumbnail': jsonBody['data']['children'][i]['data']['thumbnail'],
        'score': jsonBody['data']['children'][i]['data']['score'],
        'numComments': jsonBody['data']['children'][i]['data']['num_comments'],
        'createdUtc': date,
      };
      posts.add(post);
    }

    return posts;
  }
}
