# Configuration module for cgv::cg_ext
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_gui REQUIRED)
find_dependency(cgv_base REQUIRED)
find_dependency(cgv_type REQUIRED)
find_dependency(cgv_math REQUIRED)
find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_media REQUIRED)
find_dependency(cg_icons REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cg_ext)
    include("${CMAKE_CURRENT_LIST_DIR}/cg_extTargets.cmake")
endif()
