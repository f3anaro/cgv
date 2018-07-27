# Configuration module for cgv::cg_multi_mouse
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(multi_mouse REQUIRED)
find_dependency(cgv_gui REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cg_multi_mouse)
    include("${CMAKE_CURRENT_LIST_DIR}/cg_multi_mouseTargets.cmake")
endif()
