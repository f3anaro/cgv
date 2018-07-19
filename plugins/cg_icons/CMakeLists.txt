project(cg_fltk)

find_package(cgv_base REQUIRED)

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/resources)

set(IMAGES
    resources/append32.png
    resources/append64.png
    resources/copy_node48.png
    resources/cubemap20.png
    resources/cut_node48.png
    resources/del_node48.png
    resources/empty20.png
    resources/first_child48.png
    resources/image20.png
    resources/last_child48.png
    resources/light20.png
    resources/lock20.png
    resources/lock48.png
    resources/material20.png
    resources/mesh20.png
    resources/molecule20.png
    resources/next_sibling48.png
    resources/open32.png
    resources/open64.png
    resources/parent_node48.png
    resources/prev_sibling48.png
    resources/primitive20.png
    resources/project20.png
    resources/remove_parent48.png
    resources/save32.png
    resources/save64.png
    resources/style20.png
    resources/texture20.png
    resources/transform20.png
    resources/unlock20.png
    resources/unlock48.png
    resources/view20.png)

# Add a generation command for each image
foreach(image LISTS ${IMAGES})
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${image}.cxx
        COMMAND res_prep
            ${CMAKE_CURRENT_SOURCE_DIR}/${image}
            ${CMAKE_CURRENT_BINARY_DIR}/${image}.cxx
        MAIN_DEPENDENCY ${image})
endforeach()

add_library(cg_icons
    src/main.cxx

    # Generated inline resources
    ${CMAKE_CURRENT_BINARY_DIR}/resources/append32.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/append64.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/copy_node48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/cubemap20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/cut_node48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/del_node48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/empty20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/first_child48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/image20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/last_child48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/light20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/lock20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/lock48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/material20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/mesh20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/molecule20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/next_sibling48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/open32.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/open64.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/parent_node48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/prev_sibling48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/primitive20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/project20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/remove_parent48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/save32.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/save64.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/style20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/texture20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/transform20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/unlock20.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/unlock48.png.cxx
    ${CMAKE_CURRENT_BINARY_DIR}/resources/view20.png.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cg_icons ALIAS cg_icons)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(cg_icons PUBLIC ICON_EXPORTS)
endif()

# Dependencies on other components. cgv::base is only used in the implementation
# and not the public API of cg_icons. Hence, it is marked as a PRIVATE
# dependency.
target_link_libraries(cg_icons PRIVATE cgv::base)

# Set folder for Visual Studio
set_target_properties(cg_icons PROPERTIES
    FOLDER "Standard Plugins")

# Build library in directories matching the installation layout.
if(WIN32)
    set_target_properties(cg_icons PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(cg_icons PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cg_icons EXPORT cg_iconsTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cg_iconsTargets NAMESPACE cgv:: DESTINATION cmake/cg_icons)
install(FILES cg_iconsConfig.cmake DESTINATION cmake/cg_icons)

# This makes the project importable from the build directory
export(TARGETS cg_icons NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cg_iconsTargets.cmake)
file(COPY cg_iconsConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
