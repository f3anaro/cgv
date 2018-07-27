# Configuration module for cgv::space_pilot
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_config REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::space_pilot)
    include("${CMAKE_CURRENT_LIST_DIR}/space_pilotTargets.cmake")
endif()
