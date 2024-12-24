# 图形用户界面（GUI）中的三个概念：桌面环境（DE）、窗口管理器（WM）、显示管理器（DM）

桌面环境（DE）：

桌面环境是最上层的图形用户界面，为用户提供了一个集成的、直观的桌面体验。DE通常包含窗口管理器、文件管理器、面板、系统托盘、启动器、图标、主题、壁纸等元素，以及一系列预装的应用程序，如文本编辑器、终端仿真器、邮件客户端等。流行的桌面环境包括 GNOME、KDE Plasma、XFCE、Cinnamon 等。桌面环境为用户提供了一个全面的、易于使用的界面，适用于不同水平的用户。

窗口管理器（WM）：

窗口管理器是桌面环境的一个组成部分，负责管理图形界面中各个窗口的显示、移动、调整大小和关闭等操作。它负责处理窗口的外观、布局和交互，使用户可以通过鼠标和键盘与窗口进行交互。窗口管理器通常提供窗口标题栏、边框和控制按钮（最小化、最大化、关闭等），同时还支持窗口的层叠、平铺和堆叠等布局方式。一些流行的窗口管理器包括 Metacity、KWin、Openbox、i3 等。

显示管理器（DM）：

显示管理器是启动时出现的登录界面，它提供了一个用户登录到图形桌面环境的方式。当计算机启动时，显示管理器负责呈现一个登录屏幕，用户可以在该屏幕上输入用户名和密码，选择桌面环境，然后会话将启动并加载相应的桌面环境。显示管理器简化了用户登录过程，同时还支持多个用户账号。常见的显示管理器包括 GDM（GNOME Display Manager）、LightDM、SDDM（Simple Desktop Display Manager）等。

三者关系：

WM 是 DE 的一部分，负责处理窗口的布局、外观和交互。

DM 是用户登录到桌面环境的入口。它出现在计算机启动时，用户选择桌面环境后，DM 会加载相应的 DE 和 WM 相关程序。

# linux下有哪些显示协议？

在 Linux 和类 Unix 系统中，主要的显示协议及其实现有：

### 1. **X11 (X Window System)**

* **实现** :
  * **Xorg** : 最常用的 X11 实现，支持广泛的硬件和软件。
  * **XFree86** : Xorg 的前身，现在已不再广泛使用。

### 2. **Wayland**

* **实现** :
  * **Weston** : Wayland 的参考实现，主要用于测试和开发。
  * **Mutter** : GNOME 的窗口管理器，支持 Wayland。
  * **KWin** : KDE 的窗口管理器，也支持 Wayland。
  * **Sway** : 类似 i3 的平铺窗口管理器，专为 Wayland 设计。

### 3. **Mir**

* **实现** :
  * **Mir** : 由 Canonical 开发，支持 Wayland 协议，曾用于 Ubuntu Touch。

这些协议和实现为 Linux 和类 Unix 系统提供了丰富的图形界面选择，满足不同的使用需求和环境。