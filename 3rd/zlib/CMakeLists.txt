project(zlib LANGUAGES C)

add_library(zlib
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
    src/zutil.c)

# Add an alias target for the ZLIB:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(ZLIB::ZLIB ALIAS zlib)

# Library filename is in lowercase and uses version information.
set_target_properties(zlib PROPERTIES
    OUTPUT_NAME "z"
    VERSION "1.2.3"
    EXPORT_NAME "ZLIB")

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
install(EXPORT ZLIBTargets NAMESPACE ZLIB:: DESTINATION lib/cmake/ZLIB)
install(FILES ZLIBConfig.cmake DESTINATION lib/cmake/ZLIB)

# This makes the project importable from the build directory
export(TARGETS zlib NAMESPACE ZLIB:: FILE ${CMAKE_BINARY_DIR}/ZLIBTargets.cmake)
file(COPY ZLIBConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
