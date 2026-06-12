# 边属性

您可以在图边上设置的属性

```
边语句示例
```

`edge [name0=val0]` 将默认边属性 name0 设置为 val0。此后出现的任何边都将继承新的默认属性。

`n1 -> n2 [name1=val1]` 或 `n1 -- n2 [name1=val1]` 在节点 n1 和 n2 之间创建有向或无向边，并根据可选列表和边的默认属性设置其属性。

* [arrowhead](https://graphviz.cpp.org.cn/docs/attrs/arrowhead/) – 边头部节点的箭头形状。
* [arrowsize](https://graphviz.cpp.org.cn/docs/attrs/arrowsize/) – 箭头头的乘法缩放系数。
* [arrowtail](https://graphviz.cpp.org.cn/docs/attrs/arrowtail/) – 边尾部节点的箭头形状。
* [class](https://graphviz.cpp.org.cn/docs/attrs/class/) – 附加到节点、边、图或集群的 SVG 元素的类名。仅适用于[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [color](https://graphviz.cpp.org.cn/docs/attrs/color/) – 图形的基本绘制颜色，不包括文本。
* [colorscheme](https://graphviz.cpp.org.cn/docs/attrs/colorscheme/) – 颜色方案命名空间：解释颜色名称的上下文。
* [comment](https://graphviz.cpp.org.cn/docs/attrs/comment/) – 注释插入到输出中。
* [constraint](https://graphviz.cpp.org.cn/docs/attrs/constraint/) – 如果为假，则该边不用于对节点进行排序。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [decorate](https://graphviz.cpp.org.cn/docs/attrs/decorate/) – 是否用线将边标签连接到边。
* [dir](https://graphviz.cpp.org.cn/docs/attrs/dir/) – 用于绘制箭头头的边类型。
* [edgehref](https://graphviz.cpp.org.cn/docs/attrs/edgehref/) –[`edgeURL`](https://graphviz.cpp.org.cn/docs/attrs/edgeURL/) 的同义词。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [edgetarget](https://graphviz.cpp.org.cn/docs/attrs/edgetarget/) – 用于[`edgeURL`](https://graphviz.cpp.org.cn/docs/attrs/edgeURL/) 链接的浏览器窗口。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [edgetooltip](https://graphviz.cpp.org.cn/docs/attrs/edgetooltip/) – 附加到边的非标签部分的工具提示注释。适用于[cmap](https://graphviz.cpp.org.cn/docs/outputs/cmap/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [edgeURL](https://graphviz.cpp.org.cn/docs/attrs/edgeURL/) – 边的非标签部分的链接。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [fillcolor](https://graphviz.cpp.org.cn/docs/attrs/fillcolor/) – 用于填充节点或集群背景的颜色。
* [fontcolor](https://graphviz.cpp.org.cn/docs/attrs/fontcolor/) – 用于文本的颜色。
* [fontname](https://graphviz.cpp.org.cn/docs/attrs/fontname/) – 用于文本的字体。
* [fontsize](https://graphviz.cpp.org.cn/docs/attrs/fontsize/) – 文本使用的字体大小，[以磅为单位](https://graphviz.cpp.org.cn/doc/info/attrs.html#points)。
* [head_lp](https://graphviz.cpp.org.cn/docs/attrs/head_lp/) – 边的头部标签的中心位置。仅用于写入。
* [headclip](https://graphviz.cpp.org.cn/docs/attrs/headclip/) – 如果为真，则边的头部将剪裁到头部节点的边界。
* [headhref](https://graphviz.cpp.org.cn/docs/attrs/headhref/) –[`headURL`](https://graphviz.cpp.org.cn/docs/attrs/headURL/) 的同义词。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [headlabel](https://graphviz.cpp.org.cn/docs/attrs/headlabel/) – 要放置在边头部附近的文本标签。
* [headport](https://graphviz.cpp.org.cn/docs/attrs/headport/) – 指示在头部节点上的哪个位置连接边的头部。
* [headtarget](https://graphviz.cpp.org.cn/docs/attrs/headtarget/) – 用于[`headURL`](https://graphviz.cpp.org.cn/docs/attrs/headURL/) 链接的浏览器窗口。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [headtooltip](https://graphviz.cpp.org.cn/docs/attrs/headtooltip/) – 附加到边头部的工具提示注释。适用于[cmap](https://graphviz.cpp.org.cn/docs/outputs/cmap/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [headURL](https://graphviz.cpp.org.cn/docs/attrs/headURL/) – 如果已定义，则`headURL` 将作为边头部标签的一部分输出。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [href](https://graphviz.cpp.org.cn/docs/attrs/href/) –[`URL`](https://graphviz.cpp.org.cn/docs/attrs/URL/) 的同义词。适用于地图、[postscript](https://graphviz.cpp.org.cn/docs/outputs/ps/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [id](https://graphviz.cpp.org.cn/docs/attrs/id/) – 图对象标识符。适用于地图、[postscript](https://graphviz.cpp.org.cn/docs/outputs/ps/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [label](https://graphviz.cpp.org.cn/docs/attrs/label/) – 附加到对象的文本标签。
* [labelangle](https://graphviz.cpp.org.cn/docs/attrs/labelangle/) – 头部和尾部边标签在极坐标中的角度（以度为单位）。
* [labeldistance](https://graphviz.cpp.org.cn/docs/attrs/labeldistance/) –[`headlabel`](https://graphviz.cpp.org.cn/docs/attrs/headlabel/) /[`taillabel`](https://graphviz.cpp.org.cn/docs/attrs/taillabel/) 与头部/尾部节点的距离的缩放系数。
* [labelfloat](https://graphviz.cpp.org.cn/docs/attrs/labelfloat/) – 如果为真，则允许边标签在位置上不受约束。
* [labelfontcolor](https://graphviz.cpp.org.cn/docs/attrs/labelfontcolor/) – 用于`headlabel` 和`taillabel` 的颜色。
* [labelfontname](https://graphviz.cpp.org.cn/docs/attrs/labelfontname/) –`headlabel` 和`taillabel` 的字体。
* [labelfontsize](https://graphviz.cpp.org.cn/docs/attrs/labelfontsize/) –`headlabel` 和`taillabel` 的字体大小。
* [labelhref](https://graphviz.cpp.org.cn/docs/attrs/labelhref/) –[`labelURL`](https://graphviz.cpp.org.cn/docs/attrs/labelURL/) 的同义词。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [labeltarget](https://graphviz.cpp.org.cn/docs/attrs/labeltarget/) – 打开[`labelURL`](https://graphviz.cpp.org.cn/docs/attrs/labelURL/) 链接的浏览器窗口。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [labeltooltip](https://graphviz.cpp.org.cn/docs/attrs/labeltooltip/) – 附加到边标签的工具提示注释。适用于[cmap](https://graphviz.cpp.org.cn/docs/outputs/cmap/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [labelURL](https://graphviz.cpp.org.cn/docs/attrs/labelURL/) – 如果已定义，则`labelURL` 是用于边标签的链接。适用于地图、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [layer](https://graphviz.cpp.org.cn/docs/attrs/layer/) – 指定节点、边或集群所在的层。
* [len](https://graphviz.cpp.org.cn/docs/attrs/len/) – 首选边长，以英寸为单位。仅适用于[neato](https://graphviz.cpp.org.cn/docs/layouts/neato/)、[fdp](https://graphviz.cpp.org.cn/docs/layouts/fdp/)。
* [lhead](https://graphviz.cpp.org.cn/docs/attrs/lhead/) – 边的逻辑头部。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [lp](https://graphviz.cpp.org.cn/docs/attrs/lp/) – 标签中心位置。仅用于写入。
* [ltail](https://graphviz.cpp.org.cn/docs/attrs/ltail/) – 边的逻辑尾部。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [minlen](https://graphviz.cpp.org.cn/docs/attrs/minlen/) – 最小边长（头部和尾部之间的等级差）。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [nojustify](https://graphviz.cpp.org.cn/docs/attrs/nojustify/) – 是否对齐多行文本（而不是容器的边），而不是前一行文本。
* [penwidth](https://graphviz.cpp.org.cn/docs/attrs/penwidth/) – 指定用于绘制线和曲线的笔宽，以点为单位。
* [pos](https://graphviz.cpp.org.cn/docs/attrs/pos/) – 节点或样条控制点的位置。仅适用于[neato](https://graphviz.cpp.org.cn/docs/layouts/neato/)、[fdp](https://graphviz.cpp.org.cn/docs/layouts/fdp/)。
* [samehead](https://graphviz.cpp.org.cn/docs/attrs/samehead/) – 具有相同头部和相同`samehead` 值的边指向头部上的同一点。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [sametail](https://graphviz.cpp.org.cn/docs/attrs/sametail/) – 具有相同尾部和相同`sametail` 值的边指向尾部上的同一点。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [showboxes](https://graphviz.cpp.org.cn/docs/attrs/showboxes/) – 打印调试引导框。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [style](https://graphviz.cpp.org.cn/docs/attrs/style/) – 设置图形组件的样式信息。
* [tail_lp](https://graphviz.cpp.org.cn/docs/attrs/tail_lp/) – 边尾部标签的位置，[以点为单位](https://graphviz.cpp.org.cn/doc/info/attrs.html#points)。仅用于写入。
* [tailclip](https://graphviz.cpp.org.cn/docs/attrs/tailclip/) – 如果为真，则边的尾部将被剪裁到尾部节点的边界。
* [tailhref](https://graphviz.cpp.org.cn/docs/attrs/tailhref/) –[`tailURL`](https://graphviz.cpp.org.cn/docs/attrs/tailURL/) 的同义词。仅适用于 map、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [taillabel](https://graphviz.cpp.org.cn/docs/attrs/taillabel/) – 要放置在边尾部附近的文本标签。
* [tailport](https://graphviz.cpp.org.cn/docs/attrs/tailport/) – 指示在尾部节点的哪个位置连接边的尾部。
* [tailtarget](https://graphviz.cpp.org.cn/docs/attrs/tailtarget/) – 用于[`tailURL`](https://graphviz.cpp.org.cn/docs/attrs/tailURL/) 链接的浏览器窗口。仅适用于 map、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [tailtooltip](https://graphviz.cpp.org.cn/docs/attrs/tailtooltip/) – 附加到边尾部的工具提示注释。仅适用于[cmap](https://graphviz.cpp.org.cn/docs/outputs/cmap/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [tailURL](https://graphviz.cpp.org.cn/docs/attrs/tailURL/) – 如果已定义，则`tailURL` 将作为边尾部标签的一部分输出。仅适用于 map、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [target](https://graphviz.cpp.org.cn/docs/attrs/target/) – 如果对象具有[`URL`](https://graphviz.cpp.org.cn/docs/attrs/URL/)，则此属性确定使用浏览器的哪个窗口打开 URL。仅适用于 map、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [tooltip](https://graphviz.cpp.org.cn/docs/attrs/tooltip/) – 附加到节点、边、簇或图形的工具提示（鼠标悬停文本）。仅适用于[cmap](https://graphviz.cpp.org.cn/docs/outputs/cmap/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [URL](https://graphviz.cpp.org.cn/docs/attrs/URL/) – 嵌入到设备相关输出中的超链接。仅适用于 map、[postscript](https://graphviz.cpp.org.cn/docs/outputs/ps/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [weight](https://graphviz.cpp.org.cn/docs/attrs/weight/) – 边的权重。
* [xlabel](https://graphviz.cpp.org.cn/docs/attrs/xlabel/) – 节点或边的外部标签。
* [xlp](https://graphviz.cpp.org.cn/docs/attrs/xlp/) – 外部标签的位置，[以点为单位](https://graphviz.cpp.org.cn/doc/info/attrs.html#points)。仅用于写入。
