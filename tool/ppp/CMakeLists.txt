# Statically linked Pre-Preprocessor used in the CGV project.
project(ppp LANGUAGES CXX)

# Load required imported targets
find_package(cgv_libppp REQUIRED)

# Define ppp executable
add_executable(ppp
    src/ppp.cxx)

# We do not need the exports because we statically linking against libppp
target_compile_definitions(ppp PUBLIC CGV_FORCE_STATIC)
# target_compile_definitions(ppp PUBLIC CGV_PPP_EXPORTS)

# Always link against a static version of libppp. If the target "libppp_static"
# exists this means that there is a shared and a static version of the library.
# Otherwise "libppp" is already a static library.
if(TARGET cgv::libppp_static)
    target_link_libraries(ppp
        cgv::libppp_static)
else()    
    target_link_libraries(ppp
        cgv::libppp)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ppp EXPORT cgv_pppTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory. Put config file
# in per-project dir (name MUST match). An executable has no build dependencies.
# Hence, there is no need to create an extra cgvViewerConfig.cmake file to
# resolve the dependencies. We just use the target defintion file.
install(EXPORT cgv_pppTargets FILE cgv_pppConfig.cmake  DESTINATION lib/cmake/cgv_ppp)

# This makes the project importable from the build directory
export(TARGETS ppp FILE cgv_pppConfig.cmake)
