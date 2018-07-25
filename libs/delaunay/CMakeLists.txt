project(delaunay LANGUAGES CXX)

# Load required imported targets
find_package(cgv_config REQUIRED)

add_library(delaunay 
	# Source files
	src/corner_connectivity.cxx
	src/ext_corner_connectivity.cxx
	src/instantiation.cxx

	# Public headers
	include/delaunay/corner_connectivity.h
	include/delaunay/delaunay_mesh.h
	include/delaunay/delaunay_mesh_with_hierarchy.h
	include/delaunay/epsilon.h
	include/delaunay/ext_corner_connectivity.h
	include/delaunay/instantiation.h
	include/delaunay/lib_begin.h
	include/delaunay/mesh_geometry.h
	include/delaunay/mesh_geometry_reference.h
	include/delaunay/point_2d.h
	include/delaunay/triangle_mesh.h)

# CGV uses C++11 standard
target_compile_features(delaunay PUBLIC cxx_std_11)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::delaunay ALIAS delaunay)

target_include_directories(delaunay
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

set_target_properties(delaunay PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "DELAUNAY_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Dependencies on other components and libraries
target_link_libraries(delaunay
	PUBLIC
		cgv::config)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(delaunay PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(delaunay PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS delaunay EXPORT delaunayTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT delaunayTargets NAMESPACE cgv:: DESTINATION cmake/delaunay)
install(FILES delaunayConfig.cmake DESTINATION cmake/delaunay)

# This makes the project importable from the build directory
export(TARGETS delaunay NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/delaunayTargets.cmake)
file(COPY delaunayConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
