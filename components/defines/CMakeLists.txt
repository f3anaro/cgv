project(cgv_defines LANGUAGES CXX)

# Define header-only (interface) library
add_library(defines INTERFACE)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::defines ALIAS defines)

# Define headers for this header-only library.
target_include_directories(defines
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS defines EXPORT cgv_definesTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory.
# Put defines file in per-project dir (name MUST match).
install(EXPORT cgv_definesTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_defines)
install(FILES cgv_definesConfig.cmake DESTINATION lib/cmake/cgv_defines)

# This makes the project importable from the build directory
export(TARGETS defines NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cgv_definesTargets.cmake)
file(COPY cgv_definesConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
