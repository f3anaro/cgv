# Configuration module for cgv::multi_mouse
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_gui REQUIRED)
find_dependency(FLTK2 REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::multi_mouse)
    include("${CMAKE_CURRENT_LIST_DIR}/multi_mouseTargets.cmake")
endif()
