project(cgv_render LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_signal REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_media REQUIRED)
find_package(libppp REQUIRED)

add_library(render
	# Source files
	src/attribute_array_binding.cxx
	src/context.cxx
	src/drawable.cxx
	src/frame_buffer.cxx
	src/performance_monitor.cxx
	src/render_buffer.cxx
	src/shader_code.cxx
	src/shader_program.cxx
	src/texture.cxx
	src/textured_material.cxx
	src/vertex_buffer.cxx
	src/view.cxx

	# Public headers (Visual Studio only)
	include/cgv/render/attribute_array_binding.h
	include/cgv/render/context.h
	include/cgv/render/drawable.h
	include/cgv/render/element_traits.h
	include/cgv/render/frame_buffer.h
	include/cgv/render/lib_begin.h
	include/cgv/render/performance_monitor.h
	include/cgv/render/render_buffer.h
	include/cgv/render/render_types.h
	include/cgv/render/shader_code.h
	include/cgv/render/shader_program.h
	include/cgv/render/textured_material.h
	include/cgv/render/texture.h
	include/cgv/render/vertex_buffer.h
	include/cgv/render/view.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::render ALIAS render)

set_target_properties(render PROPERTIES
	# Append "cgv_" prefix to the library filename.
	OUTPUT_NAME "cgv_render"

	# Set folder for Visual Studio
	FOLDER "CGV-Framework")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(render PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(render PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(render
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(render
	cgv::utils
	cgv::type
	cgv::reflect
	cgv::data
	cgv::base
	cgv::signal
	cgv::math
	cgv::media
	cgv::libppp)

# Tell the linker where to find "dlopen" and friends on Unix systems
if(NOT WIN32)
	target_link_libraries(render ${CMAKE_DL_LIBS})
endif()

# Let use detect Windows
if(WIN32)
	target_compile_definitions(render PRIVATE _WIN32)
endif()

# CGV uses C++11 standard
target_compile_features(render PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
	# Compiler definitions for shared library
	target_compile_definitions(render PUBLIC CGV_RENDER_EXPORTS)
else()
	if(WIN32)
		# Add additional dependencies for static Windows builds
		target_link_libraries(render INTERFACE user32)
	endif()
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS render EXPORT cgv_renderTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_renderTargets NAMESPACE cgv:: DESTINATION cmake/cgv_render)
install(FILES cgv_renderConfig.cmake DESTINATION cmake/cgv_render)

# This makes the project importable from the build directory
export(TARGETS render NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_renderTargets.cmake)
file(COPY cgv_renderConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
