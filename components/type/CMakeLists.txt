project(cgv_type LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/traits)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/invalid_type.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/type/invalid_type.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/invalid_type.h
    MAIN_DEPENDENCY include/cgv/type/invalid_type.ph)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/traits/function_pointer.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/type/traits/function_pointer.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/traits/function_pointer.h
    MAIN_DEPENDENCY include/cgv/type/traits/function_pointer.ph)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/traits/method_pointer.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/type/traits/method_pointer.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/traits/method_pointer.h
    MAIN_DEPENDENCY include/cgv/type/traits/method_pointer.ph)

add_library(type
    src/variant.cxx
    src/type_id.cxx
    src/type_name.cxx

    # Generated headers
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/invalid_type.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/traits/function_pointer.h
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/type/traits/method_pointer.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::type ALIAS type)

# Append "cgv_" prefix to the library filename.
set_target_properties(type PROPERTIES OUTPUT_NAME "cgv_type")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(type
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        # Adding the build directory for generated header files
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(type
    cgv::utils)

# CGV uses C++11 standard
target_compile_features(type PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(type PUBLIC CGV_TYPE_EXPORTS)
endif()

if(WIN32)
    # Build the library in build directory
    set_target_properties(type PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
else()
    # Build the library in the lib/ directory inside the build directory.
    set_target_properties(type PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS type EXPORT cgv_typeTargets
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
install(EXPORT cgv_typeTargets NAMESPACE cgv:: DESTINATION cmake/cgv_type)
install(FILES cgv_typeConfig.cmake DESTINATION cmake/cgv_type)

# This makes the project importable from the build directory
export(TARGETS type NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_typeTargets.cmake)
file(COPY cgv_typeConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
