 用 CMake 组织大型项目时，业界普遍采用**模块化、分层、target-based**的目录结构。核心思想是：每个模块自包含（有自己的源码、头文件、测试和 CMakeLists.txt），通过 `add_subdirectory()` 组合，用 `target_link_libraries()` 表达依赖关系。

---

## 一、典型目录结构（模块化方案）

```
MyProject/
├── CMakeLists.txt                 # 顶层：项目元信息、全局选项、依赖发现
├── cmake/
│   ├── CompilerWarnings.cmake     # 编译警告配置
│   ├── Sanitizers.cmake           # ASan/TSan 等
│   ├── FindMyDep.cmake            # 自定义 Find 模块
│   └── ProjectOptions.cmake       # 全局编译选项（IPO、ccache 等）
├── src/                           # 核心源码模块
│   ├── CMakeLists.txt             # 聚合所有子模块：add_subdirectory(core)
│   ├── core/                      # 模块1：核心库
│   │   ├── CMakeLists.txt
│   │   ├── src/
│   │   │   ├── core.cpp
│   │   │   └── internal.hpp       # 私有头文件（模块内可见）
│   │   ├── include/
│   │   │   └── myproject/         # 命名空间路径
│   │   │       └── core/
│   │   │           └── core.hpp   # 公共 API 头文件
│   │   └── tests/
│   │       ├── CMakeLists.txt
│   │       └── test_core.cpp
│   ├── network/                   # 模块2：网络库
│   │   ├── CMakeLists.txt
│   │   ├── src/
│   │   ├── include/myproject/network/
│   │   └── tests/
│   └── utils/                     # 模块3：工具库
│       ├── CMakeLists.txt
│       ├── src/
│       ├── include/myproject/utils/
│       └── tests/
├── apps/                          # 可执行程序
│   ├── CMakeLists.txt
│   ├── server/
│   │   ├── CMakeLists.txt
│   │   └── main.cpp
│   └── cli/
│       ├── CMakeLists.txt
│       └── main.cpp
├── tests/                         # 集成测试 / 端到端测试
│   ├── CMakeLists.txt
│   └── integration/
├── third_party/                   # 内嵌第三方库（Git Submodule / FetchContent）
│   ├── CMakeLists.txt
│   ├── fmt/
│   └── spdlog/
├── docs/
│   └── Doxyfile.in
├── scripts/
│   └── build.sh
├── build/                         # 构建输出目录（out-of-source，不提交到版本控制）
└── README.md
```

---

## 二、关键设计原则

### 1. **头文件分层：`include/` vs `src/`**
- `include/myproject/module/` → **公共头文件**，安装时会复制到系统 include 目录，外部项目通过 `#include <myproject/module/foo.hpp>` 引用。
- `src/` → **私有头文件和实现**，仅模块内部可见，不暴露给外部。

### 2. **每个模块一个 CMake Target**
现代 CMake 不推荐全局变量，而是为每个模块创建独立的库目标：

```cmake
# src/core/CMakeLists.txt
add_library(myproject_core
    src/core.cpp
    src/internal.cpp
)

target_include_directories(myproject_core
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries(myproject_core
    PUBLIC
        myproject_utils          # 依赖同项目其他模块
    PRIVATE
        fmt::fmt                 # 第三方库
)
```

`$<BUILD_INTERFACE:...>` 和 `$<INSTALL_INTERFACE:...>` 确保构建时和安装后的头文件路径都正确。

### 3. **顶层 CMakeLists.txt 的职责**
```cmake
cmake_minimum_required(VERSION 3.20)
project(MyProject VERSION 1.0.0 LANGUAGES CXX)

# 全局标准
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 禁止源码内构建
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "In-source builds are not allowed")
endif()

# 加载辅助脚本
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(ProjectOptions)
include(CompilerWarnings)

# 依赖管理（示例：vcpkg / Conan / FetchContent）
find_package(Threads REQUIRED)

# 全局接口库：编译选项、警告
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_20)

add_library(project_warnings INTERFACE)
include(CompilerWarnings)
set_project_warnings(project_warnings)

# 子目录
add_subdirectory(third_party)
add_subdirectory(src)
add_subdirectory(apps)
add_subdirectory(tests)
```

### 4. **测试组织**
有两种主流方式：

| 方式 | 结构 | 适用场景 |
|------|------|----------|
| **模块内测试** | 每个 `src/module/tests/` 有自己的 `CMakeLists.txt` | 单元测试与模块强绑定，修改模块时同步修改测试 |
| **集中式测试** | 顶层 `tests/` 按功能划分 | 集成测试、端到端测试 |

通常**两者结合**：单元测试放在模块内，集成测试放在顶层 `tests/`。

```cmake
# 模块内测试示例
if(MYPROJECT_BUILD_TESTS)
    add_executable(core_test tests/test_core.cpp)
    target_link_libraries(core_test PRIVATE myproject_core Catch2::Catch2)
    catch_discover_tests(core_test)
endif()
```

### 5. **第三方依赖管理**
大型项目推荐以下策略之一：

- **vcpkg**：通过 `vcpkg.json` 声明依赖，CMake 中 `find_package()` 使用。
- **Conan**：`conanfile.py` + `CMakeDeps`/`CMakeToolchain` 生成器。
- **FetchContent**：CMake 内置，适合将小型库直接拉取到 `third_party/`：
  ```cmake
  include(FetchContent)
  FetchContent_Declare(
      fmt
      GIT_REPOSITORY https://github.com/fmtlib/fmt.git
      GIT_TAG 10.2.1
  )
  FetchContent_MakeAvailable(fmt)
  ```

---

## 三、另一种常见变体：按功能域划分

有些项目（如 LLVM、Chromium）不按 `src/` + `apps/` 分，而是**按功能域平铺**：

```
MyProject/
├── CMakeLists.txt
├── cmake/
├── base/                    # 基础库（类似 utils）
│   ├── CMakeLists.txt
│   ├── src/
│   ├── include/
│   └── tests/
├── net/                     # 网络
├── storage/                 # 存储
├── engine/                  # 核心引擎
├── tools/                   # 工具/可执行程序
│   ├── server/
│   └── cli/
├── third_party/
└── build/
```

这种结构适合**超大型项目**，每个功能域本身就是一个可独立演进的大模块。

---

## 四、总结：最佳实践 checklist

| 实践 | 说明 |
|------|------|
| **Out-of-source 构建** | `build/` 目录与源码分离，不污染版本控制 |
| **Target-based 现代 CMake** | 用 `target_*` 命令替代全局 `include_directories()`、`add_definitions()` |
| **PUBLIC/PRIVATE 可见性** | 精确控制头文件、链接、编译定义的传播范围 |
| **命名空间路径头文件** | `#include <myproject/module/foo.hpp>` 避免命名冲突 |
| **接口库统一选项** | `project_options`、`project_warnings` 作为 INTERFACE target 复用 |
| **安装与导出支持** | 为每个库配置 `install(TARGETS ...)` 和 `install(EXPORT ...)`，支持 `find_package(MyProject)` |

如果你有一个具体的项目类型（如游戏引擎、后台服务、跨平台 SDK），我可以进一步细化推荐结构。