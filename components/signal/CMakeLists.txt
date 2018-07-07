project(cgv_signal LANGUAGES CXX)

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/abst_signal.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/signal/abst_signal.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/abst_signal.h
    MAIN_DEPENDENCY include/cgv/signal/abst_signal.ph)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/bool_signal.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/signal/bool_signal.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/bool_signal.h
    MAIN_DEPENDENCY include/cgv/signal/bool_signal.ph)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/rebind.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/signal/rebind.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/rebind.h
    MAIN_DEPENDENCY include/cgv/signal/rebind.ph)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/signal.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/signal/signal.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/signal.h
    MAIN_DEPENDENCY include/cgv/signal/signal.ph)

add_library(signal
    src/abst_signal.cxx
    src/bool_combiner.cxx

    # Generated headers
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/abst_signal.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/bool_signal.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/rebind.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/signal/signal.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::signal ALIAS signal)

# Append "cgv_" prefix to the library filename.
set_target_properties(signal PROPERTIES OUTPUT_NAME "cgv_signal")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(signal
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        # Adding the build directory for generated header files
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(signal
    cgv::type)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(signal PUBLIC CGV_SIGNAL_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS signal EXPORT cgvSignalConfig
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING
    PATTERN "*"
    PATTERN "*.ph" EXCLUDE)

# Install generated headers
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgvSignalConfig NAMESPACE cgv:: DESTINATION lib/cmake/cgvSignal)

# This makes the project importable from the build directory
export(TARGETS signal NAMESPACE cgv:: FILE cgvSignalConfig.cmake)
