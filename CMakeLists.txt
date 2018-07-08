cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(cgv LANGUAGES CXX)

# Must use GNUInstallDirs to install libraries into correct
# locations on all platforms.
include(GNUInstallDirs)

option(BUILD_SHARED_LIBS "Create shared libraries" TRUE)

# Some other library that we import that was also built using CMake
# and has an exported target.
# find_package(MyOtherLibrary REQUIRED)

# Enable testing for current directory and below
enable_testing()

# 3rd party libraries
if(WIN32)
    add_subdirectory(3rd/pthread)
endif()

# TODO: Use in Windows builds only
add_subdirectory(3rd/glew)

# FLTK 2.0 is an experimental new version of the library which is currently
# inactive. Hence, there is no stable release that can be installed system-wide
# and we need to build it.
add_subdirectory(3rd/fltk)

# Tools
add_subdirectory(tool/ppp)
# add_subdirectory(tool/shader_test)
add_subdirectory(tool/res_prep)

# Libraries
# add_subdirectory(libs/ann_wrapper)
# add_subdirectory(libs/capture)
# add_subdirectory(libs/cg_gamepad)
add_subdirectory(libs/cgv_gl)
# add_subdirectory(libs/cgv_reflect_types)
# add_subdirectory(libs/cgv_win32)
# add_subdirectory(libs/delaunay)
# add_subdirectory(libs/gamepad)
# add_subdirectory(libs/glsu)
# add_subdirectory(libs/multi_mouse)
# add_subdirectory(libs/plot)
# add_subdirectory(libs/point_cloud)
add_subdirectory(libs/ppp)
# add_subdirectory(libs/rect_pack)
# add_subdirectory(libs/space_pilot)

# Framework components
add_subdirectory(components/base)
add_subdirectory(components/config)
add_subdirectory(components/data)
add_subdirectory(components/defines)
add_subdirectory(components/gui)
add_subdirectory(components/math)
add_subdirectory(components/media)
add_subdirectory(components/os)
add_subdirectory(components/reflect)
add_subdirectory(components/render)
add_subdirectory(components/signal)
add_subdirectory(components/type)
add_subdirectory(components/utils)

# Plugins
add_subdirectory(plugins/cg_fltk)

# Applications
add_subdirectory(apps/cgv_viewer)
# add_subdirectory(apps/tester)