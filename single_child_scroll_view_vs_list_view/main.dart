import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SingleChildScrollViewVSListView(),
    ),
  );
}

class SingleChildScrollViewVSListView extends StatefulWidget {
  const SingleChildScrollViewVSListView({Key? key}) : super(key: key);

  @override
  _SingleChildScrollViewVSListViewState createState() => _SingleChildScrollViewVSListViewState();
}

class _SingleChildScrollViewVSListViewState extends State<SingleChildScrollViewVSListView>
    with SingleTickerProviderStateMixin {
  late TabController _controller = TabController(length: 3, vsync: this);
  late List<Widget> _children;
  late Widget _child;

  final String text = '苏子曰：'
      '“客亦知夫水与月乎？逝者如斯，而未尝往也；'
      '盈虚者如彼，而卒莫消长也。盖将自其变者而观之，则天地曾不能以一瞬；'
      '自其不变者而观之，则物与我皆无尽也，而又何羡乎！'
      '且夫天地之间，物各有主，苟非吾之所有，虽一毫而莫取。'
      '惟江上之清风，与山间之明月，耳得之而为声，目遇之而成色，'
      '取之无禁，用之不竭，是造物者之无尽藏也，而吾与子之所共适。”';

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this,
    );

    _children = <Widget>[
      for (var i = 0; i < 5; i++)
        FlutterLogo(
          size: 50.0 * i,
        ),
      DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.cyan,
        ),
        child: TextExpansion(
          text,
          3,
          style: TextStyle(
            fontSize: 30.0,
          ),
          expansionWidget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: Row(
              children: [
                const Text(
                  '展开',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30.0,
                  ),
                ),
                Icon(Icons.expand_more, color: Colors.black54)
              ],
            ),
          ),
        ),
      ),
    ];

    _child = Column(children: _children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable View'),
      ),
      body: Column(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: TabBar(
              isScrollable: true,
              controller: _controller,
              tabs: [
                Tab(text: 'No Scrollable View'),
                Tab(text: 'SingleChildScrollView'),
                Tab(text: 'ListView'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                _child,
                SingleChildScrollView(
                  child: _child,
                ),
                ListView(
                  children: _children,
                )
              ],
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

/// 更多组件请查看： https://github.com/Nomeleel/awesome_flutter
/// 此组件Demo请看：https://nomeleel.github.io/awesome_flutter/#/text_expansion_view
class TextExpansion extends StatefulWidget {
  const TextExpansion(this.text, this.maxLines, {Key? key, this.maxWidth, required this.style, this.expansionWidget})
      : super(key: key);

  final String text;
  final int maxLines;
  final TextStyle style;
  final double? maxWidth;
  final Widget? expansionWidget;

  @override
  TextExpansionState createState() => TextExpansionState();
}

class TextExpansionState extends State<TextExpansion> {
  bool _expand = false;
  late bool _didExceedMaxLines;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _didExceedMaxLines = didExceedMaxLines();
  }

  bool didExceedMaxLines() {
    final TextPainter textPainter = TextPainter(
      maxLines: widget.maxLines,
      text: TextSpan(
        text: widget.text,
        style: widget.style,
      ),
      textDirection: TextDirection.ltr,
    );
    // 可以获取父容器的宽度，最大不超过屏幕宽度
    textPainter.layout(maxWidth: widget.maxWidth ?? MediaQuery.of(context).size.width);

    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    if (_didExceedMaxLines) {
      if (_expand) {
        return switchWidget(text());
      } else {
        if (widget.expansionWidget == null) {
          return switchWidget(text(widget.maxLines));
        } else {
          return Stack(
            children: [
              text(widget.maxLines),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: switchWidget(widget.expansionWidget!),
              )
            ],
          );
        }
      }
    } else {
      return text();
    }
  }

  Text text([int? maxLines]) {
    return Text(
      widget.text,
      maxLines: maxLines,
      style: widget.style,
    );
  }

  Widget switchWidget(Widget child) {
    return GestureDetector(
      child: child,
      onTap: () {
        setState(() {
          _expand = !_expand;
        });
      },
    );
  }
}
