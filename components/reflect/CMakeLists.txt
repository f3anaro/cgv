project(cgv_reflect LANGUAGES CXX)

# Load required imported targets
find_package(cgvUtils REQUIRED)
find_package(cgvType REQUIRED)

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/reflect)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/reflect/method_interface_impl.h
    COMMAND ppp
        -CGV_DIR=${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include/cgv/reflect/method_interface_impl.ph
        ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/reflect/method_interface_impl.h
    MAIN_DEPENDENCY include/cgv/reflect/method_interface_impl.ph)

add_library(reflect
    src/debug_reflection_handler.cxx
    src/find_reflection_handler.cxx
    src/get_reflection_handler.cxx
    src/reflect_enum.cxx
    src/reflection_handler.cxx
    src/reflection_traits.cxx
    src/set_reflection_handler.cxx

    # Generated headers
    ${CMAKE_CURRENT_BINARY_DIR}/include/cgv/reflect/method_interface_impl.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::reflect ALIAS reflect)

# Append "cgv_" prefix to the library filename.
set_target_properties(reflect PROPERTIES OUTPUT_NAME "cgv_reflect")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(reflect
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        # Adding the build directory for generated header files
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(reflect
    cgv::utils
    cgv::type)

# CGV uses C++11 standard
target_compile_features(reflect PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(reflect PUBLIC CGV_REFLECT_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS reflect EXPORT cgv_reflectTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
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
install(EXPORT cgv_reflectTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_reflect)
install(FILES cgv_reflectConfig.cmake DESTINATION lib/cmake/cgv_reflect)

# This makes the project importable from the build directory
export(TARGETS reflect NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cgv_reflectTargets.cmake)
file(COPY cgv_reflectConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
