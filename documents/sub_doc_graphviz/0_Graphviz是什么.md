## Graphviz是什么？

`Graphviz（Graph Visualization）`是1990年代初诞生于 `AT&T`的 `Bell实验室`的一个开源的 **（EPL授权）** 、**跨平台** 的 **脚本自动化绘图软件工具** 。

`Graphviz`使用一种称为 `dot`语言的 `DSL(Domain Special Language)`(领域特定语言)语言编写 `Script File脚本文件`，然后使用 `Layout布局引擎`解析这个 `Script File脚本文件`完成 **自动化布局渲染** 。

> `AT&T`是美国三大的电信运营商之一，现在美国的电信运营商行业也是从原 `AT&T`被强行支解后再不断合并后形成群雄逐鹿的竞争局面。
>
> `AT&T`的前身是 `Bell电话公司`，`Bell电话公司`是发明电话的公司。
>
> 在IT软件世界中，`Bell实验室`创造了 `Unix`、`C语言`等一系列伟大的发明。

`Graphviz`脚本文件一般以 `.gv`或 `.dot`为文件扩展名，由于 `Microsoft Office Word`模板文件的扩展名也是 `.dot`，为避免冲突，一般建议 `Graphviz`脚本文件的扩展名保存为 `.gv`。

> **备注： 在Graphviz中，`dot`这个词主要有三种不同的用途：**
>
> 1. `Graphviz`的`Script脚本`的语言名称/语法名称
> 2. `Graphviz`的**其中一种**`Layout`名称，同时也是**其中一种**`CLI`命令名称
> 3. `Graphviz`的**其中一种**`Script File（脚本文件）`常用扩展名

## 概述

Graphviz 是一款开源图形可视化软件。图可视化是将结构信息表示为抽象图和网络图的一种方法。它在网络、生物信息学、软件工程、数据库和网页设计、机器学习以及其他技术领域的视觉界面方面有重要的应用。

Graphviz 布局程序以简单的文本语言描述图形，并以有用的格式(如 web 页面的图像和 SVG)生成图形；PDF 或
Postscript，以供加入其他文件；或显示在交互式图形浏览器中。Graphviz
对于具体图有许多有用的特性，例如颜色、字体、表格节点布局、行样式、超链接和自定义形状的选项。

Graphviz 有 6 个引擎，分别是：

* dot - “层次”或有向图的分层绘图。如果边具有方向性，这是默认使用的工具。
* neato - “spring model” 布局。如果图不是太大(大约 100 个节点)，而且您对它一无所知，那么这是默认的工具。Neato 试图最小化一个全局能量函数，它相当于统计多维尺度。
* fdp - “spring model”的布局类似于neato，但它是通过减少力而不是利用能量来实现的。
* sfdp - fdp 的多尺度版本，用于大图形的布局。
* twopi - 径向布局，after Graham Wills 97。节点被放置在同心圆上，这取决于它们与给定根节点的距离。
* circo - 圆形布局，after Six and Tollis 99, Kauffman and Wiese 02。这适用于多个循环结构的某些图，例如某些电信网络。

## 为什么要使用Graphviz？

1. **自动排版效率更高：**`Graphviz`主要用于绘制“关系图”，`Graphviz`自动排版以使“最小化连线交叉”，`Graphviz`的自动排版比“所见即所得”的绘画软件（如：`Omnigraffle`、`Microsoft Office Visio`等）
2. **文本文件管理更方便：**`VCS(Version Control System版本控制系统)`对“所见即所得”的绘画软件生成的文件无法有效地进行版本管理，而文本文件则可以在`VCS`中有效地被进行版本管理起来
3. **其他自动化绘图工具的基础：**`Graphviz`是其他自动化绘图工具的基础（如`PlantUML`等），也是很多`Data Visualization数据可视化`工具的基础，有点类似于`Python`中`Matplotlib`的作用

## Graphviz的基本组成结构和使用流程

`Graphviz`的基本组成结构包括 `Layout自动化布局工具`和 `Script脚本文件`两部分。

`Script脚本文件`主要包括 `Elements实体`和 `Attributes属性`两部分。

`Elements实体`主要包括 `Graph图`、`Node节点`、`Edge连线`三种类型。

> **备注： 如果需要在软件中调用 `Graphviz`， `Graphviz`还提供了 `C/CPP`、`Java`、`Python`、`php`等语言的 `API`。**

## Graphviz的脚本语法结构

`Graphviz`支持 `digraph（direction graph）有向图`和 `graph无向图`两种图形，脚本的语法非常简单，并且与 `C/CPP`语法类似：

1. **`代码块（图或子图）`：**`{}`包含的语句是代码块
2. **`语句`：** 语句以`;`结尾（可选）、也**不必强制换行** （但为可读性建议换行并以`;`结尾），语句有：`代码块语句`、`节点语句`、`连线语句`、`属性语句`四种
3. **`实体对象标识符`：** 可以是`C/CPP标识符`、`数字`、`字符串`（中文字符串等非英文字符串也可以）、`用单引号或双引号包含的字符串`（用于有`标点字符`或`空白字符`的字符串），总的来说，`Graphviz`的`实体对象标识符`除了`特殊字符`外均是合法的标识符
4. **`注释`：**`//`表示单行注释，`/*...*/`表示多行注释

## Graphviz的三种实体对象和属性

`Graphviz`有三类实体对象，在这些实体上可以定义属性（如：颜色、形状、文本等）：

1. **`G - Graph（图）`：**`Graph`类似于`Container（容器）`的作用，用于容纳`N`和`E`
2. **`N - Node（结点）`：** 相同的标识符被视为同一个节点
3. **`E - Edge（连线）`：** 节点之间的连线

`Graphviz`的实体对象均在首次定义（即：首次出现）时被创建。

## Grpahviz图实体

`Graphviz`语言支持子图，子图中的 `N`和 `E`在不同的代码块中，因此，`Graphviz`的 `Graph`可以细分成三类：

1. **`G - Graph/Main Graph`（图）：** 以`digraph`定义的是`有向图`，以`graph`定义的是`无向图`
2. **`S - Subgraph`（子图）：** 以代码块形式的即是子图（包括不以`cluster`开头定义的`subgraph`代码块），`S`内定义的`N`和`E`公共属性值是代码块内属性值，即超出`S`外，该公共属性值不起作用，`Subgraph`本身没有可显示的属性，`Subgraph`的作用
3. **`C - Cluster Subgraph`（聚集子图）：** 以`cluster`开头定义的`subgraph`代码块，`C`不仅有`S`的容纳代码块内属性值的作用外，在其内定义的`N`还会被渲染在一个子图框内

**子图的类型（有向图还是无向图）与父图相同，子图的名称以 `cluster`开头才被当成聚集子图渲染** 。

```
digraph graph_name{
    bgcolor="transparent";//背景透明
  
    subgraph cluster_subgraph_name{//聚集子图
        node[shape=box];
        cluster_A -> cluster_B;
    }
  
    subgraph subgraph_name{//子图
        node[shape=none];
        sub_A -> sub_B;
    }
  
    {//匿名子图
        node[shape=octagon];
        nest_A -> nest_B;
    }
  
    global_A -> global_B;
  
    cluster_B -> global_B;
    sub_B -> global_B;
    nest_B -> global_B;
}

```

## Grpahviz节点实体之基本节点

`Graphviz`基本节点就是 `节点标识符`加上 `属性限定符“[]”`包围着的可选 `节点属性`，如果基本节点不定义 `label`属性值则将 `节点标识符`作为文本进行显示。

```
digraph gv_ex_basic_node{
    bgcolor="transparent";//背景透明
  
    node_display_this_id;
  
    node_display_label[label="显示\n标签值"];
}

```

## Grpahviz节点实体之HTML节点

Graphviz的 `label`属性支持 `HTML`语法，使用 `HTML`语法时：

1. `node`的`shape`属性设置成`none`
2. `node`的`margin`属性设置成`0`
3. `node`的`label`属性字符串通过尖括号`<...>`包含`HTML语法字符串`定义

**注：HTML节点的 `label`属性值不建议使用引号包含，因为虽然可以被正确渲染，但脚本源码会失去 `语法高亮`的效果**

```
digraph HTML_label_Example
{
  
    bgcolor="transparent";//背景透明
  
    html_ex_node[shape=none, margin=0, label=<
        <table border="0" cellborder="1" cellspacing="0" cellpadding="4">
            <tr>
                <td rowspan="2">test</td>
                <td>a</td>            
                <td rowspan="2">HTML-Like<br/>label</td>
            </tr>
            <tr>
                <td>b</td>
            </tr>
        </table>
    >];
}

```

## Graphviz节点实体之Record节点

当Node的定义为 `shape = record`时，label属性定义了Node的结构，具体为：

* **`...|...`：** 分隔的字符串会在绘制的节点表现为一条分隔符
* **`<...>`：** 定义了锚点（Anchor），锚点可以被引用为edge的起点或终点，引用语法是`${node_id}:${anchor_id}`，即用`:`引用node的anchor
* **`{...}`：** 花括号里定义的分隔符分隔节点将从切换方向排布（原水平分隔将变成垂直分隔，原垂直分隔将变成水平分隔）

## Graphviz的连线实体

`digraph有向图`使用 `->`定义 `Edge`，`graph无向图`使用 `-`定义 `Edge`。
