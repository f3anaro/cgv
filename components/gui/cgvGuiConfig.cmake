# Configuration module for cgv::gui
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgvUtils REQUIRED)
find_dependency(cgvType REQUIRED)
find_dependency(cgvReflect REQUIRED)
find_dependency(cgvData REQUIRED)
find_dependency(cgvBase REQUIRED)
find_dependency(cgvMedia REQUIRED)
find_dependency(cgvSignal REQUIRED)

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::gui)
    include("${CMAKE_CURRENT_LIST_DIR}/cgvGuiTargets.cmake")
endif()
