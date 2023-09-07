(1)
查看cmake所有指令列表
cmake --help-command-list  | cat -n

1  add_compile_definitions
2  add_compile_options
3  add_custom_command
4  add_custom_target
5  add_definitions
6  add_dependencies
7  add_executable
8  add_library
9  add_link_options
10  add_subdirectory
11  add_test
12  aux_source_directory
13  break
14  build_command
15  build_name
16  cmake_host_system_information
17  cmake_minimum_required
18  cmake_parse_arguments
19  cmake_policy
20  configure_file
21  continue
22  create_test_sourcelist
23  ctest_build
24  ctest_configure
25  ctest_coverage
26  ctest_empty_binary_directory
27  ctest_memcheck
28  ctest_read_custom_files
29  ctest_run_script
30  ctest_sleep
31  ctest_start
32  ctest_submit
33  ctest_test
34  ctest_update
35  ctest_upload
36  define_property
37  else
38  elseif
39  enable_language
40  enable_testing
41  endforeach
42  endfunction
43  endif
44  endmacro
45  endwhile
46  exec_program
47  execute_process
48  export
49  export_library_dependencies
50  file
51  find_file
52  find_library
53  find_package
54  find_path
55  find_program
56  fltk_wrap_ui
57  foreach
58  function
59  get_cmake_property
60  get_directory_property
61  get_filename_component
62  get_property
63  get_source_file_property
64  get_target_property
65  get_test_property
66  if
67  include
68  include_directories
69  include_external_msproject
70  include_guard
71  include_regular_expression
72  install
73  install_files
74  install_programs
75  install_targets
76  link_directories
77  link_libraries
78  list
79  load_cache
80  load_command
81  macro
82  make_directory
83  mark_as_advanced
84  math
85  message
86  option
87  output_required_files
88  project
89  qt_wrap_cpp
90  qt_wrap_ui
91  remove
92  remove_definitions
93  return
94  separate_arguments
95  set
96  set_directory_properties
97  set_property
98  set_source_files_properties
99  set_target_properties
100  set_tests_properties
101  site_name
102  source_group
103  string
104  subdir_depends
105  subdirs
106  target_compile_definitions
107  target_compile_features
108  target_compile_options
109  target_include_directories
110  target_link_directories
111  target_link_libraries
112  target_link_options
113  target_sources
114  try_compile
115  try_run
116  unset
117  use_mangled_mesa
118  utility_source
119  variable_requires
120  variable_watch
121  while
122  write_file

这些关键字在CMake中具有特殊的含义和用途，使用它们可以定义构建规则、设置编译选项、链接库、创建测试等。请注意，这只是一个大致的列表，具体的保留关键字可能会根据CMake版本的不同而有所变化。建议查阅CMake官方文档以获取最准确和最新的信息。

(2)
cmake保留关键字分类

CMake的保留关键字可以按照功能进行分类，以下是一些常见的分类：

1. 项目管理关键字：
   - project: 定义项目的名称、版本和语言。
   - cmake_minimum_required: 指定所需的最低CMake版本。

2. 目录和文件操作关键字：
   - add_subdirectory: 添加子目录到构建过程中。
   - include_directories: 添加包含目录。
   - link_directories: 添加链接目录。
   - file: 进行文件和目录的操作，如复制、移动、删除等。

3. 编译选项和属性关键字：
   - add_definitions: 添加预处理器定义。
   - target_compile_options: 设置目标的编译选项。
   - set_target_properties: 设置目标的属性，如输出名称、位置等。

4. 依赖和链接关键字：
   - target_link_libraries: 链接目标与库文件。
   - add_dependencies: 添加目标的依赖项。

5. 测试和安装关键字：
   - enable_testing: 启用测试功能。
   - add_test: 添加测试。
   - install: 定义安装规则。

6. 控制流关键字：
   - if/elseif/else/endif: 条件语句。
   - foreach: 遍历列表。
   - while/endwhile: 循环语句。

7. 其他关键字：
   - message: 输出消息。
   - find_package: 查找外部库或软件包。
   - configure_file: 生成配置文件。

这些关键字涵盖了CMake的主要功能和用法，可以帮助你定义和管理项目的构建过程。请注意，具体的关键字和用法可能会根据CMake版本的不同而有所变化。建议查阅CMake官方文档以获取更详细和准确的信息。
