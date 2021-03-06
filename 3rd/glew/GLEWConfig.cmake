# Configuration module for GLEW::GLEW
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(OpenGL REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET GLEW::GLEW)
    include("${CMAKE_CURRENT_LIST_DIR}/GLEWTargets.cmake")
endif()
