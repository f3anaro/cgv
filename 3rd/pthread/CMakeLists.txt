# pthreads-w32 - Open Source POSIX Threads for Win32
# 
# @see https://www.sourceware.org/pthreads-win32/
#
# This project mimics the import targets of CMake's built-in "FindThreads"
# module such that it can be used as a drop-in replacement for "FindThreads" on
# Win32 systems.
project(pthread-w32 VERSION 1.11.0 LANGUAGES C)

add_library(pthread pthread.c)

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

# Enable Windows build of pthread
target_compile_definitions(pthread PUBLIC PTW32_BUILD)

if(NOT ${BUILD_SHARED_LIBS})
    # Compiler definitions for static library
    target_compile_definitions(pthread PUBLIC PTW32_STATIC_LIB)
endif()

# Winsock (Windows sockets) library
target_link_libraries(pthread INTERFACE ws2_32)

# Rename the exported target to "Threads" to match the "FindThreads" module
# interface.
set_target_properties(pthread PROPERTIES EXPORT_NAME Threads)

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
install(EXPORT pthreadTargets NAMESPACE Threads:: DESTINATION lib/cmake/pthreadW32)
install(FILES pthreadW32Config.cmake DESTINATION lib/cmake/pthreadW32)

# This makes the project importable from the build directory
export(TARGETS pthread NAMESPACE Threads:: FILE pthreadW32Targets.cmake)
