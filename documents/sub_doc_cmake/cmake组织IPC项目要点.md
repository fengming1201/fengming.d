 针对 IPC 嵌入式多平台项目，核心设计目标是：**业务代码零改动，仅通过 CMake + mhal 适配层切换平台**。以下是推荐的目录结构和 CMake 组织方案。

---

## 一、推荐目录结构

```
ipc_project/
├── CMakeLists.txt                    # 顶层：平台分发、全局配置
├── cmake/
│   ├── toolchains/                   # 各平台交叉编译工具链
│   │   ├── toolchain-fh8852v20x.cmake
│   │   ├── toolchain-fh8626v3x.cmake
│   │   └── toolchain-mc632x.cmake
│   ├── platforms/                    # 各平台参数配置（宏、编译选项、SDK路径）
│   │   ├── fh8852v20x.cmake
│   │   ├── fh8626v3x.cmake
│   │   └── mc632x.cmake
│   └── modules/                      # 自定义 CMake 模块
│       └── ImportVendorLib.cmake     # 辅助导入预编译静态库
├── sdk/                              # 厂家 SDK（按平台隔离，不混放）
│   ├── fh8852v20x/
│   │   ├── include/                  # SDK 头文件
│   │   ├── lib/                      # 预编译库 .a/.so
│   │   └── CMakeLists.txt            # 将 SDK 封装为 CMake target
│   ├── fh8626v3x/
│   │   ├── include/
│   │   ├── lib/
│   │   └── CMakeLists.txt
│   └── mc632x/
│       ├── include/
│       ├── lib/
│       └── CMakeLists.txt
├── mhal/                             # 硬件抽象层（核心隔离层）
│   ├── CMakeLists.txt
│   ├── include/mhal/                 # mhal 公共头文件（业务层唯一可见的接口）
│   │   ├── camera.h
│   │   ├── encoder.h
│   │   ├── isp.h
│   │   ├── audio.h
│   │   └── common.h
│   ├── src/                          # mhal 通用实现（平台无关）
│   │   ├── common.cpp
│   │   └── buffer_pool.cpp
│   └── platform/                     # 各平台适配实现（仅此处接触厂家 SDK）
│       ├── fh8852v20x/
│       │   ├── CMakeLists.txt
│       │   ├── camera_impl.cpp       # 调用 fh8852 SDK
│       │   ├── encoder_impl.cpp
│       │   └── isp_impl.cpp
│       ├── fh8626v3x/
│       │   ├── CMakeLists.txt
│       │   ├── camera_impl.cpp       # 调用 fh8626 SDK
│       │   ├── encoder_impl.cpp
│       │   └── isp_impl.cpp
│       └── mc632x/
│           ├── CMakeLists.txt
│           ├── camera_impl.cpp       # 调用 mc632 SDK
│           ├── encoder_impl.cpp
│           └── isp_impl.cpp
├── app/                              # 业务应用（纯跨平台，不感知任何 SDK）
│   ├── CMakeLists.txt
│   ├── include/app/
│   ├── src/
│   │   ├── main.cpp
│   │   ├── video_pipeline.cpp
│   │   ├── motion_detect.cpp
│   │   ├── rtsp_server.cpp
│   │   └── cloud_upload.cpp
│   └── tests/
├── third_party/                      # 跨平台通用第三方库
│   ├── json/
│   ├── mqtt/
│   ├── ringbuffer/
│   └── CMakeLists.txt
├── scripts/
│   └── build.sh                      # 一键构建脚本
├── build/                            # 构建输出（.gitignore）
└── README.md
```

---

## 二、关键 CMake 组织方案

### 1. 工具链文件（Toolchain File）

工具链文件**只负责指定编译器**，不处理平台逻辑。

```cmake
# cmake/toolchains/toolchain-fh8852v20x.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(TOOLCHAIN_HOME /opt/toolchains/fh8852v20x)
set(CMAKE_C_COMPILER   ${TOOLCHAIN_HOME}/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_HOME}/bin/arm-linux-gnueabihf-g++)

set(CMAKE_SYSROOT ${TOOLCHAIN_HOME}/sysroot)
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_HOME})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
```

### 2. 平台配置文件

平台配置**定义当前平台的所有参数**：SDK 路径、编译选项、宏定义等。

```cmake
# cmake/platforms/fh8852v20x.cmake
set(PLATFORM_NAME "fh8852v20x")
set(PLATFORM_SDK_ROOT ${CMAKE_SOURCE_DIR}/sdk/fh8852v20x)

# 平台特定编译选项
set(PLATFORM_C_FLAGS "-mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -O2")
set(PLATFORM_CXX_FLAGS "${PLATFORM_C_FLAGS}")

# 平台宏定义（mhal 实现中可用 #ifdef PLATFORM_FH8852 做条件编译）
set(PLATFORM_DEFS
    PLATFORM_FH8852
    CHIP_FH8852V20X
    SENSOR_IMX335
)

# 链接选项
set(PLATFORM_LINK_FLAGS "-Wl,--gc-sections")
```

### 3. 顶层 CMakeLists.txt（平台分发中心）

```cmake
cmake_minimum_required(VERSION 3.20)
project(ipc_project VERSION 1.0.0 LANGUAGES C CXX)

# ========== 1. 平台选择（必须指定） ==========
set(PLATFORM "" CACHE STRING "Target platform: fh8852v20x, fh8626v3x, mc632x")
if(NOT PLATFORM)
    message(FATAL_ERROR "PLATFORM not specified. Use: -DPLATFORM=fh8852v20x")
endif()

# ========== 2. 加载平台配置 ==========
set(PLATFORM_CONFIG ${CMAKE_SOURCE_DIR}/cmake/platforms/${PLATFORM}.cmake)
if(NOT EXISTS ${PLATFORM_CONFIG})
    message(FATAL_ERROR "Unknown platform: ${PLATFORM}")
endif()
include(${PLATFORM_CONFIG})

# ========== 3. 全局编译标准 ==========
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 应用平台编译选项到全局
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${PLATFORM_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${PLATFORM_CXX_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${PLATFORM_LINK_FLAGS}")

# ========== 4. 创建全局接口库（统一编译选项和宏） ==========
add_library(platform_options INTERFACE)
target_compile_definitions(platform_options INTERFACE ${PLATFORM_DEFS})
target_compile_options(platform_options INTERFACE ${PLATFORM_C_FLAGS})

# ========== 5. 子目录（注意顺序：SDK → mhal → app） ==========
add_subdirectory(third_party)
add_subdirectory(sdk/${PLATFORM})   # 仅加载当前平台的 SDK
add_subdirectory(mhal)
add_subdirectory(app)
```

### 4. SDK 层：将厂家库导入为 CMake Target

```cmake
# sdk/fh8852v20x/CMakeLists.txt
# 目标：将厂家预编译库包装成现代 CMake target，对外隐藏路径细节

add_library(vendor_sdk INTERFACE)

# 头文件
target_include_directories(vendor_sdk INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# 导入预编译静态库
add_library(vendor_isp STATIC IMPORTED)
set_target_properties(vendor_isp PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/lib/libisp.a
)

add_library(vendor_venc STATIC IMPORTED)
set_target_properties(vendor_venc PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/lib/libvenc.a
)

add_library(vendor_ai STATIC IMPORTED)
set_target_properties(vendor_ai PROPERTIES
    IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/lib/libaudio.a
)

# 链接依赖（厂家库之间可能有依赖顺序）
target_link_libraries(vendor_sdk INTERFACE
    vendor_venc
    vendor_isp
    vendor_ai
)
```

### 5. mhal 层：核心隔离层

```cmake
# mhal/CMakeLists.txt

# 通用源码（平台无关）
set(MHAL_COMMON_SRCS
    src/common.cpp
    src/buffer_pool.cpp
)

# 平台适配源码（根据 PLATFORM 变量自动选择）
set(MHAL_PLATFORM_SRCS
    platform/${PLATFORM}/camera_impl.cpp
    platform/${PLATFORM}/encoder_impl.cpp
    platform/${PLATFORM}/isp_impl.cpp
    platform/${PLATFORM}/audio_impl.cpp
)

add_library(mhal STATIC
    ${MHAL_COMMON_SRCS}
    ${MHAL_PLATFORM_SRCS}
)

# 头文件暴露策略：
# PUBLIC: 业务层可见的抽象接口
# PRIVATE: 平台实现内部使用的厂家 SDK 头文件（绝不暴露给业务层）
target_include_directories(mhal
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        ${PLATFORM_SDK_ROOT}/include   # 仅实现文件可访问厂家 SDK 头文件
)

# 链接关系：mhal → vendor_sdk（平台特定）
target_link_libraries(mhal
    PUBLIC
        platform_options    # 继承平台宏和编译选项
    PRIVATE
        vendor_sdk          # 厂家 SDK 仅 mhal 内部链接，不传播给业务层
)

# 关键：确保业务层无法直接链接 vendor_sdk
```

**mhal 头文件设计原则**（`include/mhal/camera.h`）：
```cpp
#pragma once
#include <cstdint>
#include <functional>

// 纯抽象接口，绝不包含任何厂家 SDK 头文件
namespace mhal {

struct CameraConfig {
    uint32_t width;
    uint32_t height;
    uint32_t fps;
    // ...
};

class ICamera {
public:
    virtual ~ICamera() = default;
    virtual bool init(const CameraConfig& cfg) = 0;
    virtual bool start() = 0;
    virtual bool stop() = 0;
    virtual void setFrameCallback(std::function<void(uint8_t* data, size_t len)> cb) = 0;
};

// 工厂函数：由平台实现提供
ICamera* createCamera();
void destroyCamera(ICamera* cam);

} // namespace mhal
```

### 6. 业务应用层：完全跨平台

```cmake
# app/CMakeLists.txt
add_executable(ipc_app
    src/main.cpp
    src/video_pipeline.cpp
    src/motion_detect.cpp
    src/rtsp_server.cpp
    src/cloud_upload.cpp
)

target_include_directories(ipc_app
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# 业务层只链接 mhal 和通用第三方库，绝不直接链接 vendor_sdk
target_link_libraries(ipc_app
    PRIVATE
        mhal
        third_party_json
        third_party_mqtt
        third_party_ringbuffer
        Threads::Threads
)

# 安装
install(TARGETS ipc_app RUNTIME DESTINATION bin)
```

---

## 三、构建命令

```bash
# 构建 fh8852v20x 平台
cmake -B build/fh8852v20x \
      -S . \
      -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/toolchain-fh8852v20x.cmake \
      -DPLATFORM=fh8852v20x \
      -DCMAKE_BUILD_TYPE=Release

cmake --build build/fh8852v20x -j$(nproc)

# 构建 mc632x 平台
cmake -B build/mc632x \
      -S . \
      -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/toolchain-mc632x.cmake \
      -DPLATFORM=mc632x \
      -DCMAKE_BUILD_TYPE=Release

cmake --build build/mc632x -j$(nproc)
```

---

## 四、一键构建脚本

```bash
#!/bin/bash
# scripts/build.sh
PLATFORM=$1
BUILD_TYPE=${2:-Release}

if [ -z "$PLATFORM" ]; then
    echo "Usage: $0 <platform> [Debug|Release]"
    echo "Platforms: fh8852v20x, fh8626v3x, mc632x"
    exit 1
fi

TOOLCHAIN="cmake/toolchains/toolchain-${PLATFORM}.cmake"
BUILD_DIR="build/${PLATFORM}"
INSTALL_DIR="install/${PLATFORM}"

echo "=== Building for ${PLATFORM} (${BUILD_TYPE}) ==="

cmake -B ${BUILD_DIR} \
      -S . \
      -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} \
      -DPLATFORM=${PLATFORM} \
      -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

cmake --build ${BUILD_DIR} -j$(nproc)
cmake --install ${BUILD_DIR}

echo "=== Output: ${INSTALL_DIR}/bin/ipc_app ==="
```

---

## 五、设计要点总结

| 设计决策 | 说明 |
|---------|------|
| **SDK 按平台隔离** | `sdk/fh8852v20x/` 与 `sdk/mc632x/` 完全独立，避免头文件/库文件冲突 |
| **mhal 接口零依赖** | `include/mhal/` 的头文件**绝不** `#include` 任何厂家 SDK 头文件，只使用标准类型和自定义结构体 |
| **CMake target 隔离** | `vendor_sdk` 仅被 `mhal` **PRIVATE** 链接，业务层无法直接访问厂家 API |
| **平台配置集中** | `cmake/platforms/*.cmake` 统一管理各平台的宏定义、编译选项、链接选项 |
| **工具链与平台解耦** | Toolchain File 只指定编译器，`PLATFORM` 变量控制代码逻辑和 SDK 选择 |
| **多文件适配优于条件编译** | 每个平台独立目录和文件，比 `#ifdef` 更清晰，编译错误定位更快 |

如果你需要，我还可以进一步提供：
- **mhal 的工厂模式 + 运行时动态加载** 设计（支持同一固件兼容多传感器）
- **CMake 的 `export` + `install` 配置**，让 mhal 可以作为独立库被其他项目复用
- **与 Yocto / Buildroot 集成的方案**