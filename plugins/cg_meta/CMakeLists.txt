project(cg_meta)

# Load required imported targets
find_package(cgv_base REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_utils REQUIRED)

add_library(cg_meta
    # Source Files
    src/object_browser.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cg_meta ALIAS cg_meta)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(cg_meta
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

set_target_properties(cg_meta PROPERTIES
    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    DEFINE_SYMBOL "CGV_GUI_META_EXPORTS"

    # Set folder for Visual Studio
    FOLDER "Standard Plugins")

# Dependencies on other components, plugins and libraries.
target_link_libraries(cg_meta
    PUBLIC
		cgv::base
		cgv::gui
		cgv::render
		cgv::media
		cgv::utils)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
    set_target_properties(cg_meta PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(cg_meta PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cg_meta EXPORT cg_metaTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cg_metaTargets NAMESPACE cgv:: DESTINATION cmake/cg_meta)
install(FILES cg_metaConfig.cmake DESTINATION cmake/cg_meta)

# This makes the project importable from the build directory
export(TARGETS cg_meta NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cg_metaTargets.cmake)
file(COPY cg_metaConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
