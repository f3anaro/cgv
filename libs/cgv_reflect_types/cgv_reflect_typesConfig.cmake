# Configuration module for cgv::reflect_types
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_type REQUIRED)
find_dependency(cgv_reflect REQUIRED)
find_dependency(cgv_media REQUIRED)
find_dependency(cgv_math REQUIRED)
find_dependency(cgv_render REQUIRED)
find_dependency(cgv_gui REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::reflect_types)
    include("${CMAKE_CURRENT_LIST_DIR}/cgv_reflect_typesTargets.cmake")
endif()
