# Flutter Widget Guide
众说周知**Flutter**中一切皆为**Widget**，并且Widget之间还存在着嵌套组合的艺术，每个Widget可以功能单一，又可以将不同的Widget相互组合形成另一个Widget。然而这些Widget组合的结果就是，Weiget个数会成几何倍数增长，现在Widget个数怎么说也有500了吧。(这个是官方对Widget做的分类[Widget Catalog](https://flutter.dev/docs/development/ui/widgets)）。

那么怎么合理的组合Widget形成另一个Widget，官方的**Container**就是一个很好的例子，他很好的将LimitedBox、ConstrainedBox、Align、Padding、ClipPath、DecoratedBox、Transform等Widget组合到了一起，这里可以看下[源码](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/container.dart#L244)感受一下。

无独有偶，实际上官方确实也组合了很多像Container一样好用的Widget。但是，也是因为Widget的可组合性太强了，同一个实现常常会有很多种的组合的方式。这就形成大家很喜欢自己造一些轮子的趋势，虽然也可以完成，但会出现很多相似的Widget。这样后期难以维护，所以建议大家优先使用官方的一些封装好的Widget。当然也有可能是刚入门，渐进式的使用Flutter，对Widget没有一个大概的了解，就不知不觉的走了弯路。

我呢开始也走了不少弯路，一边享受着Widget可以无限嵌套封装的快感，一边感到不知道到底应该选用哪个Widget的困惑。随着慢慢的了解，也渐渐的总结出了不同场景下，应该使用哪些Widget。

在这里把它分享出来，希望大家一起学习，一起探讨。以下都是我自己的主观认知，如有不对，还望指正。

# 概览

<div>
<iframe src="https://dartpad.dev/embed-flutter.html?gh_owner=Nomeleel&gh_repo=flutter_widget_guide&gh_path=container_text_centered&theme=dark&run=true&split=60" style="width: 100%; height: 600px;"></iframe>
</div>
