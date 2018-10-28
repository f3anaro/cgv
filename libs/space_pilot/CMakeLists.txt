project(space_pilot LANGUAGES CXX)

# Load required imported targets
find_package(cgv_config REQUIRED)

add_library(space_pilot
	# Source Files
	src/space_input.cxx

	# Public Headers
	include/space_pilot/lib_begin.h
	include/space_pilot/space_input.h
	include/space_pilot/space_pilot.h)

# Also add the .def-file to the sources. CMake will know what to do with it.
if(MSVC)
    target_sources(space_pilot PRIVATE src/space_pilot.def)
endif()

# Add platform-specific implementations
if(WIN32)
	target_sources(space_pilot PRIVATE src/space_pilot.cxx)
else()
	target_sources(space_pilot PRIVATE src/space_pilot_unix.cxx)
endif()

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::space_pilot ALIAS space_pilot)

set_target_properties(space_pilot PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "SPACE_PILOT_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(space_pilot PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(space_pilot PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

target_include_directories(space_pilot
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# Windows-specific compile definitions
if(WIN32)
	target_compile_definitions(space_pilot
		PUBLIC
			_WIN32_DCOM
			_ATL_ATTRIBUTES

			# Don't use seldom used methods
			WIN32_LEAN_AND_MEAN		

			# some CString constructors will be explicit
			_ATL_CSTRING_EXPLICIT_CONSTRUCTORS	
			_ATL_APARTMENT_THREADED
			_ATL_NO_AUTOMATIC_NAMESPACE)
endif()

# CGV uses C++11 standard
target_compile_features(space_pilot PUBLIC cxx_std_11)

# Dependencies on other components and libraries
target_link_libraries(space_pilot
	PUBLIC
		cgv::config)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS space_pilot EXPORT space_pilotTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT space_pilotTargets NAMESPACE cgv:: DESTINATION cmake/space_pilot)
install(FILES space_pilotConfig.cmake DESTINATION cmake/space_pilot)

# This makes the project importable from the build directory
export(TARGETS space_pilot NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/space_pilotTargets.cmake)
file(COPY space_pilotConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
