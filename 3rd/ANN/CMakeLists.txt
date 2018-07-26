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

set(PUBLIC_HEADERS
    include/ANN/ANN.h
    include/ANN/ANNperf.h
    include/ANN/ANNx.h)

set(PRIVATE_HEADERS
    src/bd_tree.h
    src/kd_fix_rad_search.h
    src/kd_pr_search.h
    src/kd_search.h
    src/kd_split.h
    src/kd_tree.h
    src/kd_util.h
    src/pr_queue.h
    src/pr_queue_k.h)

add_library(ANN
    ${SOURCES} ${PUBLIC_HEADERS} ${PRIVATE_HEADERS})

add_library(ANNf
    ${SOURCES} ${PUBLIC_HEADERS} ${PRIVATE_HEADERS})

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
            ANN_PERF)
    else()
        # Compiler definitions for static library
        target_compile_definitions(${lib} PUBLIC
            ANN_STATIC)
    endif()

    set_target_properties(${lib} PROPERTIES
        # Set name of the preprocessor symbol defined when compiling as shared
        # library. This will be used for the dllexport/dllimport declarations.
        DEFINE_SYMBOL "DLL_EXPORTS"

        # Set folder for Visual Studio
        FOLDER "3rd-Party Libraries")

    # Build library in directories matching the installation layout. If
    # multi-config generators are used, build targets in a config-specific
    # subdirectory.
    if(CMAKE_CONFIGURATION_TYPES)
        set_target_properties(${lib} PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
            RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
    else()
        set_target_properties(${lib} PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
            RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
    endif()

    # Move private headers into "Source Files" folder in Visual Studio.
    source_group("Source Files" FILES ${PRIVATE_HEADERS})

endforeach(${lib})

# ANN library with floats
target_compile_definitions(ANNf PUBLIC
    ANN_USE_FLOAT)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ANN ANNf EXPORT ANNTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT ANNTargets NAMESPACE ANN:: DESTINATION cmake/ANN)
install(FILES ANNConfig.cmake DESTINATION cmake/ANN)

# This makes the project importable from the build directory
export(TARGETS ANN ANNf NAMESPACE ANN:: FILE ${CMAKE_BINARY_DIR}/cmake/ANNTargets.cmake)
file(COPY ANNConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
