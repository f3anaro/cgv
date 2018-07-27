# Configuration module for cgv::cg_meta
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_base REQUIRED)
find_dependency(cgv_gui REQUIRED)
find_dependency(cgv_render REQUIRED)
find_dependency(cgv_media REQUIRED)
find_dependency(cgv_utils REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cg_meta)
    include("${CMAKE_CURRENT_LIST_DIR}/cg_metaTargets.cmake")
endif()
