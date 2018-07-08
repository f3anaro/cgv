# Configuration module for cgv::os
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvUtils REQUIRED)
find_dependency(cgvType REQUIRED)
find_dependency(cgvData REQUIRED)
find_dependency(cgvReflect REQUIRED)
find_dependency(cgvSignal REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::os)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvOsTargets.cmake")
endif()
