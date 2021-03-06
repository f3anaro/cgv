project(cg_gamepad LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_reflect_types REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_signal REQUIRED)
find_package(cgv_os REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(gamepad REQUIRED)

add_library(cg_gamepad 
	src/gamepad_server.cxx

	# Public headers (Visual Studio only)
	include/cg_gamepad/gamepad_server.h
	include/cg_gamepad/lib_begin.h)

# CGV uses C++11 standard
target_compile_features(cg_gamepad PUBLIC cxx_std_11)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cg_gamepad ALIAS cg_gamepad)

target_include_directories(cg_gamepad
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

set_target_properties(cg_gamepad PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "CG_GAMEPAD_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Dependencies on other components and libraries
target_link_libraries(cg_gamepad
	cgv::utils
	cgv::type
	cgv::reflect
	cgv::reflect_types
	cgv::data
	cgv::signal
	cgv::os
	cgv::base
	cgv::math
	cgv::media
	cgv::gui
	cgv::gamepad)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(cg_gamepad PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(cg_gamepad PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cg_gamepad EXPORT cg_gamepadTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT cg_gamepadTargets NAMESPACE cgv:: DESTINATION cmake/cg_gamepad)
install(FILES cg_gamepadConfig.cmake DESTINATION cmake/cg_gamepad)

# This makes the project importable from the build directory
export(TARGETS cg_gamepad NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cg_gamepadTargets.cmake)
file(COPY cg_gamepadConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
