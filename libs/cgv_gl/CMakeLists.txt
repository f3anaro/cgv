project(cgv_gl LANGUAGES CXX)

# Load required imported targets
find_package(cgv_render REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_os REQUIRED)
find_package(cgv_reflect_types REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)

# OpenGL Utility Library (GLU) is required
if (NOT TARGET OpenGL::GLU)
    message(FATAL_ERROR "GLU (OpenGL Utility Library) was not found")
endif()

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl/gl_context_switch.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv_gl/gl/gl_context_switch.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl/gl_context_switch.h
    MAIN_DEPENDENCY include/cgv_gl/gl/gl_context_switch.ph)

add_library(gl 
    src/box_renderer.cxx
    src/box_wire_renderer.cxx
    src/group_renderer.cxx
    src/line_renderer.cxx
    src/normal_renderer.cxx
    src/point_renderer.cxx
    src/renderer.cxx
    src/surface_renderer.cxx

    src/gl/gl.cxx
    src/gl/gl_context_unix.cxx
    src/gl/gl_context_win32.cxx
    src/gl/gl_cursor.cxx
    src/gl/gl_depth_peeler.cxx
    src/gl/gl_implicit_surface_drawable_base.cxx
    src/gl/gl_mesh_drawable_base.cxx
    src/gl/gl_performance_monitor.cxx
    src/gl/gl_texture_tools.cxx
    src/gl/gl_tools.cxx
    src/gl/gl_transparent_renderer.cxx
    src/gl/gl_view.cxx
    src/gl/gl_context.cxx
    src/gl/gl_image_drawable_base.cxx

    # Generated headers
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl/gl_context_switch.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::gl ALIAS gl)

set_target_properties(gl PROPERTIES
    # Append "cgv_" prefix to the library filename.
    OUTPUT_NAME "cgv_gl"

    # Set folder for Visual Studio
    FOLDER "Additional Libraries")

# Build library in directories matching the installation layout.
if(WIN32)
    set_target_properties(gl PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(gl PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

target_include_directories(gl
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        # Adding the build directory for generated header files
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# FIXME: For unicode support the definitions _UNICODE and UNICODE have to be
#     set. Can we do this better?
target_compile_definitions(gl
    PUBLIC
        UNICODE
        _UNICODE)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(gl PUBLIC CGV_RENDER_GL_EXPORTS)
else()
    # Compiler definitions for static library
    target_compile_definitions(gl PUBLIC CGV_RENDER_GL_FORCE_STATIC)
endif()

# CGV uses C++11 standard
target_compile_features(gl PUBLIC cxx_std_11)

# Dependencies on other components and libraries
target_link_libraries(gl
    cgv::render
    cgv::gui
    cgv::os
    GLEW::GLEW
    OpenGL::GLU
    cgv::reflect_types)

if(WIN32)
    # Add additional compiler defintions and dependencies for static Windows
    # builds.
    if (NOT ${BUILD_SHARED_LIBS})
        target_compile_definitions(gl PUBLIC REGISTER_SHADER_FILES)
        target_link_libraries(gl INTERFACE user32 gdi32)
    endif()
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS gl EXPORT glTargets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install shader files
install(DIRECTORY shader/ DESTINATION ${CMAKE_INSTALL_PREFIX}/shader)

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT glTargets NAMESPACE cgv:: DESTINATION cmake/cgv_gl)
install(FILES cgv_glConfig.cmake DESTINATION cmake/cgv_gl)

# This makes the project importable from the build directory
export(TARGETS gl NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_glTargets.cmake)
file(COPY cgv_glConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
