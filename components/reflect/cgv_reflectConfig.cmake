# Configuration module for cgv::reflect
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_type REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::reflect)
    include("${CMAKE_CURRENT_LIST_DIR}/cgv_reflectTargets.cmake")
endif()
