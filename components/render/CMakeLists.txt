project(cgv_render LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_signal REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_libppp REQUIRED)

add_library(render
    src/attribute_array_binding.cxx
    src/context.cxx
    src/drawable.cxx
    src/frame_buffer.cxx
    src/performance_monitor.cxx
    src/render_buffer.cxx
    src/shader_code.cxx
    src/shader_program.cxx
    src/texture.cxx
    src/textured_material.cxx
    src/vertex_buffer.cxx
    src/view.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::render ALIAS render)

# Append "cgv_" prefix to the library filename.
set_target_properties(render PROPERTIES OUTPUT_NAME "cgv_render")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(render
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(render
    cgv::utils
    cgv::type
    cgv::reflect
    cgv::data
    cgv::base
    cgv::signal
    cgv::math
    cgv::media
    cgv::libppp)

if(NOT WIN32)
    # On Unix systems, tell the linker where to find "dlopen" and friends 
    target_link_libraries(render ${CMAKE_DL_LIBS})
endif()

# CGV uses C++11 standard
target_compile_features(render PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(render PUBLIC CGV_RENDER_EXPORTS)
else()
    if(WIN32)
        # Add additional dependencies for static Windows builds
        target_link_libraries(render INTERFACE user32)
    endif()
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS render EXPORT cgv_renderTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_renderTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_render)
install(FILES cgv_renderConfig.cmake DESTINATION lib/cmake/cgv_render)

# This makes the project importable from the build directory
export(TARGETS render NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cgv_renderTargets.cmake)
file(COPY cgv_renderConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
