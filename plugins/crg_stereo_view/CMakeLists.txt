project(crg_stereo_view LANGUAGES CXX)

# Load required imported targets
find_package(cgv_render REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_signal REQUIRED)
find_package(glsu REQUIRED)
find_package(cgv_gl REQUIRED)
find_package(cg_gamepad REQUIRED)

# TODO: Compile as shared library without interaction "crg_stereo_view_lib" with
#     "NO_STEREO_VIEW_INTERACTOR" define

add_library(crg_stereo_view
    src/stereo_view_interactor.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::crg_stereo_view ALIAS crg_stereo_view)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(crg_stereo_view
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# CGV uses C++11 standard
target_compile_features(crg_stereo_view PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(crg_stereo_view
        PUBLIC
            CGV_RENDER_STEREO_VIEW_EXPORTS)
endif()

# Dependencies on other components, plugins and libraries.
target_link_libraries(crg_stereo_view
    cgv::render
    cgv::gui
    cgv::utils
    cgv::type
    cgv::reflect
    cgv::data
    cgv::base
    cgv::signal
    cgv::glsu
    cgv::gl
    cgv::cg_gamepad)

# Build the library in the plugins/ directory inside the build directory.
set_target_properties(crg_stereo_view PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/plugins)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS crg_stereo_view EXPORT crg_stereo_viewTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT crg_stereo_viewTargets NAMESPACE cgv:: DESTINATION cmake/crg_stereo_view)
install(FILES crg_stereo_viewConfig.cmake DESTINATION cmake/crg_stereo_view)

# This makes the project importable from the build directory
export(TARGETS crg_stereo_view NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/crg_stereo_viewTargets.cmake)
file(COPY crg_stereo_viewConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
