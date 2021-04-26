# Flutter Widget Guide
众所周知**Flutter**中一切皆为**Widget**，并且Widget之间还存在着嵌套组合的艺术，每个Widget可以功能单一，又可以将不同的Widget相互组合形成另一个Widget。然而这些Widget组合的结果就是，Weiget个数会成几何倍数增长，现在Widget个数怎么说也有500了吧。(这个是官方对Widget做的分类[Widget Catalog](https://flutter.dev/docs/development/ui/widgets)）。

那么怎么合理的组合Widget形成另一个Widget，官方的**Container**就是一个很好的例子，他很好的将LimitedBox、ConstrainedBox、Align、Padding、ClipPath、DecoratedBox、Transform等Widget组合到了一起，这里可以看下[源码](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/container.dart#L244)感受一下。

无独有偶，实际上官方确实也组合了很多像Container一样好用的Widget。但是，也是因为Widget的可组合性太强了，同一个实现常常会有很多种的组合的方式。这就形成大家很喜欢自己造一些轮子的趋势，虽然也可以完成，但会出现很多相似的Widget。这样后期难以维护，所以建议大家优先使用官方的一些封装好的Widget。当然也有可能是刚入门，渐进式的使用Flutter，对Widget没有一个大概的了解，就不知不觉的走了弯路。

我呢开始也走了不少弯路，一边享受着Widget可以无限嵌套封装的快感，一边感到不知道到底应该选用哪个Widget的困惑。随着慢慢的了解，也渐渐的总结出了不同场景下，应该使用哪些Widget。

在这里把它分享出来，希望大家一起学习，一起探讨。以下都是我自己的主观认知，如有不对，还望指正。

## 概览

**详细可点击链接在官网查看对应Widget的文档以及演示(部分Widget已经有详细演示)**

| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [功能](#演示) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 优选 | 不推荐 | 描述
| :------: | :------: | :------: | ------ |
| 容器 | [Container](https://api.flutter.dev/flutter/widgets/Container-class.html) | LimitedBox、ConstrainedBox、Align、Padding、ClipPath、DecoratedBox、Transform | 功能这么多的Container用起来它不香吗，但是如果你只使用了**一个属性**，例如外边距，还是建议直接使用Padding。 |
| 容器动画 | [AnimatedContainer](https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html) | AnimatedXxxx | 每个属性都有单独的以Animated为前缀的隐式动画实现，但如果想让child使用动画请考虑使用[AnimatedSwitcher](https://api.flutter.dev/flutter/widgets/AnimatedSwitcher-class.html)。 |
| [容器内容居中](#容器内容居中) | 设置[Alignment](https://api.flutter.dev/flutter/painting/Alignment-class.html).**center** | Center | Container中不要再套用Center了，直接设置Alignment为center即可。|
| 比例容器 | [AspectRatio](https://api.flutter.dev/flutter/widgets/AspectRatio-class.html) | 手动计算宽或高 | 比列尽可能写成 2 / 3，而不是0.6667，不仅精度高而且易读。扩展：GridView中item的Size就是通过，副轴长度固定，然后按照比例算出主轴长度，来实现固定布局的。|
| [阴影](#阴影) | [PhysicalModel](https://api.flutter.dev/flutter/widgets/PhysicalModel-class.html)、[Card](https://api.flutter.dev/flutter/material/Card-class.html) | BoxShadow | 有多种实现方式，但是PhysicalModel术业有专工。 |
| 卡片效果 | [Card](https://api.flutter.dev/flutter/material/Card-class.html) | Material | Card的效果其实是使用Material进行了上层封装，想要实现卡片效果，直接使用Card即可。skr～ |
| 圆形头像 | [CircleAvatar](https://api.flutter.dev/flutter/material/CircleAvatar-class.html)、[ClipOval](https://api.flutter.dev/flutter/widgets/ClipOval-class.html) | ClipRRect | ClipRRect更适用于圆角，它的圆形只是一种特殊情况。ClipRRect虽是椭圆，但更常用它的圆形表达形式。CircleAvatar看到名字就不用太多解释了。 |
| 局部刷新 | [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) & [ValueListenable**Builder**](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html) | 自封装StatefulWidget | 多留意后缀是**Builder**的组件，有些功能其实官方已经有了封装，这等小事就不要再去造轮子了。 |
| 布局刷新 | [Layout**Builder**](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html) |  | 👆 可用于Web页面做自适应布局。|
| 方向更改 | [Orientation**Builder**](https://api.flutter.dev/flutter/widgets/OrientationBuilder-class.html) |  | 👆移动设备方向改变触发布局更新。 |
| 单次异步 | [Future**Builder**](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html) |  | 👆 异步只能执行一次。 |
| 多次异步流 | [Stream**Builder**](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html) |  | 👆 可以向数据流中添加多次值，每次接收到数据后便刷新布局。 |
| 自定义动画 | [Animated**Builder**](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html) | AnimatedWidget | 👆 用于构建自定义动画，可以将动画Widget中不需要变化的部分放到child节点，优化动画性能。 |
| 自定义插间动画 | [TweenAnimation**Builder**](https://api.flutter.dev/flutter/widgets/TweenAnimationBuilder-class.html) | AnimatedWidget | 👆 使用与AnimatedBuilder类似，但其只是double类型的插间，而TweenAnimationBuilder可以指定插间类型，例如：Color、Offset、Rect等。 |
| 旋转 | [RotatedBox](https://api.flutter.dev/flutter/widgets/RotatedBox-class.html) | Transform.rotate | Transform旋转前后占用的空间不会变化：[一日] => [丨日]；RotatedBox是先旋转然后应用布局，所以不存在旋转框占用布局：[一日] => [旧] |
| 画布中旋转 | [RotationTransition](https://api.flutter.dev/flutter/widgets/RotationTransition-class.html) | Canvas.rotate在Canvas中旋转 | 可以在CustomPaint的画布上尽情作画，然后将旋转应用到这个Widget上，而不是驱动画布旋转，每次都计算角度偏移再重画一遍。 |
| 分割线 | [Divider](https://api.flutter.dev/flutter/material/Divider-class.html) | Container、Border | 快收起你的奇技淫巧，分割线不用这么麻烦，Divider就够了。如果你想用网格线可以使用[GridPaper](https://api.flutter.dev/flutter/widgets/GridPaper-class.html), 但它限定主线宽1pixel。想自定义线宽的话用这个[GridPaperExp](https://nomeleel.github.io/awesome_flutter/#/grid_paper_exp_view) |
| 透明度 | [Color().withOpacity()](https://api.flutter.dev/flutter/dart-ui/Color/withOpacity.html) | Opacity | 这里主要想说应用透明度，Opacity不是最优选的方式，它有一定的性能成本，可以在[这里](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/basic.dart#L217)查看官方解释。 |
| 按钮 | [ElevatedButton](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)、[TextButton](https://api.flutter.dev/flutter/material/TextButton-class.html)、[OutlinedButton](https://api.flutter.dev/flutter/material/OutlinedButton-class.html)、[IconButton](https://api.flutter.dev/flutter/material/IconButton-class.html)、[CupertinoButton](https://api.flutter.dev/flutter/cupertino/CupertinoButton-class.html) | GestureDetector、InkWell、Listener | 大多数情况下你如果只需要一个点击事件，那以上Widget都可以满足需求，但相对来说体验上会差一些。这时候尽可以使用官方提供好的XxxxButton，这样按下动画、禁用显示灰色等特性就无须再去实现了。 |
| 手势 | [GestureDetector](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html) | RawGestureDetector、Listener | Listener + GestureRecognizer = RawGestureDetector；RawGestureDetector + Common GestureRecognizer = GestureDetector 一般使用GestureDetector，如果预定义的手势不能满足需求，可以直接操作屏幕上监听的点使用Listener，或把这些点抽象成手势，实现对应的手势识别器，赋于RawGestureDetector这就形成了自定义手势。|
| Item固定长度列表 | [ListView(itemExtent: 22.22,)](https://api.flutter.dev/flutter/widgets/ListView-class.html)、[SliverFixedExtentList](https://api.flutter.dev/flutter/widgets/SliverFixedExtentList-class.html) | SliverList | 既然知道了每一项的长度，就不要让容器动态去计算了，这在无限长度的布局中，可以提高不少性能。ListView如果没有设置itemExtent，最终实现就是SliverList，反之就是SliverFixedExtentList。 |
| [固定扩展无限布局](#固定扩展无限布局) | [SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html) | ListView | 如果布局比较固定，只是出现了一些不稳定因子，例如折叠伸缩文字，布局必须可变才能抵消其影响，这时候推荐使用此Widget。而只有在明确布局为无限长度时才推荐使用ListView。[[补充](#固定扩展无限布局)] |
| 主题 | [Theme](https://api.flutter.dev/flutter/material/Theme-class.html) | 没有含义且多次重复的数值、颜色 | 这些数据比较分散，集中取值便于管理，更便于修改。界面的风格统一比内容更重要。 |
| [弹性布局](#弹性布局) | [Flex](https://api.flutter.dev/flutter/widgets/Flex-class.html)、[Column](https://api.flutter.dev/flutter/widgets/Column-class.html)、[Row](https://api.flutter.dev/flutter/widgets/Row-class.html) |  | 我们有必要先看一下，他们之前的关系结构，然后再去考虑选择使用哪一个Widget。[关系](#弹性布局)] |
| [填充弹性布局](#弹性布局) | [Flexible](https://api.flutter.dev/flutter/widgets/Flexible-class.html)、[Expanded](https://api.flutter.dev/flutter/widgets/Expanded-class.html)、[Spacer](https://api.flutter.dev/flutter/widgets/Spacer-class.html) |  | 👆 |
| 待续 |  |  |  |

## 演示

### 容器内容居中

[动手尝试一波](https://nomeleel.github.io/flutter_widget_guide/container_text_centered/index.html)

```dart
// 👍
Container(
  color: Colors.purple,
  alignment: Alignment.center,
  child: Text(text),
)

// 🙅‍♂️     
Container(
  color: Colors.blue,
  child: Center(
    child: Text(text),
  ),
)
```

### 阴影

[动手尝试一波](https://nomeleel.github.io/flutter_widget_guide/physical_model_card_shadow/index.html)

<div align="center">
    <img src="assets/screenshot/physical_model_card_shadow.png" />
</div>

```dart
// 👍
PhysicalModel(
  color: Colors.grey,
  elevation: 10.0,
  shadowColor: Colors.grey[900],
  clipBehavior: Clip.hardEdge,
  borderRadius: borderRadius,
  child: child,
)

// 👍
Card(
  color: Colors.grey,
  elevation: 10.0,
  shadowColor: Colors.grey[900],
  clipBehavior: Clip.hardEdge,
  shape: RoundedRectangleBorder(
    borderRadius: borderRadius,
  ),
  child: child,
)

// 🙅‍♂️ 
Container(
  clipBehavior: Clip.hardEdge,
  decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: borderRadius,
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.grey,
        offset: Offset(2.0, 8.0),
        blurRadius: 10.0,
      )
    ],
  ),
  child: child,
),

```

### 固定扩展无限布局

[动手尝试一波](https://nomeleel.github.io/flutter_widget_guide/single_child_scroll_view_vs_list_view/index.html)

**可以看到SingleChildScrollView在再次折叠文字后变为固定布局，页面便不可以滚动。而在成为滚动布局后，行为与ListView基本一致，比如Android溢出有水波纹，iOS溢出弹簧性显示。**

<div align="center">
    <img src="assets/screenshot/single_child_scroll_view_vs_list_view/no_scrollable_view.gif" width="30%"/>
    <img src="assets/screenshot/single_child_scroll_view_vs_list_view/single_child_scroll_view_ios.gif" width="30%"/>
    <img src="assets/screenshot/single_child_scroll_view_vs_list_view/list_view_ios.gif" width="30%"/>
</div>
<div align="center">
    <img src="assets/screenshot/single_child_scroll_view_vs_list_view/single_child_scroll_view_android.gif" width="30%"/>
    <img src="assets/screenshot/single_child_scroll_view_vs_list_view/list_view_android.gif" width="30%"/>
</div>

```dart
_child = Column(children: _children);

// 👍
SingleChildScrollView(
  child: _child,
),

// 🙅‍♂️ 
ListView(
  children: _children,
)

// 🙅‍♂️ 
_child

```

### 弹性布局

[Flex](https://api.flutter.dev/flutter/widgets/Flex-class.html)、[Column](https://api.flutter.dev/flutter/widgets/Column-class.html)、[Row](https://api.flutter.dev/flutter/widgets/Row-class.html)

```dart
class Row extends Flex {
  Row({
    Key? key,
    ...
    List<Widget> children = const <Widget>[],
  }) : super(
    children: children,
    key: key,
    direction: Axis.horizontal, // 这里确定了水平方向
    ...
  );
}

// 看了Row，那闭着眼睛就知道Column肯定设置了Axis.vertical垂直方向。

```

**所以当布局水平、垂直显示方向不确定时，例如手机由竖屏切换到横屏，原本的Column就变成了Row，这时候就应该使用Flex，然后根据当前方向指定direction属性。**

[Flexible](https://api.flutter.dev/flutter/widgets/Flexible-class.html)、[Expanded](https://api.flutter.dev/flutter/widgets/Expanded-class.html)、[Spacer](https://api.flutter.dev/flutter/widgets/Spacer-class.html)

```dart
class Expanded extends Flexible {
  const Expanded({
    Key? key,
    int flex = 1,
    required Widget child,
  }) : super(key: key, flex: flex, fit: FlexFit.tight, child: child); // 这里设定了FlexFit.tight紧约束
}

//----------------------------------------------

class Spacer extends StatelessWidget {
  const Spacer({Key? key, this.flex = 1}) : super(key: key);

  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded( // 这里直接返回了包了一个最小SizedBox的Expanded。
      flex: flex,
      child: const SizedBox.shrink(),
    );
  }
}

//----------------------------------------------

const SizedBox.shrink({ Key? key, Widget? child })
  : width = 0.0,
    height = 0.0,
    super(key: key, child: child);

//----------------------------------------------

enum MainAxisAlignment {
  start,
  end,
  center,
  // 以下是三种用来填充空白的方式
  spaceBetween,
  spaceAround,
  spaceEvenly,
}
```

**所以如果子节点想要使用紧约束(紧约束这里可以理解为child会被强制占满整个空白，松约束就是child可以在零和最大约束之间使用自己的大小，不会被强制占满空白)，就使用Expanded。想要随时调整约束就用Flexible。**

**如果你只是想填充弹性布局中固定子节点之外剩余的空白，可以直接使用已经封装好的弹性空白组件Spacer。但或许你可以直接使用MainAxisAlignment来组织空白空间去控制固定子节点的排列方式。**