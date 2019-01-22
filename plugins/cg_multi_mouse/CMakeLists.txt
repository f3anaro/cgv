project(cg_multi_mouse LANGUAGES CXX)

# Load required imported targets
find_package(multi_mouse REQUIRED)
find_package(cgv_gui REQUIRED)

add_library(cg_multi_mouse
	# Source files
	src/cg_multi_mouse.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cg_multi_mouse ALIAS cg_multi_mouse)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(cg_multi_mouse
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

set_target_properties(cg_multi_mouse PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "CG_MULTI_MOUSE_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Standard Plugins")

# Dependencies on other components, plugins and libraries.
target_link_libraries(cg_multi_mouse
	PUBLIC
		cgv::multi_mouse
		cgv::gui)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(cg_multi_mouse PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(cg_multi_mouse PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cg_multi_mouse EXPORT cg_multi_mouseTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cg_multi_mouseTargets NAMESPACE cgv:: DESTINATION cmake/cg_multi_mouse)
install(FILES cg_multi_mouseConfig.cmake DESTINATION cmake/cg_multi_mouse)

# This makes the project importable from the build directory
export(TARGETS cg_multi_mouse NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cg_multi_mouseTargets.cmake)
file(COPY cg_multi_mouseConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
