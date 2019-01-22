project(cmi_io LANGUAGES CXX)

# Load required imported targets
find_package(cgv_media REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_type REQUIRED)
find_package(PNG REQUIRED)
find_package(TIFF REQUIRED)
find_package(JPEG REQUIRED)

# The imported target for JPEG is only available on CMake >= 3.12
if(NOT TARGET JPEG::JPEG)
	message(STATUS "Create imported target JPEG::JPEG")
	add_library(JPEG::JPEG SHARED IMPORTED)
	set_target_properties(JPEG::JPEG PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${JPEG_INCLUDE_DIR})
	foreach(lib ${JPEG_LIBRARIES})
		set_target_properties(JPEG::JPEG PROPERTIES IMPORTED_LOCATION ${lib})
	endforeach()
endif()

add_library(cmi_io
	# Source files
	src/jpg_reader.cxx
	src/png_reader.cxx
	src/png_writer.cxx
	src/tiff_reader.cxx
	src/tiff_writer.cxx

	# Public headers (Visual Studio only)
	include/cmi_io/jpg_reader.h
	include/cmi_io/lib_begin.h
	include/cmi_io/png_reader.h
	include/cmi_io/png_writer.h
	include/cmi_io/tiff_reader.h
	include/cmi_io/tiff_writer.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cmi_io ALIAS cmi_io)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(cmi_io
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

if(NOT ${BUILD_SHARED_LIBS})
	# Compiler definitions for static library
	target_compile_definitions(cmi_io
		PUBLIC
			CGV_GUI_FLTK_FORCE_STATIC)
endif()

set_target_properties(cmi_io PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "CGV_MEDIA_IMAGE_IO_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Standard Plugins")

# Dependencies on other components, plugins and libraries.
target_link_libraries(cmi_io
	PUBLIC
		cgv::media
		cgv::base
		cgv::data
		cgv::type
		PNG::PNG
		TIFF::TIFF
		JPEG::JPEG)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(cmi_io PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(cmi_io PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cmi_io EXPORT cmi_ioTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cmi_ioTargets NAMESPACE cgv:: DESTINATION cmake/cmi_io)
install(FILES cmi_ioConfig.cmake DESTINATION cmake/cmi_io)

# This makes the project importable from the build directory
export(TARGETS cmi_io NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cmi_ioTargets.cmake)
file(COPY cmi_ioConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
