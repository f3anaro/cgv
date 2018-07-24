project(TIFF LANGUAGES C)

include(TestBigEndian)
include(CheckTypeSize)
include(CheckIncludeFile)
include(CheckSymbolExists)

# Load required imported targets
find_package(ZLIB REQUIRED)
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

set(PRIVATE_HEADERS
    src/t4.h
    src/tif_config.h.in
    src/tif_dir.h
    src/tif_fax3.h
    src/tiffiop.h
    src/tif_predict.h
    src/uvcode.h)

add_library(TIFF
    # Source Files
    src/tif_aux.c
    src/tif_close.c
    src/tif_codec.c
    src/tif_color.c
    src/tif_compress.c
    src/tif_dir.c
    src/tif_dirinfo.c
    src/tif_dirread.c
    src/tif_dirwrite.c
    src/tif_dumpmode.c
    src/tif_error.c
    src/tif_extension.c
    src/tif_fax3.c
    src/tif_fax3sm.c
    src/tif_flush.c
    src/tif_getimage.c
    src/tif_jbig.c
    src/tif_jpeg.c
    src/tif_luv.c
    src/tif_lzw.c
    src/tif_next.c
    src/tif_ojpeg.c
    src/tif_open.c
    src/tif_packbits.c
    src/tif_pixarlog.c
    src/tif_predict.c
    src/tif_print.c
    src/tif_read.c
    src/tif_stream.cxx
    src/tif_strip.c
    src/tif_swab.c
    src/tif_thunder.c
    src/tif_tile.c
    src/tif_version.c
    src/tif_warning.c
    src/tif_write.c
    src/tif_zip.c

    # Public Headers
    include/tiff.h
    include/tiffconf.h
    include/tiffio.h
    include/tiffvers.h

    # Private Headers
    ${PRIVATE_HEADERS})

# Add OS-specific implementation
if(WIN32)
    target_sources(TIFF PRIVATE src/tif_win32.c)

	# Also add the .def-file to the sources. CMake will know what to do with it.
	if(MSVC)
	    target_sources(TIFF PRIVATE src/libtiff.def)
	endif()
else()
    target_sources(TIFF PRIVATE src/tif_unix.c)
endif(WIN32)

# Add an alias target for the TIFF:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(TIFF::TIFF ALIAS TIFF)

set_target_properties(TIFF PROPERTIES
    # Set lowercase library name and version
    OUTPUT_NAME "tiff"
    VERSION "4.0.3"

    # Set folder for Visual Studio
    FOLDER "3rd-Party Libraries")

# Move private headers into "Source Files" folder in Visual Studio.
source_group("Source Files" FILES ${PRIVATE_HEADERS})

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
    set_target_properties(TIFF PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(TIFF PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(TIFF
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        # Adding the build directory for generated header files
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>
        $<INSTALL_INTERFACE:include>)

# ---------
# Configure
# ---------
# 
# Generate 
test_big_endian(HOST_BIGENDIAN)

check_type_size("int" SIZEOF_INT)
check_type_size("long" SIZEOF_LONG)
check_type_size("int8" HAVE_INT8)
check_type_size("int16" HAVE_INT16)
check_type_size("int32" HAVE_INT32)

# Detect 32/64bit architecture
check_type_size("void*" SIZEOF_VOIDPTR)
if(SIZEOF_VOIDPTR EQUAL 8)
	set(TIFF_SSIZE_T "int64_t")
	set(TIFF_SSIZE_FORMAT "\"%\" PRId64")
else()
	set(TIFF_SSIZE_T "int32_t")
	set(TIFF_SSIZE_FORMAT "\"%\" PRId32")
endif()

check_include_file("assert.h" HAVE_ASSERT_H)
check_include_file("fcntl.h" HAVE_FCNTL_H)
check_include_file("string.h" HAVE_STRING_H)
check_include_file("sys_types.h" HAVE_SYS_TYPES_H)
check_include_file("io.h" HAVE_IO_H)
check_include_file("search.h" HAVE_SEARCH_H)

set(HAVE_IEEEFP ON)
set(HOST_FILLORDER "FILLORDER_LSB2MSB")
set(CCITT_SUPPORT ON)
set(JPEG_SUPPORT ON)
set(LOGLUV_SUPPORT ON)
set(LZW_SUPPORT ON)
set(NEXT_SUPPORT ON)
set(OJPEG_SUPPORT ON)
set(PACKBITS_SUPPORT ON)
set(THUNDER_SUPPORT ON)
set(ZIP_SUPPORT ON)
set(STRIP_SIZE_DEFAULT "8192")
set(STRIPCHOP_DEFAULT "TIFF_STRIPCHOP")
set(SUBIFD_SUPPORT ON)
set(DEFAULT_EXTRASAMPLE_AS_ALPHA ON)
set(CHECK_JPEG_YCBCR_SUBSAMPLING ON)
set(TIF_PLATFORM_CONSOLE ON)

# Feature support
set(COLORIMETRY_SUPPORT ON)
set(YCBCR_SUPPORT ON)
set(CMYK_SUPPORT ON)
set(ICC_SUPPORT ON)
set(PHOTOSHOP_SUPPORT ON)
set(IPTC_SUPPORT ON)

# Generate public configuration header
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/include/tiffconf.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/include/tiffconf.h)

# Generate private configuration header
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/tif_config.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/src/tif_config.h)

if(WIN32)
	# Windows prefixes POSIX functions with an underscore.
	check_symbol_exists("snprintf" "stdio.h" HAVE_SNPRINTF)
	check_symbol_exists("lfind" "search.h" HAVE_LFIND)

	# If function "snprintf" was not found, use the Windows prefixed variant
	if(NOT HAVE_SNPRINTF)
		target_compile_definitions(TIFF PRIVATE snprintf=_snprintf)
	endif()

	# If function "lfind" was not found, use the Windows prefixed variant
	if(NOT HAVE_LFIND)
		target_compile_definitions(TIFF PRIVATE lfind=_lfind)
	endif()

	# Disable deprecation warnings
	if(MSVC)
		target_compile_definitions(TIFF PUBLIC _CRT_SECURE_NO_DEPRECATE)
	endif()

	# Enable Windows-specific IO
	target_compile_definitions(TIFF PUBLIC USE_WIN32_FILEIO)
endif()

# Dependencies on other libraries
target_link_libraries(TIFF
    PUBLIC
        ZLIB::ZLIB
        JPEG::JPEG)

# Build the library in the lib/ directory inside the build directory.
set_target_properties(TIFF PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS TIFF EXPORT TIFFTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING
    PATTERN "*"
    PATTERN "*.in" EXCLUDE)

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT TIFFTargets NAMESPACE TIFF:: DESTINATION cmake/TIFF)
install(FILES TIFFConfig.cmake DESTINATION cmake/TIFF)

# This makes the project importable from the build directory
export(TARGETS TIFF NAMESPACE TIFF:: FILE ${CMAKE_BINARY_DIR}/cmake/TIFFTargets.cmake)
file(COPY TIFFConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
