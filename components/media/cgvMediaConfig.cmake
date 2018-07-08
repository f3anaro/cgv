# Configuration module for cgv::media
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvUtils REQUIRED)
find_dependency(cgvType REQUIRED)
find_dependency(cgvMath REQUIRED)
find_dependency(cgvData REQUIRED)
find_dependency(cgvBase REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::media)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvMediaTargets.cmake")
endif()
