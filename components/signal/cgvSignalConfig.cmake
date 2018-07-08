# Configuration module for cgv::signal
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvType REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::signal)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvSignalTargets.cmake")
endif()
