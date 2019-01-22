project(JPEG LANGUAGES C)

add_library(JPEG
	# Source files
	src/jcapimin.c
	src/jcapistd.c
	src/jccoefct.c
	src/jccolor.c
	src/jcdctmgr.c
	src/jchuff.c
	src/jcinit.c
	src/jcmainct.c
	src/jcmarker.c
	src/jcmaster.c
	src/jcomapi.c
	src/jcparam.c
	src/jcphuff.c
	src/jcprepct.c
	src/jcsample.c
	src/jctrans.c
	src/jdapimin.c
	src/jdapistd.c
	src/jdatadst.c
	src/jdatasrc.c
	src/jdcoefct.c
	src/jdcolor.c
	src/jddctmgr.c
	src/jdhuff.c
	src/jdinput.c
	src/jdmainct.c
	src/jdmarker.c
	src/jdmaster.c
	src/jdmerge.c
	src/jdphuff.c
	src/jdpostct.c
	src/jdsample.c
	src/jdtrans.c
	src/jerror.c
	src/jfdctflt.c
	src/jfdctfst.c
	src/jfdctint.c
	src/jidctflt.c
	src/jidctfst.c
	src/jidctint.c
	src/jidctred.c
	src/jmemansi.c
	src/jmemmgr.c
	src/jquant1.c
	src/jquant2.c
	src/jutils.c

	# Public headers (Visual Studio only)
	include/jchuff.h
	include/jconfig.h
	include/jdct.h
	include/jdhuff.h
	include/jerror.h
	include/jinclude.h
	include/jmemsys.h
	include/jmorecfg.h
	include/jpegint.h
	include/jpeglib.h
	include/jversion.h)

# Add an alias target for the JPEG:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(JPEG::JPEG ALIAS JPEG)

# Set lowercase library name and version
set_target_properties(JPEG PROPERTIES
	OUTPUT_NAME "jpeg"
	VERSION "6"

	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "JPEG_DLL"

	# Set folder for Visual Studio
	FOLDER "3rd-Party Libraries")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(JPEG
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

if(NOT ${BUILD_SHARED_LIBS})
	# Compiler definitions for static library
	target_compile_definitions(JPEG PUBLIC JPEG_STATIC)
endif()

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(JPEG PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(JPEG PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS JPEG EXPORT JPEGTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT JPEGTargets NAMESPACE JPEG:: DESTINATION cmake/JPEG)
install(FILES JPEGConfig.cmake DESTINATION cmake/JPEG)

# This makes the project importable from the build directory
export(TARGETS JPEG NAMESPACE JPEG:: FILE ${CMAKE_BINARY_DIR}/cmake/JPEGTargets.cmake)
file(COPY JPEGConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
