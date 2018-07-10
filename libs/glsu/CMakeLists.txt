project(glsu LANGUAGES C)

# Load required imported targets
find_package(OpenGL REQUIRED)

# OpenGL Utility Library (GLU) is required
if (NOT TARGET OpenGL::GLU)
    message(FATAL_ERROR "GLU (OpenGL Utility Library) was not found")
endif()

add_library(glsu 
    src/glsu.c)

# Also add the .def-file to the sources. CMake will know what to do with it
if(MSVC)
    target_sources(glsu src/glsu.def)
endif()

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::glsu ALIAS glsu)

target_include_directories(glsu
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components and libraries
target_link_libraries(glsu
    OpenGL::GLU)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS glsu EXPORT glsuTargets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install shader files
install(DIRECTORY shader/ DESTINATION ${CMAKE_INSTALL_LIBDIR}/cgv/shader)

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT glsuTargets NAMESPACE cgv:: DESTINATION lib/cmake/glsu)
install(FILES glsuConfig.cmake DESTINATION lib/cmake/glsu)

# This makes the project importable from the build directory
export(TARGETS glsu NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/glsuTargets.cmake)
file(COPY glsuConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
