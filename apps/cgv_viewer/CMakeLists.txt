project(cgv_viewer LANGUAGES CXX)

find_package(cgvSignal REQUIRED)
find_package(cgvBase REQUIRED)
find_package(cgvGui REQUIRED)

# Define cgv_viewer executable
add_executable(cgv_viewer
    src/main.cxx)

# Define the libraries this project depends upon
target_link_libraries(cgv_viewer
    cgv::signal
    cgv::base
    cgv::gui)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cgv_viewer EXPORT cgv_viewerTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory. Put config file
# in per-project dir (name MUST match). An executable has no build dependencies.
# Hence, there is no need to create an extra cgv_viewerConfig.cmake file to
# resolve the dependencies. We just use the target defintion file.
install(EXPORT cgv_viewerTargets FILE cgv_viewerConfig.cmake DESTINATION lib/cmake/cgv_viewer)

# This makes the project importable from the build directory
export(TARGETS cgv_viewer FILE cgv_viewerConfig.cmake)
