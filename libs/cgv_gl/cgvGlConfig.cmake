# Configuration module for cgv::gl
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvRender REQUIRED)
find_dependency(cgvGui REQUIRED)
find_dependency(cgvOs REQUIRED)
find_dependency(OpenGL REQUIRED)
find_dependency(GLEW REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::gl)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvGlTargets.cmake")
endif()
