project(cgv_reflect_types LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_gui REQUIRED)

add_library(reflect_types 
    src/gui/shortcut.cxx
    src/math/perm_mat.cxx
    src/media/color.cxx
    src/media/illum/light_source.cxx
    src/media/illum/obj_material.cxx
    src/media/illum/phong_material.cxx
    src/render/context.cxx
    src/render/view.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::reflect_types ALIAS reflect_types)

# Set full qualified name for the library filename
set_target_properties(reflect_types PROPERTIES OUTPUT_NAME "cgv_reflect_types")

target_include_directories(reflect_types
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# FIXME: For unicode support the definitions _UNICODE and UNICODE have to be
#     set. Can we do this better?
target_compile_definitions(reflect_types
    PUBLIC
        UNICODE
        _UNICODE)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(reflect_types PUBLIC CGV_REFLECT_TYPES_EXPORTS)
endif()

# Dependencies on other components and libraries
target_link_libraries(reflect_types
    cgv::utils
    cgv::type
    cgv::reflect
    cgv::media
    cgv::math
    cgv::render
    cgv::gui)

# Build the library in the lib/ directory inside the build directory.
set_target_properties(reflect_types PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS reflect_types EXPORT cgv_reflect_typesTargets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT cgv_reflect_typesTargets NAMESPACE cgv:: DESTINATION cmake/reflect_types)
install(FILES cgv_reflect_typesConfig.cmake DESTINATION cmake/reflect_types)

# This makes the project importable from the build directory
export(TARGETS reflect_types NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_reflect_typesTargets.cmake)
file(COPY cgv_reflect_typesConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
