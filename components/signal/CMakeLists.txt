project(cgv_signal LANGUAGES CXX)

# Load required imported targets
find_package(cgv_type REQUIRED)

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

set_target_properties(signal PROPERTIES
    # Append "cgv_" prefix to the library filename.
    OUTPUT_NAME "cgv_signal"

    # Set folder for Visual Studio
    FOLDER "CGV-Framework")

# Build library in directories matching the installation layout.
if(WIN32)
    set_target_properties(signal PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(signal PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

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

# CGV uses C++11 standard
target_compile_features(signal PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(signal PUBLIC CGV_SIGNAL_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS signal EXPORT cgv_signalTargets
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
install(EXPORT cgv_signalTargets NAMESPACE cgv:: DESTINATION cmake/cgv_signal)
install(FILES cgv_signalConfig.cmake DESTINATION cmake/cgv_signal)

# This makes the project importable from the build directory
export(TARGETS signal NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_signalTargets.cmake)
file(COPY cgv_signalConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
