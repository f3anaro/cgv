# Configuration module for cgv::crg_stereo_view
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_render REQUIRED)
find_dependency(cgv_gui REQUIRED)
find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_type REQUIRED)
find_dependency(cgv_reflect REQUIRED)
find_dependency(cgv_data REQUIRED)
find_dependency(cgv_base REQUIRED)
find_dependency(cgv_signal REQUIRED)
find_dependency(glsu REQUIRED)
find_dependency(cgv_gl REQUIRED)
find_dependency(cg_gamepad REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::crg_stereo_view)
    include("${CMAKE_CURRENT_LIST_DIR}/crg_stereo_viewTargets.cmake")
endif()
