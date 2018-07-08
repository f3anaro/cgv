# Configuration module for cgv::cg_fltk
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvGui REQUIRED)
find_dependency(cgvRender REQUIRED)
find_dependency(cgvMedia REQUIRED)
find_dependency(cgvUtils REQUIRED)
find_dependency(cgvOs REQUIRED)
find_dependency(cgvBase REQUIRED)
find_dependency(cgvData REQUIRED)
find_dependency(cgvType REQUIRED)
find_dependency(cgvSignal REQUIRED)
find_dependency(cgvReflect REQUIRED)
find_dependency(cgvGl REQUIRED)
find_dependency(FLTK2 REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cg_fltk)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvFltkTargets.cmake")
endif()
