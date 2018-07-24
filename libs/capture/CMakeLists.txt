project(capture LANGUAGES CXX)

# Load required imported targets
find_package(cgv_config REQUIRED)

add_library(capture
	# Source files
	src/details/capture_device_impl.cxx
	src/details/capture_driver.cxx
	src/capture_device.cxx
	src/capture_format.cxx
	src/capture_processor.cxx
	src/capture_result.cxx
	src/device_capabilities.cxx

	# Public headers
	include/capture/capture_device.h
	include/capture/capture_format.h
	include/capture/capture_processor.h
	include/capture/capture_result.h
	include/capture/device_capabilities.h
	include/capture/device_status.h
	include/capture/lib_begin.h

	# Private headers
	src/details/capture_device_impl.h
	src/details/capture_driver.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::capture ALIAS capture)

set_target_properties(capture PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "CAPTURE_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(capture PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(capture PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

target_include_directories(capture
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# CGV uses C++11 standard
target_compile_features(capture PUBLIC cxx_std_11)

# Dependencies on other components and libraries
target_link_libraries(capture
	PUBLIC
		cgv::config)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS capture EXPORT captureTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install shader files
install(DIRECTORY shader/ DESTINATION ${CMAKE_INSTALL_BINDIR}/../shader)

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT captureTargets NAMESPACE cgv:: DESTINATION cmake/capture)
install(FILES captureConfig.cmake DESTINATION cmake/capture)

# This makes the project importable from the build directory
export(TARGETS capture NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/captureTargets.cmake)
file(COPY captureConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
