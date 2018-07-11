project(GLEW LANGUAGES C)

# Load required imported targets
find_package(OpenGL REQUIRED)

add_library(GLEW
    src/glew.c)

# Add an alias target for the GLEW:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(GLEW::GLEW ALIAS GLEW)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(GLEW
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(GLEW PUBLIC GLEW_BUILD)
else()
    # Compiler definitions for static library
    target_compile_definitions(GLEW PUBLIC GLEW_STATIC)
endif()

# Dependencies on other libraries
target_link_libraries(GLEW
    OpenGL::GL)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS GLEW EXPORT GLEWTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT GLEWTargets NAMESPACE GLEW:: DESTINATION lib/cmake/GLEW)
install(FILES GLEWConfig.cmake DESTINATION lib/cmake/GLEW)

# This makes the project importable from the build directory
export(TARGETS GLEW NAMESPACE GLEW:: FILE ${CMAKE_BINARY_DIR}/GLEWTargets.cmake)
file(COPY GLEWConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
