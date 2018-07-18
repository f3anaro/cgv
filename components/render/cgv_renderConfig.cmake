# Configuration module for cgv::render
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_type REQUIRED)
find_dependency(cgv_reflect REQUIRED)
find_dependency(cgv_data REQUIRED)
find_dependency(cgv_base REQUIRED)
find_dependency(cgv_signal REQUIRED)
find_dependency(cgv_math REQUIRED)
find_dependency(cgv_media REQUIRED)
find_dependency(libppp REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::render)
    include("${CMAKE_CURRENT_LIST_DIR}/cgv_renderTargets.cmake")
endif()
