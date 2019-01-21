project(point_cloud LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_os REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_gl REQUIRED)
find_package(ANN REQUIRED)

add_library(point_cloud 
	# Source Files
	src/ann_tree.cxx
	src/gl_point_cloud_drawable.cxx
	src/gl_surface_reconstructor_drawable.cxx
	src/neighbor_graph.cxx
	src/normal_estimator.cxx
	src/ply_writer.cxx
	src/point_cloud.cxx
	src/point_cloud_interactable.cxx
	src/surface_reconstructor_consistent.cxx
	src/surface_reconstructor_count.cxx
	src/surface_reconstructor.cxx
	src/surface_reconstructor_debug.cxx
	src/surface_reconstructor_filters.cxx
	src/surface_reconstructor_info.cxx
	src/surface_reconstructor_post_process.cxx
	src/surface_reconstructor_predicates.cxx
	src/surface_reconstructor_region_growing.cxx

	# Public headers
	include/point_cloud/ann_tree.h
	include/point_cloud/gl_point_cloud_drawable.h
	include/point_cloud/gl_surface_reconstructor_drawable.h
	include/point_cloud/lib_begin.h
	include/point_cloud/neighbor_graph.h
	include/point_cloud/normal_estimator.h
	include/point_cloud/ply.h
	include/point_cloud/ply_writer.h
	include/point_cloud/point_cloud.h
	include/point_cloud/point_cloud_interactable.h
	include/point_cloud/surface_reconstructor.h)

# CGV uses C++11 standard
target_compile_features(point_cloud PUBLIC cxx_std_11)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::point_cloud ALIAS point_cloud)

target_include_directories(point_cloud
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

set_target_properties(point_cloud PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "POINT_CLOUD_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Math constants are not defined in Standard C/C++. To use them in Visual
# Studio, we have to define _USE_MATH_DEFINES for <cmath> or <math.h> headers.
if(MSVC)
	target_compile_definitions(point_cloud PRIVATE _USE_MATH_DEFINES)
endif()

# Dependencies on other components and libraries
target_link_libraries(point_cloud
	cgv::utils
	cgv::type
	cgv::reflect
	cgv::data
	cgv::base
	cgv::media
	cgv::os
	cgv::gui
	cgv::render
	cgv::cgv_gl
	ANN::ANNf)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(point_cloud PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(point_cloud PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS point_cloud EXPORT point_cloudTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT point_cloudTargets NAMESPACE cgv:: DESTINATION cmake/point_cloud)
install(FILES point_cloudConfig.cmake DESTINATION cmake/point_cloud)

# This makes the project importable from the build directory
export(TARGETS point_cloud NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/point_cloudTargets.cmake)
file(COPY point_cloudConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
