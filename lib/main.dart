import 'dart:async';

import 'package:find_your_idea/filter_input.dart';
import 'package:find_your_idea/list_item.dart';
import 'package:find_your_idea/model/post.dart';
import 'package:find_your_idea/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  FocusNode focusNode;

  ScrollController controller = new ScrollController();

  final double loadMoreThreshold = 200.0;

  bool isLoading = false;

  Repository repository = new Repository();

  List<FilterItem> filter = [];

  bool showFastScrollUp = false;

  int allItemsCount = 0;
  int filteredItemsCount = 0;

  @override
  void initState() {
    super.initState();
    focusNode = new FocusNode();

    repository.load();


    controller.addListener(() {
      if(controller.offset > controller.position.maxScrollExtent - loadMoreThreshold) {
        _loadMore();
      }

      if(controller.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          showFastScrollUp = true;
        });
      } else {
        setState(() {
          showFastScrollUp = false;
        });
      }
    });
  }




  void _loadMore() {
    if(!isLoading) {
      setState(() {
        isLoading = true;
      });
      repository.load().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }


  @override
  void dispose() {
    focusNode.dispose();
    repository.dispose();
    controller.dispose();
    super.dispose();
  }

  
  
  void _scrollUp() {
    controller.animateTo(0.0, duration: const Duration(milliseconds: 900), curve: Curves.decelerate);
    setState(() {
      showFastScrollUp = false;
    });
  }

  void _onFilterSettingsChanged(List<FilterItem> items) {
    setState(() {
      filter = items;
    });
  }
  

  bool _shouldKeepItem(RedditPost post) {
    if(filter.isEmpty) return true;
    String regexString = filter.map((filterItem)=> filterItem.text).join("|");
    if(post.title.contains(new RegExp(regexString)) || post.selftext.contains(new RegExp(regexString))) {
      return true;
    }
    return false;
  }

  List<RedditPost> _filter(List<RedditPost> posts) {
    return posts.where(_shouldKeepItem).toList();
  }
  List<RedditPost> _filter2(List<RedditPost> posts) {
    List<RedditPost> result = [];
    for(RedditPost post in posts) {
      if(_shouldKeepItem(post)) {
        result.add(post);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        leading: new Text("$allItemsCount/$filteredItemsCount"),
      ),
      body: new FastScrollTop(
        visible: showFastScrollUp,
        onClick: _scrollUp,
        child: new CustomScrollView(
          slivers: <Widget>[
            //TODO maybe sliver app bar? No but overscroll!!
            new SliverToBoxAdapter(
              child: new FilterInput(
                onFilterSettingsChanged: _onFilterSettingsChanged,
              ),
            ),
            new StreamBuilder<List<RedditPost>>(
              stream: repository.getPostStream(),
              builder: (BuildContext context, AsyncSnapshot<List<RedditPost>> snapshot) {
                allItemsCount = snapshot.data?.length ?? 0;
                List<RedditPost> items = _filter2(snapshot.data ?? const []);
                filteredItemsCount = items.length;
                WidgetsBinding.instance.addPostFrameCallback((_){
                  setState((){});
                });
                return new SliverList(delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
                  return new InkWell(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
                        return new ListItemPage(
                          title: items[index].title,
                          subtitle: items[index].selftext,
                          source: items[index].permalink,
                        );
                      }));
                    },
                      child: new ListItem(title: items[index].title, subtitle: items[index].selftext,)
                  );

                }, childCount: items != null ? items.length : 0));
              },
            ),
            new SliverToBoxAdapter(
              child: isLoading? new Center(child: new CircularProgressIndicator()) :new MaterialButton(child: new Text("load more"), onPressed: _loadMore,),
            )
          ],
          controller: controller,
        ),
      ),
    );
  }
}


class FastScrollTop extends StatefulWidget {

  final bool visible;

  final Widget child;

  final VoidCallback onClick;

  const FastScrollTop({Key key, this.visible, this.child, this.onClick}) : super(key: key);

  @override
  _FastScrollTOpState createState() => new _FastScrollTOpState();
}

class _FastScrollTOpState extends State<FastScrollTop> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        widget.child,
        widget.visible ? new Positioned(
            top: 10.0,
            bottom:  null,
            left: 0.0,
            right: 0.0,
            child: new Center(
              child: new MaterialButton(
                onPressed: widget.onClick,
                color: Colors.red,
                child: new Text("Scroll up"),
              ),
            )
        ): new SizedBox()
      ],
    );
  }
}
