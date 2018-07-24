project(cg_fltk)

find_package(cgv_base REQUIRED)

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

add_library(cg_icons
    src/main.cxx)

# Ensure that the output directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/resources)

foreach(image IN LISTS IMAGES)
	# Add a generation command for each image
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${image}.cxx
        COMMAND res_prep
            ${CMAKE_CURRENT_SOURCE_DIR}/${image}
            ${CMAKE_CURRENT_BINARY_DIR}/${image}.cxx
        MAIN_DEPENDENCY ${image})

    # Add generated inline resource to library
    target_sources(cg_icons PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${image}.cxx)
endforeach()

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cg_icons ALIAS cg_icons)

set_target_properties(cg_icons PROPERTIES
    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    DEFINE_SYMBOL "ICON_EXPORTS"

    # Set folder for Visual Studio
    FOLDER "Standard Plugins")

# Move resources into "Resources" folder in Visual Studio.
source_group("Resources" FILES ${IMAGES})

# Dependencies on other components. cgv::base is only used in the implementation
# and not the public API of cg_icons. Hence, it is marked as a PRIVATE
# dependency.
target_link_libraries(cg_icons PRIVATE cgv::base)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
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
