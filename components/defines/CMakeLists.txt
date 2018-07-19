project(cgv_defines LANGUAGES CXX)

# Define header-only library
add_library(defines INTERFACE)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::defines ALIAS defines)

# Define headers for this header-only library.
target_include_directories(defines
    INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# CGV uses C++11 standard
target_compile_features(defines INTERFACE cxx_std_11)

# HACK: Currently, CMake does not generate any IDE project for interface
#   libraries. We use a custom target to create a pseudo-target called
#   "defines_ide".
if (MSVC)
    add_custom_target(defines_ide SOURCES
        include/cgv/defines/assert.h
        include/cgv/defines/join.h
        include/cgv/defines/quote.h)

    set_target_properties(defines_ide PROPERTIES
        # Set name of the target in an Visual Studio
        PROJECT_LABEL "defines"

        # Set folder for Visual Studio
        FOLDER "CGV-Framework")
endif()

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
install(EXPORT cgv_definesTargets NAMESPACE cgv:: DESTINATION cmake/cgv_defines)
install(FILES cgv_definesConfig.cmake DESTINATION cmake/cgv_defines)

# This makes the project importable from the build directory
export(TARGETS defines NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_definesTargets.cmake)
file(COPY cgv_definesConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
