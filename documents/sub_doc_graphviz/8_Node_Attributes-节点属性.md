# 节点属性

您可以为图节点设置的属性

```
节点语句示例
```

`node [name0=val0]` — 将默认节点属性 name0 设置为 val0。此后出现的任何节点都将继承新的默认属性。

`n0 [name1=val1]` — 创建节点 n0 并根据可选列表和节点的默认属性设置其属性。

* [class](https://graphviz.cpp.org.cn/docs/attrs/class/) – 附加到节点、边、图或集群的 SVG 元素的类名。仅适用于[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [area](https://graphviz.cpp.org.cn/docs/attrs/area/) – 指示节点或空集群的首选区域。仅适用于[patchwork](https://graphviz.cpp.org.cn/docs/layouts/patchwork/)。
* [class](https://graphviz.cpp.org.cn/docs/attrs/class/) – 附加到节点、边、图或集群的 SVG 元素的类名。仅适用于[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [color](https://graphviz.cpp.org.cn/docs/attrs/color/) – 图形的基本绘制颜色，而不是文本颜色。
* [colorscheme](https://graphviz.cpp.org.cn/docs/attrs/colorscheme/) – 颜色方案命名空间：用于解释颜色名称的上下文。
* [comment](https://graphviz.cpp.org.cn/docs/attrs/comment/) – 注释将插入输出。
* [distortion](https://graphviz.cpp.org.cn/docs/attrs/distortion/) –`<a href="https://graphviz.cpp.org.cn/docs/attrs/shape/">shape</a>=<a href="https://graphviz.cpp.org.cn/doc/info/shapes.html#polygon">polygon</a>` 的失真因子。
* [fillcolor](https://graphviz.cpp.org.cn/docs/attrs/fillcolor/) – 用于填充节点或集群背景的颜色。
* [fixedsize](https://graphviz.cpp.org.cn/docs/attrs/fixedsize/) – 是否使用指定的宽度和高度属性来选择节点大小（而不是调整大小以适合节点内容）。
* [fontcolor](https://graphviz.cpp.org.cn/docs/attrs/fontcolor/) – 用于文本的颜色。
* [fontname](https://graphviz.cpp.org.cn/docs/attrs/fontname/) – 用于文本的字体。
* [fontsize](https://graphviz.cpp.org.cn/docs/attrs/fontsize/) – 文本使用的字体大小，[以磅为单位](https://graphviz.cpp.org.cn/doc/info/attrs.html#points)。
* [gradientangle](https://graphviz.cpp.org.cn/docs/attrs/gradientangle/) – 如果使用渐变填充，则这将确定填充的角度。
* [group](https://graphviz.cpp.org.cn/docs/attrs/group/) – 节点组的名称，用于捆绑边以避免交叉。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [height](https://graphviz.cpp.org.cn/docs/attrs/height/) – 节点高度，以英寸为单位。
* [href](https://graphviz.cpp.org.cn/docs/attrs/href/) –[`URL`](https://graphviz.cpp.org.cn/docs/attrs/URL/) 的同义词。仅适用于 map、[postscript](https://graphviz.cpp.org.cn/docs/outputs/ps/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [id](https://graphviz.cpp.org.cn/docs/attrs/id/) – 图对象标识符。仅适用于 map、[postscript](https://graphviz.cpp.org.cn/docs/outputs/ps/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [image](https://graphviz.cpp.org.cn/docs/attrs/image/) – 给出包含要显示在节点内的图像的文件的名称。
* [imagepos](https://graphviz.cpp.org.cn/docs/attrs/imagepos/) – 控制图像在其包含节点内的位置。
* [imagescale](https://graphviz.cpp.org.cn/docs/attrs/imagescale/) – 控制图像如何填充其包含节点。
* [label](https://graphviz.cpp.org.cn/docs/attrs/label/) – 附加到对象的文本标签。
* [labelloc](https://graphviz.cpp.org.cn/docs/attrs/labelloc/) – 节点、根图和集群的标签的垂直放置位置。
* [layer](https://graphviz.cpp.org.cn/docs/attrs/layer/) – 指定节点、边或集群存在的层。
* [margin](https://graphviz.cpp.org.cn/docs/attrs/margin/) – 对于图，这将设置画布的 x 和 y 边距，以英寸为单位。
* [nojustify](https://graphviz.cpp.org.cn/docs/attrs/nojustify/) – 是否对齐多行文本与前一行文本（而不是容器的边）。
* [ordering](https://graphviz.cpp.org.cn/docs/attrs/ordering/) – 约束节点边的左右排序。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [orientation](https://graphviz.cpp.org.cn/docs/attrs/orientation/) – 节点形状旋转角度或图形方向。
* [penwidth](https://graphviz.cpp.org.cn/docs/attrs/penwidth/) – 指定用于绘制线条和曲线的笔的宽度，以磅为单位。
* [peripheries](https://graphviz.cpp.org.cn/docs/attrs/peripheries/) – 设置多边形形状和集群边界中使用的外围数。
* [pin](https://graphviz.cpp.org.cn/docs/attrs/pin/) – 将节点保持在节点给定的输入位置。仅适用于[neato](https://graphviz.cpp.org.cn/docs/layouts/neato/)、[fdp](https://graphviz.cpp.org.cn/docs/layouts/fdp/)。
* [pos](https://graphviz.cpp.org.cn/docs/attrs/pos/) – 节点的位置或样条控制点。仅适用于[neato](https://graphviz.cpp.org.cn/docs/layouts/neato/)、[fdp](https://graphviz.cpp.org.cn/docs/layouts/fdp/)。
* [rects](https://graphviz.cpp.org.cn/docs/attrs/rects/) – 记录字段的矩形，[以磅为单位](https://graphviz.cpp.org.cn/doc/info/attrs.html#points)。仅用于写入。
* [regular](https://graphviz.cpp.org.cn/docs/attrs/regular/) – 如果为真，则强制多边形为规则的。
* [root](https://graphviz.cpp.org.cn/docs/attrs/root/) – 指定用作布局中心的节点。仅适用于[twopi](https://graphviz.cpp.org.cn/docs/layouts/twopi/)、[circo](https://graphviz.cpp.org.cn/docs/layouts/circo/)。
* [samplepoints](https://graphviz.cpp.org.cn/docs/attrs/samplepoints/) – 给出用于圆形/椭圆形节点的点数。
* [shape](https://graphviz.cpp.org.cn/docs/attrs/shape/) – 设置节点的[形状](https://graphviz.cpp.org.cn/doc/info/shapes.html)。
* [shapefile](https://graphviz.cpp.org.cn/docs/attrs/shapefile/) – 包含用户提供的节点内容的文件。
* [showboxes](https://graphviz.cpp.org.cn/docs/attrs/showboxes/) – 打印用于调试的指南框。仅适用于[dot](https://graphviz.cpp.org.cn/docs/layouts/dot/)。
* [sides](https://graphviz.cpp.org.cn/docs/attrs/sides/) – 当 `<a href="https://graphviz.cpp.org.cn/docs/attrs/shape/">shape</a>=polygon` 时的边数。
* [skew](https://graphviz.cpp.org.cn/docs/attrs/skew/) –`<a href="https://graphviz.cpp.org.cn/docs/attrs/shape/">shape</a>=polygon` 的倾斜因子。
* [sortv](https://graphviz.cpp.org.cn/docs/attrs/sortv/) – 图组件的排序顺序，用于对[`packmode`](https://graphviz.cpp.org.cn/docs/attrs/packmode/) 打包进行排序。
* [style](https://graphviz.cpp.org.cn/docs/attrs/style/) – 设置图组件的样式信息。
* [target](https://graphviz.cpp.org.cn/docs/attrs/target/) – 如果对象有[`URL`](https://graphviz.cpp.org.cn/docs/attrs/URL/)，则此属性确定浏览器使用的哪个窗口。仅适用于 map、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [tooltip](https://graphviz.cpp.org.cn/docs/attrs/tooltip/) – 附加到节点、边、集群或图的工具提示（鼠标悬停文本）。仅适用于[cmap](https://graphviz.cpp.org.cn/docs/outputs/cmap/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [URL](https://graphviz.cpp.org.cn/docs/attrs/URL/) – 融入设备相关输出的超链接。仅适用于 map、[postscript](https://graphviz.cpp.org.cn/docs/outputs/ps/)、[svg](https://graphviz.cpp.org.cn/docs/outputs/svg/)。
* [vertices](https://graphviz.cpp.org.cn/docs/attrs/vertices/) – 设置节点多边形的顶点坐标，以英寸为单位。仅用于写入。
* [width](https://graphviz.cpp.org.cn/docs/attrs/width/) – 节点宽度，以英寸为单位。
* [xlabel](https://graphviz.cpp.org.cn/docs/attrs/xlabel/) – 节点或边的外部标签。
* [xlp](https://graphviz.cpp.org.cn/docs/attrs/xlp/) – 外部标签的位置，[以磅为单位](https://graphviz.cpp.org.cn/doc/info/attrs.html#points)。仅用于写入。
* [z](https://graphviz.cpp.org.cn/docs/attrs/z/) – 用于 3D 布局和显示的 Z 坐标值。
