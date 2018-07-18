project(plot LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_os REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_gl REQUIRED)

add_library(plot 
    src/plot1d.cxx
    src/plot2d.cxx
    src/plot_base.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::plot ALIAS plot)

target_include_directories(plot
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# FIXME: For unicode support the definitions _UNICODE and UNICODE have to be
#     set. Can we do this better?
target_compile_definitions(plot
    PUBLIC
        UNICODE
        _UNICODE)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(plot PUBLIC PLOT_EXPORTS)
endif()

# Inline shaders for static Windows builds
if(WIN32 AND NOT ${BUILD_SHARED_LIBS})
    target_compile_definitions(plot PUBLIC REGISTER_SHADER_FILES)
endif()

# Dependencies on other components and libraries
target_link_libraries(plot
    cgv::utils
    cgv::type
    cgv::reflect
    cgv::data
    cgv::base
    cgv::media
    cgv::os
    cgv::gui
    cgv::render
    cgv::gl)

# Build the library in the lib/ directory inside the build directory.
set_target_properties(plot PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS plot EXPORT plotTargets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install shader files
install(DIRECTORY shader/ DESTINATION ${CMAKE_INSTALL_LIBDIR}/plot/shader)

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT plotTargets NAMESPACE cgv:: DESTINATION cmake/plot)
install(FILES plotConfig.cmake DESTINATION cmake/plot)

# This makes the project importable from the build directory
export(TARGETS plot NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/plotTargets.cmake)
file(COPY plotConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
