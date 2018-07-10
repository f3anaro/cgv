project(cgv_math LANGUAGES CXX)

# Load required imported targets
find_package(cgvData REQUIRED)

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

# CGV uses C++11 standard
target_compile_features(math PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(math PUBLIC CGV_MATH_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS math EXPORT cgv_mathTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_mathTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_math)
install(FILES cgv_mathConfig.cmake DESTINATION lib/cmake/cgv_math)

# This makes the project importable from the build directory
export(TARGETS math NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cgv_mathTargets.cmake)
file(COPY cgv_mathConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
