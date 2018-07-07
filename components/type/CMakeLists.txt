project(cgv_type LANGUAGES CXX)

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

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(type PUBLIC CGV_TYPE_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS type EXPORT cgvTypeConfig
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
install(EXPORT cgvTypeConfig NAMESPACE cgv:: DESTINATION lib/cmake/cgvType)

# This makes the project importable from the build directory
export(TARGETS type NAMESPACE cgv:: FILE cgvTypeConfig.cmake)
