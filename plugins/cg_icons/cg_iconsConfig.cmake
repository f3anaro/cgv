# Configuration module for cgv::cg_icons
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_base REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cg_icons)
    include("${CMAKE_CURRENT_LIST_DIR}/cg_iconsTargets.cmake")
endif()
