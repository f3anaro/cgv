# Configuration module for cgv::ann_wrapper
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(ANN REQUIRED)
find_dependency(cgv_math REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::ann_wrapper)
    include("${CMAKE_CURRENT_LIST_DIR}/ann_wrapperTargets.cmake")
endif()
