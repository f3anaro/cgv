# Configuration module for cgv::cmi_io
#
# This module will be executed if downstreams import the package from the
# install directory with find_package(). This modules resolves dependencies and
# load exported CMake targets.
include(CMakeFindDependencyMacro)

find_dependency(cgv_media REQUIRED)
find_dependency(cgv_base REQUIRED)
find_dependency(cgv_data REQUIRED)
find_dependency(cgv_type REQUIRED)
find_dependency(PNG REQUIRED)
find_dependency(TIFF REQUIRED)
find_dependency(JPEG REQUIRED)

# The imported target for JPEG is only available on CMake >= 3.12
if(NOT TARGET JPEG::JPEG)
    message(STATUS "Create imported target JPEG::JPEG")
    add_library(JPEG::JPEG SHARED IMPORTED)
    set_target_properties(JPEG::JPEG PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${JPEG_INCLUDE_DIR})
    foreach(lib ${JPEG_LIBRARIES})
        set_target_properties(JPEG::JPEG PROPERTIES IMPORTED_LOCATION ${lib})
    endforeach()
endif()

# Prevents importing that same targets multiple times
if(NOT TARGET cgv::cmi_io)
    include("${CMAKE_CURRENT_LIST_DIR}/cmi_ioTargets.cmake")
endif()
