project(ANN LANGUAGES CXX)

set(SOURCES
    src/ANN.cpp
    src/bd_fix_rad_search.cpp
    src/bd_pr_search.cpp
    src/bd_search.cpp
    src/bd_tree.cpp
    src/brute.cpp
    src/kd_dump.cpp
    src/kd_fix_rad_search.cpp
    src/kd_pr_search.cpp
    src/kd_search.cpp
    src/kd_split.cpp
    src/kd_tree.cpp
    src/kd_util.cpp
    src/perf.cpp)

add_library(ANN
    ${SOURCES})

add_library(ANNf
    ${SOURCES})

# Add an alias target for the ANN:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(ANN::ANN ALIAS ANN)
add_library(ANN::ANNf ALIAS ANNf)

foreach(lib IN ITEMS ANN ANNf)
    # Define headers for this library. PUBLIC headers are used for
    # compiling the library, and will be added to consumers' build
    # paths.
    target_include_directories(${lib}
        PUBLIC
            $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:include>)

    target_compile_definitions(${lib} PUBLIC
        ANN_NO_RANDOM)

    if(${BUILD_SHARED_LIBS})
        # Compiler definitions for shared library
        target_compile_definitions(${lib} PUBLIC
            DLL_EXPORTS
            ANN_PERF)
    else()
        # Compiler definitions for static library
        target_compile_definitions(${lib} PUBLIC
            ANN_STATIC)
    endif()
endforeach(${lib})

# ANN library with floats
target_compile_definitions(ANNf PUBLIC
    ANN_USE_FLOAT)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ANN EXPORT ANNTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT ANNTargets NAMESPACE ANN:: DESTINATION lib/cmake/ANN)
install(FILES ANNConfig.cmake DESTINATION lib/cmake/ANN)

# This makes the project importable from the build directory
export(TARGETS ANN NAMESPACE ANN:: FILE ${CMAKE_BINARY_DIR}/ANNTargets.cmake)
file(COPY ANNConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
