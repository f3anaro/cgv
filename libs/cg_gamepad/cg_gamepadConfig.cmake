# Configuration module for cgv::cg_gamepad
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_type REQUIRED)
find_dependency(cgv_reflect REQUIRED)
find_dependency(cgv_reflect_types REQUIRED)
find_dependency(cgv_data REQUIRED)
find_dependency(cgv_signal REQUIRED)
find_dependency(cgv_os REQUIRED)
find_dependency(cgv_base REQUIRED)
find_dependency(cgv_math REQUIRED)
find_dependency(cgv_media REQUIRED)
find_dependency(cgv_gui REQUIRED)
find_dependency(gamepad REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cg_gamepad)
    include("${CMAKE_CURRENT_LIST_DIR}/cg_gamepadTargets.cmake")
endif()
