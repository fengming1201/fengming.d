针对IPC项目多平台、多SDK的需求，采用**分层架构 + CMake模块化构建**是理想选择。核心设计原则是：**上层业务只依赖稳定的 `mhal` 接口，不感知底层平台；所有平台差异封装在 `mhal` 的实现和CMake配置中**。下面给出一个经过实践验证的目录结构和CMake组织方案。

---

## 1. 推荐项目目录结构

```
ipc-project/
├── CMakeLists.txt                    # 顶层构建脚本，统一调度
├── cmake/                            # CMake 辅助模块
│   ├── toolchains/                   # 交叉编译工具链文件
│   │   ├── fh8852v20x.cmake
│   │   ├── fh8626v3x.cmake
│   │   └── mc632x.cmake
│   ├── platforms/                    # 平台配置（SDK路径、编译宏等）
│   │   ├── fh8852v20x.cmake
│   │   ├── fh8626v3x.cmake
│   │   └── mc632x.cmake
│   └── utils.cmake                   # 自定义宏/函数（可选）
├── src/
│   ├── app/                          # 业务应用层（平台无关）
│   │   ├── CMakeLists.txt
│   │   ├── include/                  # 内部头文件
│   │   └── src/                      # 业务逻辑源码
│   ├── mhal/                         # 硬件抽象层（对外接口 + 平台实现）
│   │   ├── CMakeLists.txt
│   │   ├── include/                  # 对外公共接口头文件（稳定不变）
│   │   │   └── mhal/
│   │   │       ├── video.h
│   │   │       ├── audio.h
│   │   │       └── ...
│   │   ├── common/                   # 与平台无关的实现片段（可选）
│   │   └── platform/                 # 平台适配实现（每个平台一个子目录）
│   │       ├── fh8852v20x/
│   │       │   ├── CMakeLists.txt    # 或直接在 mhal/CMakeLists.txt 中处理
│   │       │   ├── video_impl.cpp
│   │       │   ├── audio_impl.cpp
│   │       │   └── ...
│   │       ├── fh8626v3x/
│   │       └── mc632x/
│   └── main/                         # 主程序入口（可合并到 app）
│       ├── CMakeLists.txt
│       └── main.cpp
├── third_party/                      # 厂商SDK（建议作为外部依赖，不放入版本库）
│   ├── fh8852v20x/
│   │   ├── include/
│   │   └── lib/
│   ├── fh8626v3x/
│   └── mc632x/
├── tests/                            # 测试代码（可选）
│   └── CMakeLists.txt
└── scripts/                          # 辅助脚本（编译、打包等）
```

**关键设计说明：**

- **`mhal/include/mhal`**：对上层暴露的唯一接口，**绝对不能包含任何厂商头文件或平台相关类型**，确保跨平台稳定。
- **`mhal/platform/<platform>`**：每个平台一个子目录，内部包含该平台的实现文件，直接调用对应SDK。
- **`third_party/`**：存放厂商SDK，可通过环境变量或CMake变量指定实际路径，便于不同开发者环境不同。
- **`cmake/toolchains`**：存放交叉编译工具链文件，定义编译器、系统根目录等。
- **`cmake/platforms`**：存放平台级配置，设置SDK路径、编译宏、链接选项等，与工具链分离。

---

## 2. CMake 构建组织方案

### 2.1 整体构建流程

1. 用户在命令行指定平台：
   ```bash
   cmake -B build -DPLATFORM=fh8852v20x -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/fh8852v20x.cmake
   ```
2. 顶层 `CMakeLists.txt` 根据 `PLATFORM` 变量加载对应平台配置：
   ```cmake
   include(cmake/platforms/${PLATFORM}.cmake)
   ```
3. 平台配置文件设置 `SDK_INCLUDE_DIRS`、`SDK_LIBRARIES` 等变量，或定义 IMPORTED 库。
4. 添加子目录构建：`mhal`（选择对应平台实现）、`app`、`main` 等。

### 2.2 顶层 CMakeLists.txt 示例

```cmake
cmake_minimum_required(VERSION 3.16)
project(ipc_project VERSION 1.0.0 LANGUAGES C CXX)

# 必须指定平台
if(NOT DEFINED PLATFORM)
    message(FATAL_ERROR "请通过 -DPLATFORM=<name> 指定目标平台")
endif()

# 加载平台配置（设置 SDK 路径、编译选项等）
include(${CMAKE_SOURCE_DIR}/cmake/platforms/${PLATFORM}.cmake)

# 全局编译选项
add_compile_options(-Wall -Wextra)

# 添加子目录
add_subdirectory(src/mhal)      # 构建硬件抽象层
add_subdirectory(src/app)       # 业务应用层
add_subdirectory(src/main)      # 可执行程序
# add_subdirectory(tests)       # 可选

# 安装规则（可选）
```

### 2.3 平台配置文件示例（`cmake/platforms/fh8852v20x.cmake`）

```cmake
# 平台名称
set(FH8852V20X TRUE)

# 设置 SDK 根目录（可通过环境变量覆盖）
if(NOT DEFINED FH8852V20X_SDK_ROOT)
    set(FH8852V20X_SDK_ROOT "$ENV{FH8852V20X_SDK_ROOT}")
endif()
if(NOT FH8852V20X_SDK_ROOT)
    message(FATAL_ERROR "请设置 FH8852V20X_SDK_ROOT 环境变量或通过 -DFH8852V20X_SDK_ROOT=<路径> 指定")
endif()

# SDK 头文件和库路径
set(SDK_INCLUDE_DIRS ${FH8852V20X_SDK_ROOT}/include)
set(SDK_LIBRARY_DIRS ${FH8852V20X_SDK_ROOT}/lib)

# 定义 IMPORTED 库（更推荐，便于 target_link_libraries 使用）
add_library(sdk_core SHARED IMPORTED)
set_target_properties(sdk_core PROPERTIES
    IMPORTED_LOCATION ${SDK_LIBRARY_DIRS}/libfh8852v20x_core.so
    INTERFACE_INCLUDE_DIRECTORIES ${SDK_INCLUDE_DIRS}
)

add_library(sdk_media SHARED IMPORTED)
set_target_properties(sdk_media PROPERTIES
    IMPORTED_LOCATION ${SDK_LIBRARY_DIRS}/libfh8852v20x_media.so
    INTERFACE_INCLUDE_DIRECTORIES ${SDK_INCLUDE_DIRS}
)

# 平台相关编译宏
add_compile_definitions(PLATFORM_FH8852V20X)

# 其他平台特定设置...
```

> **说明**：也可以不定义 IMPORTED 库，直接在 `mhal` 的 CMake 中使用 `target_include_directories` 和 `target_link_libraries` 链接绝对路径，但 IMPORTED 库更整洁、可复用。

### 2.4 工具链文件示例（`cmake/toolchains/fh8852v20x.cmake`）

```cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# 指定交叉编译器
set(TOOLCHAIN_PREFIX /opt/toolchains/arm-fh8852v20x-linux-uclibcgnueabi/bin/arm-fh8852v20x-linux-uclibcgnueabi-)
set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)

# 系统根目录
set(CMAKE_SYSROOT /opt/toolchains/arm-fh8852v20x-linux-uclibcgnueabi/arm-fh8852v20x-linux-uclibcgnueabi/sysroot)
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

# 搜索规则：只在目标系统根目录中查找库和头文件
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# 其他编译选项（如 -march=armv7-a 等）
add_compile_options(-march=armv7-a -mfpu=neon -mfloat-abi=hard)
```

### 2.5 mhal 层 CMake 设计

**目标**：构建一个库 `mhal`，其源文件根据平台选择。

```cmake
# src/mhal/CMakeLists.txt
# 定义公共接口库（仅头文件，供上层使用）
add_library(mhal_api INTERFACE)
target_include_directories(mhal_api INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/include)

# 平台实现库
set(MHAL_IMPL_SOURCES
    common/utils.cpp          # 平台无关的实现
    platform/${PLATFORM}/video_impl.cpp
    platform/${PLATFORM}/audio_impl.cpp
    # ... 添加该平台所有实现源文件
)

add_library(mhal_impl STATIC ${MHAL_IMPL_SOURCES})
target_include_directories(mhal_impl PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include          # 自己的接口
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/${PLATFORM}  # 平台私有头文件
)
target_link_libraries(mhal_impl PUBLIC
    mhal_api                # 继承接口
    sdk_core                # 链接厂商SDK（IMPORTED目标）
    sdk_media
)
# 添加平台相关编译选项（如宏）
target_compile_definitions(mhal_impl PRIVATE PLATFORM_${PLATFORM})

# 创建统一别名，方便上层链接
add_library(mhal::mhal ALIAS mhal_impl)
```

**说明**：
- `mhal_api` 是一个 INTERFACE 库，仅包含公共头文件路径，确保上层只看到接口。
- `mhal_impl` 是实际实现，链接了对应平台的 SDK 库。
- 上层业务模块只需 `target_link_libraries(app PRIVATE mhal::mhal)` 即可，无需关心具体平台。

### 2.6 业务应用层 CMakeLists.txt 示例

```cmake
# src/app/CMakeLists.txt
add_library(app_core STATIC
    src/video_manager.cpp
    src/audio_manager.cpp
    src/event_handler.cpp
)
target_include_directories(app_core PUBLIC include)
# 依赖 mhal 接口，通过别名链接，不关心实现细节
target_link_libraries(app_core PUBLIC mhal::mhal)
```

### 2.7 可执行程序示例

```cmake
# src/main/CMakeLists.txt
add_executable(ipc_app main.cpp)
target_link_libraries(ipc_app PRIVATE app_core mhal::mhal)
```

---

## 3. 构建与切换平台

```bash
# 构建 fh8852v20x 平台
cmake -B build_fh8852 -DPLATFORM=fh8852v20x \
      -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/fh8852v20x.cmake \
      -DFH8852V20X_SDK_ROOT=/path/to/sdk
cmake --build build_fh8852

# 构建 mc632x 平台（使用另一个工具链和SDK）
cmake -B build_mc632 -DPLATFORM=mc632x \
      -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/mc632x.cmake \
      -DMC632X_SDK_ROOT=/path/to/sdk
cmake --build build_mc632
```

---

## 4. 关键优势总结

- **接口稳定**：上层业务只依赖 `mhal` 公共头文件，不受平台SDK变化影响。
- **平台独立构建目录**：不同平台使用不同构建目录，互不干扰。
- **工具链与配置分离**：交叉编译设置与SDK路径、宏定义分离，便于维护。
- **模块化清晰**：新增平台只需增加一个工具链文件、一个平台配置文件和 `mhal/platform/<新平台>/` 实现目录。
- **可扩展性好**：可以方便地添加单元测试、打包脚本等。

这种设计已在多个IPC项目中成功应用，能够显著降低多平台维护成本。