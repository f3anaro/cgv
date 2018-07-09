cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(cgv LANGUAGES CXX)

# Must use GNUInstallDirs to install libraries into correct
# locations on all platforms.
include(GNUInstallDirs)

option(BUILD_SHARED_LIBS "Create shared libraries" TRUE)

# Wraps the original "find_package" command (now accessible via
# "_find_package"). The macro inhibits calls to "_find_package" if the variable
# contains the name of the package
#
# If Foo is a ...
#
# system package:
#     find_package(Foo) either finds FooConfig.cmake in the
#     system or uses FindFoo.cmake to find the library in the system.
#     In either case, the target Foo::Foo is imported.
#
# prebuilt library:
#     find_package(Foo) either finds FooConfig.cmake in the
#     CMAKE_PREFIX_PATH or uses FindFoo.cmake to find the
#     library in the CMAKE_PREFIX_PATH.
#     In either case, the target Foo::Foo is imported.
# subproject:
#     find_package(Foo) does nothing.
#     The target Foo::Foo is part of the project.
#
# The list "as_subproject" contains all names of packages exported by any
# subproject. This list will be checked during "find_package" calls if it
# contains the requested package. If yes, "find_package" will simply do nothing.
set(as_subproject
    # 3rd party libraries (available for all platforms)
    FLTK2

    # Libraries
    cgv_gl
    cgv_reflect_types
    cgv_libppp
    plot

    # Tools
    cgv_p_p_p
    cgv_res_prep

    # Components
    cgv_base
    cgv_config
    cgv_data
    cgv_defines
    cgv_gui
    cgv_math
    cgv_media
    cgv_os
    cgv_reflect
    cgv_render
    cgv_signal
    cgv_type
    cgv_utils)

# Subprojects that are only build on Windows platforms
if(WIN32)
    list(APPEND as_subproject
        # 3rd party libraries
        pthreadW32
        GLEW)
endif()

macro(find_package ARG0)
    if(NOT "${ARG0}" IN_LIST as_subproject)
        _find_package(${ARGV})
    endif()
endmacro()

# Enable testing for current directory and below
enable_testing()

# 3rd party libraries
if(WIN32)
    add_subdirectory(3rd/pthread)
    add_subdirectory(3rd/glew)
endif()

# FLTK 2.0 is an experimental new version of the library which is currently
# inactive. Hence, there is no stable release that can be installed system-wide
# and we need to build it.
add_subdirectory(3rd/fltk)

# Libraries
# add_subdirectory(libs/ann_wrapper)
# add_subdirectory(libs/capture)
# add_subdirectory(libs/cg_gamepad)
add_subdirectory(libs/cgv_gl)
add_subdirectory(libs/cgv_reflect_types)
# add_subdirectory(libs/cgv_win32)
# add_subdirectory(libs/delaunay)
# add_subdirectory(libs/gamepad)
# add_subdirectory(libs/glsu)
# add_subdirectory(libs/multi_mouse)
add_subdirectory(libs/plot)
# add_subdirectory(libs/point_cloud)
add_subdirectory(libs/ppp)
# add_subdirectory(libs/rect_pack)
# add_subdirectory(libs/space_pilot)

# Tools
add_subdirectory(tool/ppp)
# add_subdirectory(tool/shader_test)
add_subdirectory(tool/res_prep)

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
# add_subdirectory(plugins/cg_ext)
add_subdirectory(plugins/cg_fltk)
# add_subdirectory(plugins/cg_fltk/include)
# add_subdirectory(plugins/cg_fltk/include/cg_flk)
# add_subdirectory(plugins/cg_fltk/src)
add_subdirectory(plugins/cg_icons)
# add_subdirectory(plugins/cg_icons/resources)
# add_subdirectory(plugins/cg_icons/src)
# add_subdirectory(plugins/cg_meta)
# add_subdirectory(plugins/cg_multi_mouse)
# add_subdirectory(plugins/cmi_io)
# add_subdirectory(plugins/cmv_avi)
# add_subdirectory(plugins/co_web)
# add_subdirectory(plugins/crg_antialias)
# add_subdirectory(plugins/crg_depth_of_field)
# add_subdirectory(plugins/crg_grid)
# add_subdirectory(plugins/crg_light)
# add_subdirectory(plugins/crg_planar_view)
# add_subdirectory(plugins/crg_spherical_view)
# add_subdirectory(plugins/crg_stereo_view)
# add_subdirectory(plugins/crg_view)
# add_subdirectory(plugins/examples)


# Applications
add_subdirectory(apps/cgv_viewer)
# add_subdirectory(apps/tester)