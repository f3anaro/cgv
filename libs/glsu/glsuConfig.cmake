# Configuration module for cgv::glsu
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(OpenGL REQUIRED)

# OpenGL Utility Library (GLU) is required
if (NOT TARGET OpenGL::GLU)
    message(FATAL_ERROR "GLU (OpenGL Utility Library) was not found")
endif()

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::glsu)
    include("${CMAKE_CURRENT_LIST_DIR}/cgv_glTargets.cmake")
endif()
