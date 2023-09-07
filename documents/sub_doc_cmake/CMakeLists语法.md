CMakeLists.txt文件是用于配置CMake构建系统的文件，它使用CMake语言编写。
下面是CMakeLists.txt文件的一般语法和常用命令：

1. 最低CMake版本要求：
   ```cmake
   cmake_minimum_required(VERSION <version>)
   ```

2. 项目名称和版本：
   ```cmake
   project(<project_name> VERSION <project_version>)
   ```

3. 设置变量：
   ```cmake
   set(<variable_name> <value>)
   ```

4. 添加源文件到目标：
   ```cmake
   add_executable(<target_name> <source_files>)
   ```

5. 添加库文件到目标：
   ```cmake
   target_link_libraries(<target_name> <library_name>)
   ```

6. 添加编译选项：
   ```cmake
   target_compile_options(<target_name> <options>)
   ```

7. 添加编译定义：
   ```cmake
   target_compile_definitions(<target_name> <definitions>)
   ```

8. 添加包含目录：
   ```cmake
   target_include_directories(<target_name> <include_directories>)
   ```

9. 添加链接库目录：
   ```cmake
   link_directories(<library_directories>)
   ```

10. 添加链接库：
    ```cmake
    link_libraries(<libraries>)
    ```

11. 添加子目录：
    ```cmake
    add_subdirectory(<subdirectory>)
    ```

12. 设置安装目标：
    ```cmake
    install(TARGETS <target_name> DESTINATION <destination>)
    ```

13. 设置安装文件：
    ```cmake
    install(FILES <files> DESTINATION <destination>)
    ```

14. 条件语句：
    ```cmake
    if(<condition>)
        # code block
    elseif(<condition>)
        # code block
    else()
        # code block
    endif()
    ```

15. 循环语句：
    ```cmake
    foreach(<variable> [IN|LIST] <list>)
        # code block
    endforeach()
    ```

这只是CMakeLists.txt文件的一些常用语法和命令示例。CMake提供了更多的命令和功能，可以根据项目的需求进行灵活配置和使用。你可以参考CMake官方文档以获取更详细的语法和命令说明：https://cmake.org/documentation/