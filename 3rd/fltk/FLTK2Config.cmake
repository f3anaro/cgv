# Configuration module for FLK2::FLK2
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

# Prevents importing that same targets multiple times
if(NOT TARGET FLK2::FLK2)
    include("${CMAKE_CURRENT_LIST_DIR}/FLK2Targets.cmake")
endif()
