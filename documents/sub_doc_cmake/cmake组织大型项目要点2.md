对于大型项目，使用 CMake 组织构建系统时，通常会采用**模块化、分层**的目录结构。每个功能模块独立管理自己的构建规则，通过顶层 `CMakeLists.txt` 统一协调。这种结构不仅使项目易于维护，还支持按需编译、测试和打包。

以下是一个典型的大型项目目录层级结构示例：

```
project-root/
├── CMakeLists.txt                  # 顶层构建脚本
├── cmake/                          # 自定义 CMake 模块、查找脚本、工具链文件等
│   ├── FindXXX.cmake
│   ├── ProjectConfig.cmake.in
│   └── CompilerOptions.cmake
├── include/                        # 对外公开的头文件（通常按命名空间组织）
│   └── project_name/
│       ├── module1/
│       │   └── public_header.h
│       └── module2/
├── src/                            # 核心源代码（库的实现）
│   ├── module1/
│   │   ├── CMakeLists.txt          # 模块1的构建脚本
│   │   └── *.cpp
│   ├── module2/
│   │   ├── CMakeLists.txt
│   │   └── *.cpp
│   └── CMakeLists.txt              # 可选，用于聚合各模块
├── apps/ 或 tools/                 # 可执行程序（应用、命令行工具等）
│   ├── app1/
│   │   ├── CMakeLists.txt
│   │   └── main.cpp
│   └── app2/
├── libs/                           # 项目内部的独立库（若与 src 分离）
│   ├── libA/
│   │   ├── CMakeLists.txt
│   │   ├── include/
│   │   └── src/
│   └── libB/
├── tests/                          # 测试代码
│   ├── CMakeLists.txt
│   ├── unit/                       # 单元测试
│   └── integration/                # 集成测试
├── examples/                       # 示例代码，展示库的用法
│   ├── CMakeLists.txt
│   └── example1/
├── docs/                           # 文档（可选）
├── external/ 或 third_party/       # 第三方依赖（源码、子模块、预编译库等）
│   └── ...
├── scripts/                        # 辅助脚本（打包、代码生成等）
└── config/                         # 配置文件（可选）
```

---

### 各目录的作用与设计要点

1. **顶层 `CMakeLists.txt`**  
   - 定义项目名称、版本、语言标准、编译选项等全局设置。  
   - 通过 `add_subdirectory()` 按需添加各个子目录。  
   - 查找外部依赖（`find_package`）或包含第三方子项目。  
   - 生成配置头文件（如 `config.h`），供代码使用。  
   - 设置安装规则（`install`）和导出目标（`export`）。

2. **`cmake/` 目录**  
   存放自定义 CMake 模块（`.cmake` 文件），例如：
   - 查找非标准依赖的 `FindXXX.cmake`。  
   - 定义可复用的函数和宏（如设置编译警告、处理平台差异）。  
   - 工具链文件（交叉编译时使用）。  
   这些脚本通过 `list(APPEND CMAKE_MODULE_PATH ...)` 引入。

3. **`include/` 目录**  
   存放库对外的公开头文件。通常按照 `include/<项目名>/<模块名>/` 的结构组织，以避免头文件命名冲突，并方便使用者 `#include <project_name/module1/xxx.h>`。

4. **`src/` 和 `libs/` 目录**  
   - `src/` 常用于存放核心库的实现，每个模块一个子目录，有自己的 `CMakeLists.txt`，定义静态库或动态库目标。  
   - `libs/` 可用于放置相对独立的内部库（例如通用工具库），与 `src/` 分离，使结构更清晰。  
   每个库目标通过 `target_include_directories` 指定头文件搜索路径（`PUBLIC`、`PRIVATE`、`INTERFACE`），通过 `target_link_libraries` 声明依赖关系。

5. **`apps/` 或 `tools/`**  
   包含可执行程序（例如主程序、命令行工具）。每个可执行文件通常有自己的子目录和 `CMakeLists.txt`，并链接到 `src/` 或 `libs/` 中的库。

6. **`tests/`**  
   测试代码独立于生产代码，可细分为单元测试、集成测试等。通常集成 CTest，并可通过顶层 `enable_testing()` 和 `add_test()` 注册测试。测试目录也通过 `add_subdirectory` 纳入构建（可通过选项控制是否构建）。

7. **`examples/`**  
   提供示例程序，展示如何使用项目中的库。这些示例也会被编译，但通常不随库一起安装。

8. **`external/` 或 `third_party/`**  
   管理第三方依赖的多种方式：
   - 存放第三方源码（例如 git submodule），并在 CMake 中用 `add_subdirectory` 将其作为子项目构建。  
   - 存放预编译的库和头文件，通过 `find_library` 或 `find_package` 引用。  
   - 使用 `FetchContent` 或 `ExternalProject` 在构建时下载依赖。  
   这一目录使依赖与自身代码隔离，便于维护和升级。

9. **`scripts/` 和 `docs/`**  
   辅助脚本（如打包、CI 脚本）和文档，不直接参与编译，但有助于项目管理。

---

### 现代 CMake 实践中的关键点

- **目标导向**：避免使用全局变量（如 `include_directories`、`link_libraries`），而是为每个库/可执行文件创建目标，并用 `target_*` 命令管理其属性和依赖。  
- **可见性控制**：使用 `PUBLIC`、`PRIVATE`、`INTERFACE` 关键字精确传递包含路径、编译定义和链接库，确保依赖关系清晰。  
- **按需编译**：通过 `option()` 提供开关（如 `BUILD_TESTS`、`BUILD_EXAMPLES`），用户可选择性构建子目录。  
- **安装与导出**：使用 `install` 命令安装头文件、库和 CMake 配置文件，使项目可被其他 CMake 项目通过 `find_package` 轻松使用。

这种结构并非强制标准，实际项目会根据规模和需求调整（例如某些项目将头文件与源文件放在同一模块目录下），但核心思想是**模块化、目标化、依赖清晰**。著名的开源项目如 OpenCV、LLVM、TensorFlow 等都采用了类似的布局。