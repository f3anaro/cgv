project(cgv_utils LANGUAGES CXX)

# Load required imported targets
find_package(cgv_config REQUIRED)

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/utils)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/utils/ostream_printf.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/utils/ostream_printf.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/utils/ostream_printf.h
    MAIN_DEPENDENCY include/cgv/utils/ostream_printf.ph)

add_library(utils
    src/advanced_scan.cxx
    src/big_binary_file.cxx
    src/bit_operations.cxx
    src/convert.cxx
    src/convert_string.cxx
    src/date_time.cxx
    src/dir.cxx
    src/file.cxx
    src/ostream_printf.cxx
    src/progression.cxx
    src/scan.cxx
    src/scan_enum.cxx
    src/statistics.cxx
    src/stopwatch.cxx
    src/token.cxx
    src/tokenizer.cxx

    # Generated headers
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/utils/ostream_printf.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::utils ALIAS utils)

# Append "cgv_" prefix to the library filename.
set_target_properties(utils PROPERTIES OUTPUT_NAME "cgv_utils")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(utils
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        # Adding the build directory for generated header files
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(utils
    cgv::config)

# CGV uses C++11 standard
target_compile_features(utils PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(utils PUBLIC CGV_UTILS_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS utils EXPORT cgv_utilsTargets
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
install(EXPORT cgv_utilsTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_utils)
install(FILES cgv_utilsConfig.cmake DESTINATION lib/cmake/cgv_utils)

# This makes the project importable from the build directory
export(TARGETS utils NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cgv_utilsTargets.cmake)
file(COPY cgv_utilsConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})