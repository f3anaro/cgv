# Configuration module for TIFF::TIFF
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(ZLIB REQUIRED)
find_dependency(JPEG REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET TIFF::TIFF)
    include("${CMAKE_CURRENT_LIST_DIR}/TIFFTargets.cmake")
endif()
