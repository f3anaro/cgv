project(cgv_math LANGUAGES CXX)

add_library(math
    src/functions.cxx
    src/normal_estimation.cxx
    src/solve_polynom.cxx
    src/sparse_les.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::math ALIAS math)

# Append "cgv_" prefix to the library filename.
set_target_properties(math PROPERTIES OUTPUT_NAME "cgv_math")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(math
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(math
    cgv::data)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(math PUBLIC CGV_MATH_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS math EXPORT cgvMathConfig
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgvMathConfig NAMESPACE cgv:: DESTINATION lib/cmake/cgvMath)

# This makes the project importable from the build directory
export(TARGETS math NAMESPACE cgv:: FILE cgvMathConfig.cmake)
