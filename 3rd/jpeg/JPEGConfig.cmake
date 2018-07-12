# Configuration module for JPEG::JPEG
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

# Prevents importing that same targets multiple times
if(NOT TARGET JPEG::JPEG)
    include("${CMAKE_CURRENT_LIST_DIR}/JPEGTargets.cmake")
endif()
