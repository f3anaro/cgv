# pthreads-w32 - Open Source POSIX Threads for Win32
# 
# @see https://www.sourceware.org/pthreads-win32/
#
# This project mimics the import targets of CMake's built-in "FindThreads"
# module such that it can be used as a drop-in replacement for "FindThreads" on
# Win32 systems.
project(pthread-w32 VERSION 1.11.0 LANGUAGES C)

set(PRIVATE_HEADERS
    config.h
    implement.h
    need_errno.h
    sched.h
    semaphore.h)

add_library(pthread
    # Source Files
    pthread.c

    # Public Headers
    pthread.h

    # Private Headers
    ${PRIVATE_HEADERS})

# Add an alias target for the Threads:: namespace such that other components can
# use this target like other imported targets with namespace prefixes. This is
# the standard namespace for CMake's built-in "FindThreads" module.
add_library(Threads::Threads ALIAS pthread)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(pthread
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>)

# Windows-specific Compiler definitions
target_compile_definitions(pthread
    PUBLIC
        HAVE_STRUCT_TIMESPEC)

if(NOT ${BUILD_SHARED_LIBS})
    # Compiler definitions for static library
    target_compile_definitions(pthread PUBLIC PTW32_STATIC_LIB)
endif()

# Winsock (Windows sockets) library
target_link_libraries(pthread PUBLIC ws2_32)

set_target_properties(pthread PROPERTIES
    # Rename the exported target to "Threads" to match the "FindThreads"
    # module interface. Build the library in the lib/ directory inside the
    # build directory.
    EXPORT_NAME Threads

    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    DEFINE_SYMBOL "PTW32_BUILD"

    # Set folder for Visual Studio
    FOLDER "3rd-Party Libraries")

# Move private headers into "Source Files" folder in Visual Studio.
source_group("Source Files" FILES ${PRIVATE_HEADERS})

# Build library in directories matching the installation layout.
if(WIN32)
    set_target_properties(pthread PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(pthread PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS pthread EXPORT pthreadTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT pthreadTargets NAMESPACE Threads:: DESTINATION cmake/pthreadW32)
install(FILES pthreadW32Config.cmake DESTINATION cmake/pthreadW32)

# This makes the project importable from the build directory
export(TARGETS pthread NAMESPACE Threads:: FILE ${CMAKE_BINARY_DIR}/cmake/pthreadW32Targets.cmake)
file(COPY pthreadW32Config.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
