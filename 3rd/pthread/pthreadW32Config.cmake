# Configuration module for Threads::Threads (pthread-w32)
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

# Prevents importing that same targets multiple times
if(NOT TARGET Threads::Threads)
    include("${CMAKE_CURRENT_LIST_DIR}/pthreadW32Targets.cmake")
endif()
