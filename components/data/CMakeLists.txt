project(cgv_data LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_defines REQUIRED)

add_library(data
    src/ascii_io_reflection_handlers.cxx
    src/binary_io_reflection_handlers.cxx
    src/component_format.cxx
    src/data_format.cxx
    src/data_view.cxx
    src/image_view.cxx
    src/io_reflection_handler.cxx
    src/packing_info.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::data ALIAS data)

set_target_properties(data PROPERTIES
    # Append "cgv_" prefix to the library filename.
    OUTPUT_NAME "cgv_data"

    # Set folder for Visual Studio
    FOLDER "CGV-Framework")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
    set_target_properties(data PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(data PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(data
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

target_link_libraries(data
    cgv::utils
    cgv::type
    cgv::reflect
    cgv::defines)

# CGV uses C++11 standard
target_compile_features(data PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(data PUBLIC CGV_DATA_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS data EXPORT cgv_dataTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_dataTargets NAMESPACE cgv:: DESTINATION cmake/cgv_data)
install(FILES cgv_dataConfig.cmake DESTINATION cmake/cgv_data)

# This makes the project importable from the build directory
export(TARGETS data NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_dataTargets.cmake)
file(COPY cgv_dataConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
