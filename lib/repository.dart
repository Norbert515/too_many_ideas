import 'dart:async';
import 'dart:convert';

import 'package:find_your_idea/model/post.dart';
import 'package:http/http.dart' as http;


class Repository {





}


class RedditDataSource {



  Future<List<RedditPost>> getRecentPostsFrom(String subreddit) async {
    // data -> children: List
    var response = await http.get("https://www.reddit.com/r/$subreddit/.json");

    Map<String, dynamic> jsonMap = json.decode(response.body);
    List<dynamic> children = jsonMap["data"]["children"];

    List<RedditPost> redditPosts = [];
    children.forEach((child)=> redditPosts.add(new RedditPost.fromJson(child["data"])));
    return redditPosts;


  }
}