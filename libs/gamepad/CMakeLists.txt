project(cgv_gamepad LANGUAGES CXX)

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
    target_sources(gamepad src/xinput_gamepad_driver.cxx)
    target_compile_definitions(gamepad PUBLIC Xinput)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS gamepad EXPORT cgv_gamepadTargets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT cgv_gamepadTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_gamepad)
install(FILES cgv_gamepadConfig.cmake DESTINATION lib/cmake/cgv_gamepad)

# This makes the project importable from the build directory
export(TARGETS gamepad NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cgv_gamepadTargets.cmake)
file(COPY cgv_gamepadConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})