project(cgv_base LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_signal REQUIRED)

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/base)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/base/call_interface_impl.h
	COMMAND ppp
		-CGV_DIR=${PROJECT_SOURCE_DIR}/../..
		${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/base/call_interface_impl.ph
		${CMAKE_CURRENT_BINARY_DIR}/include/cgv/base/call_interface_impl.h
	MAIN_DEPENDENCY include/cgv/base/call_interface_impl.ph)

add_library(base
	# Source files
	src/action.cxx
	src/attach_slot.cxx
	src/base.cxx
	src/base_generator.cxx
	src/console.cxx
	src/group.cxx
	src/import.cxx
	src/named.cxx
	src/node.cxx
	src/register.cxx
	src/traverser.cxx

	# Public headers (Visual Studio only)
	include/cgv/base/action.h
	include/cgv/base/attach_slot.h
	include/cgv/base/base_generator.h
	include/cgv/base/base.h
	include/cgv/base/console.h
	include/cgv/base/find_action.h
	include/cgv/base/group.h
	include/cgv/base/import.h
	include/cgv/base/lib_begin.h
	include/cgv/base/named.h
	include/cgv/base/node.h
	include/cgv/base/register.h
	include/cgv/base/traverser.h

	# Generated headers
	${CMAKE_CURRENT_BINARY_DIR}/include/cgv/base/call_interface_impl.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::base ALIAS base)

set_target_properties(base PROPERTIES
	# Append "cgv_" prefix to the library filename.
	OUTPUT_NAME "cgv_base"

	# Set folder for Visual Studio
	FOLDER "CGV-Framework")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(base PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(base PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(base
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		# Adding the build directory for generated header files
		$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(base
	PUBLIC
		cgv::utils
		cgv::type
		cgv::data
		cgv::reflect
		cgv::signal)

if(WIN32)
	# Add additional dependencies for Windows builds
	target_link_libraries(base INTERFACE user32)
else()
	# On Unix systems, tell the linker where to find "dlopen" and friends
	target_link_libraries(base PUBLIC ${CMAKE_DL_LIBS})
endif()

# CGV uses C++11 standard
target_compile_features(base PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
	# Compiler definitions for shared library
	target_compile_definitions(base PUBLIC CGV_BASE_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS base EXPORT cgv_baseTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	FILES_MATCHING
	PATTERN "*"
	PATTERN "*.ph" EXCLUDE)

# Install generated headers
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_baseTargets NAMESPACE cgv:: DESTINATION cmake/cgv_base)
install(FILES cgv_baseConfig.cmake DESTINATION cmake/cgv_base)

# This makes the project importable from the build directory
export(TARGETS base NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_baseTargets.cmake)
file(COPY cgv_baseConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
