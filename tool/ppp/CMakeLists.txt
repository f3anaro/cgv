project(ppp LANGUAGES CXX)

# Define ppp executable
add_executable(ppp
    src/ppp.cxx)

# We do not need the exports because we statically linking against libppp
# target_compile_definitions(ppp PUBLIC CGV_PPP_EXPORTS)

# Define libraries this executable depends upon
target_link_libraries(ppp
    libppp_static)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ppp EXPORT cgvPPPConfig
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgvPPPConfig DESTINATION lib/cmake/cgvPPP)

# This makes the project importable from the build directory
export(TARGETS ppp FILE cgvPPPConfig.cmake)
