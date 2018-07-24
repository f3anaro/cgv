# Configuration module for cgv::cgv_gl
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_render REQUIRED)
find_dependency(cgv_gui REQUIRED)
find_dependency(cgv_os REQUIRED)
find_dependency(cgv_reflect_types REQUIRED)
find_dependency(OpenGL REQUIRED)
find_dependency(GLEW REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cgv_gl)
    include("${CMAKE_CURRENT_LIST_DIR}/cgv_glTargets.cmake")
endif()
