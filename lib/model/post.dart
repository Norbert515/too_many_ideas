

class RedditPost {


  final String title;
  final String subreddit;
  final String selftext;
  final String name;
  final String id;
  final int thumbnail_width;
  final int thumbnail_height;
  //TODO check self or url
  final String thumbnail;

  //Needs to add www.reddit.com before
  final String permalink;


  final String url;


  RedditPost.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        subreddit = json['subreddit'],
        selftext = json['selftext'],
        name = json['name'],
        id = json['id'],
        thumbnail_width = json['thumbnail_width'],
        thumbnail_height = json['thumbnail_height'],
        thumbnail = json['thumbnail'],
        permalink = json['permalink'],
        url = json['url'];




}