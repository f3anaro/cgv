project(gamepad LANGUAGES CXX)

# Load required imported targets
# TODO: Remove dependency on cgv_config once we use CMake to handle the build
#     flags
find_package(cgv_config REQUIRED)

add_library(gamepad
    src/gamepad.cxx
    src/gamepad_driver.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::gamepad ALIAS gamepad)

target_include_directories(gamepad
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# CGV uses C++11 standard
target_compile_features(gamepad PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(gamepad PUBLIC GAMEPAD_EXPORTS)
endif()

if(WIN32)
    # Add XInput driver. XInput is an API that allows applications to receive
    # input from the Xbox 360 Controller for Windows.
    target_sources(gamepad PRIVATE src/xinput_gamepad_driver.cxx)
    target_compile_definitions(gamepad PUBLIC Xinput)
endif()

# Dependencies on other components and libraries
target_link_libraries(gamepad
    cgv::config)

# Set folder for Visual Studio
set_target_properties(gamepad PROPERTIES
    FOLDER "Additional Libraries")

# Build library in directories matching the installation layout.
if(WIN32)
    set_target_properties(gamepad PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(gamepad PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS gamepad EXPORT gamepadTargets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT gamepadTargets NAMESPACE cgv:: DESTINATION cmake/gamepad)
install(FILES gamepadConfig.cmake DESTINATION cmake/gamepad)

# This makes the project importable from the build directory
export(TARGETS gamepad NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/gamepadTargets.cmake)
file(COPY gamepadConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
