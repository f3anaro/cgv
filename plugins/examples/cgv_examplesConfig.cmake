# Configuration module for cgv::examples
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_base REQUIRED)
find_dependency(cgv_math REQUIRED)
find_dependency(cgv_gui REQUIRED)
find_dependency(cgv_render REQUIRED)
find_dependency(cgv_gl REQUIRED)
find_dependency(cgv_reflect_types REQUIRED)
find_dependency(delaunay REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::examples)
    include("${CMAKE_CURRENT_LIST_DIR}/cg_examplesTargets.cmake")
endif()
