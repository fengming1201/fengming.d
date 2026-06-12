# 属性类型

关于 [属性](https://graphviz.cpp.org.cn/doc/info/attrs.html) 所期望的模式/类型/语法目录。

以下列表给出了与给定类型的值相对应的合法字符串。描述合法类型字符串的语法混合了字面字符串、stdio 编码（例如，

`%f` 表示双精度浮点数）和正则表达式。对于正则表达式，(...)* 表示 0 个或多个括号中的表达式，(...)+

表示 1 个或多个，而(...)? 表示 0 个或 1 个。

---



#####
[addDouble](https://graphviz.cpp.org.cn/docs/attr-types/addDouble/)

```
            一个可选前缀为 `'+'` 的 [`double`](https://graphviz.cpp.org.cn/docs/attr-types/double/)。


    


  
            ##### 
                [addPoint](https://graphviz.cpp.org.cn/docs/attr-types/addPoint/)
        


            一个可选前缀为 `+` 的 [`point`](https://graphviz.cpp.org.cn/docs/attr-types/point/)。


    


  
            ##### 
                [arrowType](https://graphviz.cpp.org.cn/docs/attr-types/arrowType/)
        


            边箭头形状


    


  
            ##### 
                [bool](https://graphviz.cpp.org.cn/docs/attr-types/bool/)
        


            布尔值；真或假。


    


  
            ##### 
                [clusterMode](https://graphviz.cpp.org.cn/docs/attr-types/clusterMode/)
        


        


    


  
            ##### 
                [color](https://graphviz.cpp.org.cn/docs/attr-types/color/)
        


        


    


  
            ##### 
                [colorList](https://graphviz.cpp.org.cn/docs/attr-types/colorList/)
        


            颜色值列表（可选加权），形成线性渐变


    


  
            ##### 
                [dirType](https://graphviz.cpp.org.cn/docs/attr-types/dirType/)
        


            边箭头方向类型


    


  
            ##### 
                [double](https://graphviz.cpp.org.cn/docs/attr-types/double/)
        


            双精度浮点数


    


  
            ##### 
                [doubleList](https://graphviz.cpp.org.cn/docs/attr-types/doubleList/)
        


            [`double`](https://graphviz.cpp.org.cn/docs/attr-types/double/) 列表


    


  
            ##### 
                [escString](https://graphviz.cpp.org.cn/docs/attr-types/escString/)
        


            带有反斜杠转义序列的字符串


    


  
            ##### 
                [int](https://graphviz.cpp.org.cn/docs/attr-types/int/)
        


            整数


    


  
            ##### 
                [layerList](https://graphviz.cpp.org.cn/docs/attr-types/layerList/)
        


        


    


  
            ##### 
                [layerRange](https://graphviz.cpp.org.cn/docs/attr-types/layerRange/)
        


            由 [`layers`](https://graphviz.cpp.org.cn/docs/attrs/layers/) 属性定义的层列表


    


  
            ##### 
                [lblString](https://graphviz.cpp.org.cn/docs/attr-types/lblString/)
        


            标签字符串


    


  
            ##### 
                [outputMode](https://graphviz.cpp.org.cn/docs/attr-types/outputMode/)
        


            在输出中绘制节点和边的顺序。


    


  
            ##### 
                [packMode](https://graphviz.cpp.org.cn/docs/attr-types/packMode/)
        


            将图组件紧密打包的程度


    


  
            ##### 
                [pagedir](https://graphviz.cpp.org.cn/docs/attr-types/pagedir/)
        


            页面方向


    


  
            ##### 
                [point](https://graphviz.cpp.org.cn/docs/attr-types/point/)
        


            二维（或三维）空间中的几何点


    


  
            ##### 
                [pointList](https://graphviz.cpp.org.cn/docs/attr-types/pointList/)
        


            [`point`](https://graphviz.cpp.org.cn/docs/attr-types/point/) 列表


    


  
            ##### 
                [portPos](https://graphviz.cpp.org.cn/docs/attr-types/portPos/)
        


            端口位置：边应指向节点上的哪个位置


    


  
            ##### 
                [quadType](https://graphviz.cpp.org.cn/docs/attr-types/quadType/)
        


            四叉树方案


    


  
            ##### 
                [rankdir](https://graphviz.cpp.org.cn/docs/attr-types/rankdir/)
        


            绘制有向图的方向（一次一个等级）


    


  
            ##### 
                [rankType](https://graphviz.cpp.org.cn/docs/attr-types/rankType/)
        


            子图中节点的等级约束


    


  
            ##### 
                [rect](https://graphviz.cpp.org.cn/docs/attr-types/rect/)
        


            空间中的几何矩形，由两个 [`point`](https://graphviz.cpp.org.cn/docs/attr-types/point/) 定义


    


  
            ##### 
                [shape](https://graphviz.cpp.org.cn/docs/attr-types/shape/)
        


            节点的 [形状](https://graphviz.cpp.org.cn/doc/info/shapes.html)


    


  
            ##### 
                [smoothType](https://graphviz.cpp.org.cn/docs/attr-types/smoothType/)
        


        


    


  
            ##### 
                [splineType](https://graphviz.cpp.org.cn/docs/attr-types/splineType/)
        


        


    


  
            ##### 
                [startType](https://graphviz.cpp.org.cn/docs/attr-types/startType/)
        


            如何最初布置节点


    


  
            ##### 
                [string](https://graphviz.cpp.org.cn/docs/attr-types/string/)
        


            文本；一系列字符。


    


  
            ##### 
                [style](https://graphviz.cpp.org.cn/docs/attr-types/style/)
        


        


    


  
            ##### 
                [viewPort](https://graphviz.cpp.org.cn/docs/attr-types/viewPort/)
        


            最终绘制的裁剪窗口


    


  
            ##### 
                [xdot](https://graphviz.cpp.org.cn/docs/attr-types/xdot/)
        


            Graphviz `xdot` 语言中的图形操作列表。
```
