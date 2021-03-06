project(zlib LANGUAGES C)

set(PRIVATE_HEADERS
	include/crc32.h
	include/deflate.h
	include/inffast.h
	include/inffixed.h
	include/inflate.h
	include/inftrees.h
	include/trees.h
	include/zutil.h)

add_library(zlib
	# Source files
	src/adler32.c
	src/compress.c
	src/crc32.c
	src/deflate.c
	src/gzio.c
	src/infback.c
	src/inffast.c
	src/inflate.c
	src/inftrees.c
	src/trees.c
	src/uncompr.c
	src/zutil.c

	# Public headers (Visual Studio only)
	include/zconf.h
	include/zlib.h

	# Private Headers
	${PRIVATE_HEADERS})

# Add an alias target for the ZLIB:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(ZLIB::ZLIB ALIAS zlib)

set_target_properties(zlib PROPERTIES
	# Library filename is in lowercase and uses version information.
	OUTPUT_NAME "zlib"
	VERSION "1.2.3"
	EXPORT_NAME "ZLIB"

	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "ZLIB_INTERNAL"

	# Set folder for Visual Studio
	FOLDER "3rd-Party Libraries")

# Move private headers into "Source Files" folder in Visual Studio.
source_group("Source Files" FILES ${PRIVATE_HEADERS})

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(zlib
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

if(${BUILD_SHARED_LIBS})
	# Compiler definitions for shared library
	target_compile_definitions(zlib PUBLIC ZLIB_DLL)
endif()

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(zlib PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(zlib PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS zlib EXPORT ZLIBTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT ZLIBTargets NAMESPACE ZLIB:: DESTINATION cmake/ZLIB)
install(FILES ZLIBConfig.cmake DESTINATION cmake/ZLIB)

# This makes the project importable from the build directory
export(TARGETS zlib NAMESPACE ZLIB:: FILE ${CMAKE_BINARY_DIR}/cmake/ZLIBTargets.cmake)
file(COPY ZLIBConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
