project(cgv_gui LANGUAGES CXX)

add_library(gui
    src/animate.cxx
    src/application.cxx
    src/base_provider.cxx
    src/base_provider_generator.cxx
    src/button.cxx
    src/config_file.cxx
    src/control.cxx
    src/dialog.cxx
    src/event.cxx
    src/event_handler.cxx
    src/file_dialog.cxx
    src/gui_creator.cxx
    src/gui_driver.cxx
    src/gui_group.cxx
    src/key_control.cxx
    src/key_event.cxx
    src/layout.cxx
    src/layout_inline.cxx
    src/layout_spacings.cxx
    src/layout_table.cxx
    src/menu_provider.cxx
    src/mouse_event.cxx
    src/provider.cxx
    src/resizable.cxx
    src/shortcut.cxx
    src/text_editor.cxx
    src/trigger.cxx
    src/window.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::gui ALIAS gui)

# Append "cgv_" prefix to the library filename.
set_target_properties(gui PROPERTIES OUTPUT_NAME "cgv_gui")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(gui
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(gui
    cgv::utils
    cgv::type
    cgv::reflect
    cgv::data
    cgv::base
    cgv::media
    cgv::signal)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(gui PUBLIC CGV_GUI_EXPORTS)
endif()

if(WIN32)
    # Compiler definitions for Windows builds
    target_compile_options(gui PRIVATE _WIN32)
endif(WIN32)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS gui EXPORT cgvGuiConfig
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgvGuiConfig NAMESPACE cgv:: DESTINATION lib/cmake/cgvGui)

# This makes the project importable from the build directory
export(TARGETS gui NAMESPACE cgv:: FILE cgvGuiConfig.cmake)
