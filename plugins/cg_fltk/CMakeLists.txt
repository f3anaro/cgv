project(cg_fltk)

# Load required imported targets
find_package(cgv_gui REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_utils REQUIRED)
find_package(cgv_os REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_signal REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_gl REQUIRED)
find_package(FLTK2 REQUIRED)

add_library(cg_fltk
    src/DockableGroup.cxx
    src/fltk_align_group.cxx
    src/fltk_base.cxx
    src/fltk_bool_control.cxx
    src/fltk_button.cxx
    src/fltk_color_control.cxx
    src/fltk_decorator.cxx
    src/fltk_dockable_group.cxx
    src/fltk_dragger.cxx
    src/fltk_enum_control.cxx
    src/fltk_event.cxx
    src/fltk_font_server.cxx
    src/fltk_generic_window.cxx
    src/fltk_gl_view.cxx
    src/fltk_gui_group.cxx
    src/fltk_layout_group.cxx
    src/fltk_shortcut_control.cxx
    src/fltk_string_control.cxx
    src/fltk_string_view.cxx
    src/fltk_tab_group.cxx
    src/fltk_text_editor.cxx
    src/fltk_tree_group.cxx
    src/fltk_trigger_server.cxx
    src/fltk_value_control.cxx
    src/fltk_value_view.cxx
    src/fltk_viewer_window.cxx
    src/fltk_driver.cxx
    src/fltk_driver_registry.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cg_fltk ALIAS cg_fltk)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(cg_fltk
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(cg_fltk
        PUBLIC
            CGV_GUI_FLTK_EXPORTS
            FL_SHARED)
else()
    # Compiler definitions for static library
    target_compile_definitions(cg_fltk
        PUBLIC
            CGV_GUI_FLTK_FORCE_STATIC
            CGV_FORCE_STATIC)
endif()

if(WIN32)
    # Add additional dependencies for Windows builds
    target_link_libraries(cg_fltk INTERFACE Comdlg32)

    # Mark the shared library as regular DLL for Windows. Otherwise it would be
    # treated as Extension DLL.
    if(${BUILD_SHARED_LIBS})
        target_compile_definitions(cg_fltk PUBLIC _USRDLL)
    endif()
endif()

# Dependencies on other components, plugins and libraries.
target_link_libraries(cg_fltk
    cgv::gui
    cgv::render
    cgv::media
    cgv::utils
    cgv::os
    cgv::base
    cgv::data
    cgv::type
    cgv::signal
    cgv::reflect
    cgv::gl
    FLTK2::FLTK2)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cg_fltk EXPORT cg_fltkTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cg_fltkTargets NAMESPACE cgv:: DESTINATION lib/cmake/cg_fltk)
install(FILES cg_fltkConfig.cmake DESTINATION lib/cmake/cg_fltk)

# This makes the project importable from the build directory
export(TARGETS cg_fltk NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cg_fltkTargets.cmake)
file(COPY cg_fltkConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})
