project(TIFF LANGUAGES C)

# Load required imported targets
find_package(ZLIB REQUIRED)
find_package(JPEG REQUIRED)

add_library(TIFF
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
    src/tif_zip.c)

# Also add the .def-file to the sources. CMake will know what to do with it
if(MSVC)
    target_sources(TIFF PRIVATE src/libtiff.def)
endif()

# Add an alias target for the TIFF:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(TIFF::TIFF ALIAS TIFF)

set_target_properties(TIFF PROPERTIES
    # Set lowercase library name and version
    OUTPUT_NAME "tiff"
    VERSION "4.0.3"

    # Set folder for Visual Studio
    FOLDER "3rd-Party Libraries")

# Build library in directories matching the installation layout.
if(WIN32)
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
        $<INSTALL_INTERFACE:include>)

target_compile_definitions(TIFF
    PUBLIC
        _CRT_SECURE_NO_DEPRECATE
        AVOID_WIN32_FILEIO
        CHECK_JPEG_YCBCR_SUBSAMPLING
        DEFAULT_EXTRASAMPLE_AS_ALPHA
        STRIPCHOP_DEFAULT=TIFF_STRIPCHOP
        STRIP_SIZE_DEFAULT=8192
        LOGLUV_SUPPORT
        NEXT_SUPPORT
        THUNDER_SUPPORT
        LZW_SUPPORT
        JPEG_SUPPORT
        ZIP_SUPPORT
        PACKBITS_SUPPORT
        CCITT_SUPPORT
        TIF_PLATFORM_CONSOLE
        FILLODER_LSB2MSB)

if(NOT ${BUILD_SHARED_LIBS})
    # Compiler definitions for static library
    target_compile_definitions(TIFF PUBLIC JPEG_STATIC)
endif()

# The imported target for JPEG is only available on CMake >= 3.12
if(NOT TARGET JPEG::JPEG)
    message(STATUS "Create imported target JPEG::JPEG")
    add_library(JPEG::JPEG SHARED IMPORTED)
    set_target_properties(JPEG::JPEG PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${JPEG_INCLUDE_DIR})
    foreach(lib ${JPEG_LIBRARIES})
        set_target_properties(JPEG::JPEG PROPERTIES IMPORTED_LOCATION ${lib})
    endforeach()
endif()

# Detect system endianess
include(TestBigEndian)
test_big_endian(is_big_endian)
if(is_big_endian)
    target_compile_definitions(TIFF PUBLIC HOST_BIGENDIAN=1)
else()
    target_compile_definitions(TIFF PUBLIC HOST_BIGENDIAN=0)
endif()

# Dependencies on other libraries
target_link_libraries(TIFF
    PUBLIC
        ZLIB::ZLIB
    INTERFACE
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
