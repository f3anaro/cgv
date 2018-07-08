# Configuration module for cgv::type
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvUtils REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::type)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvTypeTargets.cmake")
endif()
