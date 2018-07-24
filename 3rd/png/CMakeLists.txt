project(PNG LANGUAGES C)

# Load required imported targets
find_package(ZLIB)

add_library(PNG
    # Sources
    src/png.c
    src/pngerror.c
    src/pnggccrd.c
    src/pngget.c
    src/pngmem.c
    src/pngpread.c
    src/pngread.c
    src/pngrio.c
    src/pngrtran.c
    src/pngrutil.c
    src/pngset.c
    src/pngtrans.c
    src/pngvcrd.c
    src/pngwio.c
    src/pngwrite.c
    src/pngwtran.c
    src/pngwutil.c

    # Public Headers
    include/png.h
    include/pngconf.h)

# Add an alias target for the PNG:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(PNG::PNG ALIAS PNG)

# Set lowercase library name and version
set_target_properties(PNG PROPERTIES
    OUTPUT_NAME "png"
    VERSION "1.2.6"

    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    DEFINE_SYMBOL "PNG_BUILD_DLL"

    # Set folder for Visual Studio
    FOLDER "3rd-Party Libraries")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(PNG
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(PNG PUBLIC PNG_NO_MODULEDEF)
else()
    # Compiler definitions for static library
    target_compile_definitions(PNG PUBLIC PNG_STATIC)
endif()

# Dependencies on other libraries
target_link_libraries(PNG
    PUBLIC
        ZLIB::ZLIB)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
    set_target_properties(PNG PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(PNG PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS PNG EXPORT PNGTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT PNGTargets NAMESPACE PNG:: DESTINATION cmake/PNG)
install(FILES PNGConfig.cmake DESTINATION cmake/PNG)

# This makes the project importable from the build directory
export(TARGETS PNG NAMESPACE PNG:: FILE ${CMAKE_BINARY_DIR}/cmake/PNGTargets.cmake)
file(COPY PNGConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
