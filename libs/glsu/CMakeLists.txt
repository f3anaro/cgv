project(glsu LANGUAGES C)

# Load required imported targets
find_package(OpenGL REQUIRED)

# OpenGL Utility Library (GLU) is required
if (NOT TARGET OpenGL::GLU)
	message(FATAL_ERROR "GLU (OpenGL Utility Library) was not found")
endif()

add_library(glsu
	# Source files
	src/glsu.c

	# Public headers (Visual Studio only)
	include/GL/glsu.h)

# Mark Windows build with preprocessor define
if(WIN32)
	target_compile_definitions(glsu PUBLIC
		WIN32)
endif()

# Also add the .def-file to the sources. CMake will know what to do with it
if(MSVC)
	target_sources(glsu PRIVATE src/glsu.def)
endif()

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::glsu ALIAS glsu)

target_include_directories(glsu
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# Dependencies on other components and libraries
target_link_libraries(glsu
	OpenGL::GLU)

# Set folder for Visual Studio
set_target_properties(glsu PROPERTIES
	FOLDER "Additional Libraries")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(glsu PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(glsu PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS glsu EXPORT glsuTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT glsuTargets NAMESPACE cgv:: DESTINATION cmake/glsu)
install(FILES glsuConfig.cmake DESTINATION cmake/glsu)

# This makes the project importable from the build directory
export(TARGETS glsu NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/glsuTargets.cmake)
file(COPY glsuConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
