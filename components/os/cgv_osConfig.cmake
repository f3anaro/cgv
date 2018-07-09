# Configuration module for cgv::os
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_utils REQUIRED)
find_dependency(cgv_type REQUIRED)
find_dependency(cgv_data REQUIRED)
find_dependency(cgv_reflect REQUIRED)
find_dependency(cgv_signal REQUIRED)

if(WIN32)
    # Use the 3rd party pthread-win32 implementation.
    find_dependency(pthreadW32 REQUIRED)
else()
    # Use the system thread library on all other platforms
    find_dependency(Threads REQUIRED)
endif()

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::os)
    include("${CMAKE_CURRENT_LIST_DIR}/cgv_osTargets.cmake")
endif()
