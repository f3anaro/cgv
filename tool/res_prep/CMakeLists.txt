project(res_prep LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)

# Define res_prep executable
add_executable(res_prep
    src/res_prep.cxx

    # We want to create an executable without any 
    ../../components/utils/src/scan.cxx
    ../../components/utils/src/dir.cxx
    ../../components/utils/src/file.cxx)

# CGV uses C++11 standard
target_compile_features(res_prep PUBLIC cxx_std_11)

# We do not need the exports because we statically linking against libppp
target_compile_definitions(res_prep PUBLIC CGV_FORCE_STATIC)

# Dependencies on other components and libraries
target_link_libraries(res_prep
    # We need headers from the utils component
    PRIVATE
        cgv::utils)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS res_prep EXPORT cgv_res_prepTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory. Put config file
# in per-project dir (name MUST match). An executable has no build dependencies.
# Hence, there is no need to create an extra cgv_resp_prepConfig.cmake file to
# resolve the dependencies. We just use the target defintion file.
install(EXPORT cgv_res_prepTargets FILE cgv_res_prepConfig.cmake DESTINATION lib/cmake/cgv_res_prep)

# This makes the project importable from the build directory
export(TARGETS res_prep FILE cgv_res_prepConfig.cmake)
