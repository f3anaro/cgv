# Configuration module for cgv::utils
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvConfig REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::utils)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvUtilsTargets.cmake")
endif()
