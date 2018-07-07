project(cgv_viewer LANGUAGES CXX)

# Define cgv_viewer executable
add_executable(cgv_viewer
    src/main.cxx)

# Define the libraries this project depends upon
target_link_libraries(cgv_viewer
    cgv::signal
    cgv::base
    cgv::gui)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cgv_viewer EXPORT cgvViewerConfig
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgvViewerConfig DESTINATION lib/cmake/cgvViewer)

# This makes the project importable from the build directory
export(TARGETS cgv_viewer FILE cgvViewerConfig.cmake)
