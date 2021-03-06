cmake_minimum_required(VERSION 3.8)
project(cgv_os LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_signal REQUIRED)

if(WIN32)
	# Use the 3rd party pthread-win32 implementation.
	find_package(pthreadW32 REQUIRED)
else()
	# Use the system thread library on all other platforms
	find_package(Threads REQUIRED)
endif()

add_library(os
	# Source files
	src/clipboard.cxx
	src/display.cxx
	src/mutex.cxx
	src/priority.cxx
	src/pthread_lib.cxx
	src/socket.cxx
	src/thread.cxx
	src/web_server.cxx

	# Public headers (Visual Studio only)
	include/cgv/os/clipboard.h
	include/cgv/os/common_std_thread.h
	include/cgv/os/display.h
	include/cgv/os/http_request.h
	include/cgv/os/lib_begin.h
	include/cgv/os/mutex.h
	include/cgv/os/mutex_pthread.h
	include/cgv/os/mutex_std_thread.h
	include/cgv/os/priority.h
	include/cgv/os/socket.h
	include/cgv/os/thread.h
	include/cgv/os/thread_pthread.h
	include/cgv/os/thread_std_thread.h
	include/cgv/os/web_server.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::os ALIAS os)

set_target_properties(os PROPERTIES
	# Append "cgv_" prefix to the library filename.
	OUTPUT_NAME "cgv_os"

	# Set folder for Visual Studio
	FOLDER "CGV-Framework")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(os PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(os PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(os
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(os
	cgv::utils
	cgv::type
	cgv::data
	cgv::reflect
	cgv::signal
	Threads::Threads)

# CGV uses C++11 standard
target_compile_features(os PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
	# Compiler definitions for shared library
	target_compile_definitions(os PUBLIC CGV_OS_EXPORTS)
else()
	if(WIN32)
		# Add additional dependencies for static Windows builds
		target_link_libraries(render INTERFACE user32)
	endif()
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS os EXPORT cgv_osTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_osTargets NAMESPACE cgv:: DESTINATION cmake/cgv_os)
install(FILES cgv_osConfig.cmake DESTINATION cmake/cgv_os)

# This makes the project importable from the build directory
export(TARGETS os NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_osTargets.cmake)
file(COPY cgv_osConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
