project(res_prep LANGUAGES CXX)

# Define res_prep executable
add_executable(res_prep
    src/res_prep.cxx
    ../../components/utils/src/scan.cxx
    ../../components/utils/src/dir.cxx
    ../../components/utils/src/file.cxx)

# We do not need the exports because we statically linking against libppp
target_compile_definitions(res_prep PUBLIC CGV_FORCE_STATIC)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS res_prep EXPORT cgv_res_prepTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory. Put config file
# in per-project dir (name MUST match). An executable has no build dependencies.
# Hence, there is no need to create an extra cgvViewerConfig.cmake file to
# resolve the dependencies. We just use the target defintion file.
install(EXPORT cgv_res_prepTargets FILE cgv_res_prepConfig.cmake DESTINATION lib/cmake/cgv_res_prep)

# This makes the project importable from the build directory
export(TARGETS res_prep FILE cgv_res_prepConfig.cmake)
