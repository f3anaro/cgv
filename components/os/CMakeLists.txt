cmake_minimum_required(VERSION 3.8)
project(cgv_os LANGUAGES CXX)

add_library(os
    src/clipboard.cxx
    src/display.cxx
    src/mutex.cxx
    src/priority.cxx
    src/pthread_lib.cxx
    src/socket.cxx
    src/thread.cxx
    src/web_server.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::os ALIAS os)

# Append "cgv_" prefix to the library filename.
set_target_properties(os PROPERTIES OUTPUT_NAME "cgv_os")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(os
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)


# Dependencies on other components
target_link_libraries(os
    cgv::utils
    cgv::type
    cgv::data
    cgv::reflect
    cgv::signal)

if(WIN32)
    # Add additional dependencies for Windows builds. Use the 3rd party
    # pthread-win32 implementation.
    target_link_libraries(os pthread)
else()
    # Use the system thread library on all other platforms
    find_package(Threads REQUIRED)
    target_link_libraries(os ${CMAKE_THREAD_LIBS_INIT})

    # Enable C++-11 standard for non-Windows builds
    target_compile_features(os PUBLIC cxx_std_11)
endif()

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(os PUBLIC CGV_OS_EXPORTS)
else()
    if(WIN32)
        # Add additional dependencies for static Windows builds
        target_link_libraries(render INTERFACE user32)
    endif()
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS os EXPORT cgvOsConfig
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgvOsConfig NAMESPACE cgv:: DESTINATION lib/cmake/cgvOs)

# This makes the project importable from the build directory
export(TARGETS os NAMESPACE cgv:: FILE cgvOsConfig.cmake)
