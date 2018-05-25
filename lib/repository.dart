import 'dart:async';
import 'dart:convert';

import 'package:find_your_idea/model/post.dart';
import 'package:http/http.dart' as http;


class Repository {


  List<RedditPost> posts = [];

  RedditDataSource crazyIdeas = new RedditDataSource("CrazyIdeas");
  RedditDataSource appIdeas = new RedditDataSource("AppIdeas");
  RedditDataSource startupIdeas = new RedditDataSource("Startup_Ideas");
  RedditDataSource lightbulb = new RedditDataSource("Lightbulb");

  StreamController<List<RedditPost>> streamController = new StreamController();


  int redditToLoadFrom = 1;

  Future<Null> load() async {
    List<RedditPost> redditPosts;

    switch(redditToLoadFrom) {
      case 0:  redditPosts = await crazyIdeas.getPosts(25);
        redditToLoadFrom = 1;
        break;
      case 1:  redditPosts = await appIdeas.getPosts(25);
        redditToLoadFrom = 2;
        break;
      case 2:  redditPosts = await startupIdeas.getPosts(25);
        redditToLoadFrom = 3;
        break;
      case 3:  redditPosts = await lightbulb.getPosts(25);
        redditToLoadFrom = 0;
        break;
    }


    posts.addAll(redditPosts);
    streamController.add(posts);
  }


  void reset() {
    redditToLoadFrom = 0;
    posts = [];
  }


  void dispose() {
    streamController.close();
  }


  Stream<List<RedditPost>> getPostStream() {
    return streamController.stream;
  }




}


class RedditDataSource {

  String afterID;
  final String subreddit;

  RedditDataSource(this.subreddit);



  Future<List<RedditPost>> getPosts(int count) async {
    String afterQuery = afterID == null ? "?count=$count": "?count=$count&after=$afterID";
    var response = await http.get("https://www.reddit.com/r/$subreddit/.json$afterQuery");

    Map<String, dynamic> jsonMap = json.decode(response.body);
    afterID = jsonMap["data"]["after"];
    List<dynamic> children = jsonMap["data"]["children"];

    List<RedditPost> redditPosts = [];
    children.forEach((child)=> redditPosts.add(new RedditPost.fromJson(child["data"])));
    return redditPosts;


  }
}