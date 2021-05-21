import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageViewKeepAlive(),
    ),
  );
}

class PageViewKeepAlive extends StatefulWidget {
  const PageViewKeepAlive({Key key}) : super(key: key);

  @override
  _PageViewKeepAliveState createState() => _PageViewKeepAliveState();
}

class _PageViewKeepAliveState extends State<PageViewKeepAlive> with SingleTickerProviderStateMixin {
  TabController _controller;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this,
    );

    _children = <Widget>[
      for (var i = 0; i < 3; i++) ListViewWidget(index: i),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page View Keep Alive'),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              itemCount: _children.length,
              itemBuilder: (BuildContext context, int index) => _children[index],
            ),
          ),
          const Divider(thickness: 2),
          TabBar(
            controller: _controller,
            tabs: <Tab>[
              Tab(text: 'A'),
              Tab(text: 'B'),
              Tab(text: 'C'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: _children,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({Key key, this.index}) : super(key: key);
  final int index;
  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print('-------build ${widget.index} ---------');
    super.build(context);
    return ListView.builder(
      itemCount: 77,
      itemExtent: 77.77,
      itemBuilder: (BuildContext context, int index) => Center(
        child: Text('$index'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
