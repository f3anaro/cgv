project(cgv_config LANGUAGES CXX)

# Define header-only (interface) library
add_library(config INTERFACE)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::config ALIAS config)

# Define headers for this header-only library.
target_include_directories(config
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS config EXPORT cgvConfigConfig
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgvConfigConfig NAMESPACE cgv:: DESTINATION lib/cmake/cgvConfig)

# This makes the project importable from the build directory
export(TARGETS config NAMESPACE cgv:: FILE cgvConfigConfig.cmake)
