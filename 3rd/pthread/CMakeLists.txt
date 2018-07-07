# pthreads-w32 - Open Source POSIX Threads for Win32
# 
# @see https://www.sourceware.org/pthreads-win32/
#
project(pthread VERSION 1.11.0 LANGUAGES C)

add_library(pthread SHARED pthread.c)
add_library(pthread_static STATIC pthread.c)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(pthread
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>)

target_include_directories(pthread_static
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>)

# Enable Windows build of pthread
target_compile_definitions(pthread PUBLIC PTW32_BUILD)
target_compile_definitions(pthread_static PUBLIC PTW32_BUILD PTW32_STATIC_LIB)

# Winsock (Windows sockets) library
target_link_libraries(pthread ws2_32)
target_link_libraries(pthread_static ws2_32)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS pthread pthread_static EXPORT pthreadConfig
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

install(FILES pthread.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
