cmake_minimum_required(VERSION 3.8)

project(FLTK2 VERSION 2.0)

add_library(FLTK2
    # Images
    images/FileIcon2.cxx
    images/Fl_Guess_Image.cxx
    images/fl_jpeg.cxx
    images/fl_png.cxx
    images/HelpDialog.cxx
    images/HelpDialog.fl
    images/images_core.cxx
    images/Makefile
    images/pnmImage.cxx
    images/xpmFileImage.cxx

    # OpenGL
    OpenGL/Fl_Gl_Choice.cxx
    OpenGL/Fl_Gl_Overlay.cxx
    OpenGL/Fl_Gl_Window.cxx
    OpenGL/GlChoice.h
    OpenGL/gl_draw.cxx
    OpenGL/gl_start.cxx

    # FLTK
    src/addarc.cxx
    src/addcurve.cxx
    src/add_idle.cxx
    src/Adjuster.cxx
    src/AlignGroup.cxx
    src/allfiles.xbm
    src/AnsiWidget.cxx
    src/args.cxx
    src/ARRAY.h
    src/BarGroup.cxx
    src/bmpImage.cxx
    src/Browser.cxx
    src/Browser_load.cxx
    src/Button.cxx
    src/CheckButton.cxx
    src/Choice.cxx
    src/clip.cxx
    src/Clock.cxx
    src/color_chooser.cxx
    src/Color.cxx
    src/colormap.h
    src/ComboBox.cxx
    src/compose.cxx
    src/Cursor.cxx
    src/CycleButton.cxx
    src/default_glyph.cxx
    src/Dial.cxx
    src/DiamondBox.cxx
    src/dnd.cxx
    src/drawtext.cxx
    src/EngravedLabel.cxx
    src/error.cxx
    src/event_key_state.cxx
    src/fastarrow.h
    src/FileBrowser.cxx
    src/FileChooser2.cxx
    src/FileChooser.cxx
    src/file_chooser.cxx
    src/FileIcon.cxx
    src/FileInput.cxx
    src/filename_absolute.cxx
    src/filename_ext.cxx
    src/filename_isdir.cxx
    src/filename_list.cxx
    src/filename_match.cxx
    src/filename_name.cxx
    src/fillrect.cxx
    src/Fl_Menu_Item.cxx
    src/FloatInput.cxx
    src/fltk_theme.cxx
    src/Font.cxx
    src/gifImage.cxx
    src/Group.cxx
    src/GSave.cxx
    src/HelpView.cxx
    src/HighlightButton.cxx
    src/Image.cxx
    src/InputBrowser.cxx
    src/Input.cxx
    src/InvisibleWidget.cxx
    src/Item.cxx
    src/key_name.cxx
    src/LightButton.cxx
    src/list_fonts.cxx
    src/load_plugin.cxx
    src/lock.cxx
    src/mediumarrow.h
    src/Menu_add.cxx
    src/MenuBar.cxx
    src/Menu.cxx
    src/Menu_global.cxx
    src/Menu_popup.cxx
    src/MenuWindow.cxx
    src/message.cxx
    src/MultiImage.cxx
    src/NumericInput.cxx
    src/numericsort.cxx
    src/Output.cxx
    src/OvalBox.cxx
    src/overlay_rect.cxx
    src/own_colormap.cxx
    src/PackedGroup.cxx
    src/path.cxx
    src/PlasticBox.cxx
    src/PopupMenu.cxx
    src/Preferences.cxx
    src/ProgressBar.cxx
    src/RadioButton.cxx
    src/readimage.cxx
    src/RepeatButton.cxx
    src/ReturnButton.cxx
    src/RoundBox.cxx
    src/RoundedBox.cxx
    src/run.cxx
    src/scandir.c
    src/Scrollbar.cxx
    src/ScrollGroup.cxx
    src/scrollrect.cxx
    src/setcolor.cxx
    src/setdisplay.cxx
    src/setvisual.cxx
    src/ShadowBox.cxx
    src/ShapedWindow.cxx
    src/SharedImage.cxx
    src/ShortcutAssignment.cxx
    src/show_colormap.cxx
    src/Slider.cxx
    src/slowarrow.h
    src/StatusBarGroup.cxx
    src/string.c
    src/StringList.cxx
    src/Style.cxx
    src/StyleSet.cxx
    src/Symbol.cxx
    src/SystemMenuBar.cxx
    src/TabGroup2.cxx
    src/TabGroup.cxx
    src/TextBuffer.cxx
    src/TextDisplay.cxx
    src/TextEditor.cxx
    src/ThumbWheel.cxx
    src/TiledGroup.cxx
    src/TiledImage.cxx
    src/Tooltip.cxx
    src/UpBox.cxx
    src/utf.c
    src/Valuator.cxx
    src/ValueInput.cxx
    src/ValueOutput.cxx
    src/ValueSlider.cxx
    src/vsnprintf.c
    src/WidgetAssociation.cxx
    src/Widget.cxx
    src/Widget_draw.cxx
    src/Window.cxx
    src/Window_fullscreen.cxx
    src/Window_hotspot.cxx
    src/Window_iconize.cxx
    src/WizardGroup.cxx
    src/xbmImage.cxx
    src/xpmImage.cxx)

# Add an alias target for the FLTK2:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(FLTK2::FLTK2 ALIAS FLTK2)

# Library filename is in lowercase and uses version information.
set_target_properties(FLTK2 PROPERTIES OUTPUT_NAME "fltk" VERSION "2.0")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(FLTK2
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/compat>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        visualc)

target_compile_options(FLTK2
    PRIVATE
        -Wno-narrowing)

# Compiler definitions for shared library
if(${BUILD_SHARED_LIBS})
    target_compile_definitions(FLTK2
        PUBLIC
            FL_SHARED
            FL_LIBRARY
            FL_GL_LIBRARY
            FL_GLUT_LIBRARY
            FL_IMAGES_LIBRARY)
endif()

# ------------
# Dependencies
# ------------

find_package(OpenGL REQUIRED)

if (WIN32)
    # TODO: JPEG::JPEG and PNG::PNG for Windows
    
    # Compiler definitions for Windows builds
    target_compile_definitions(FLTK2
        PUBLIC
            _WIN32
            WIN32_LEAN_AND_MEAN
            VC_EXTRA_LEAN
            WIN32_EXTRA_LEAN)
else()
    # Use X11 on Unix systems
    find_package(X11 REQUIRED)
    find_package(JPEG REQUIRED)
    find_package(PNG REQUIRED)

    # Define CMake imported targets for packages that does not support imported
    # targets yet.

    if (NOT TARGET X11::X11)
        message(STATUS "Create imported target X11::X11")
        add_library(X11::X11 SHARED IMPORTED)
        set_target_properties(X11::X11 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${X11_INCLUDE_DIR})
        foreach(lib ${X11_LIBRARIES})
            set_target_properties(X11::X11 PROPERTIES IMPORTED_LOCATION ${lib})
        endforeach(lib)
    endif()

    # X11 Input extension library
    if(NOT TARGET X11::Xi)
        # We require the library
        if(NOT ${X11_Xi_FOUND})
            message(FATAL_ERROR "X11 Input extension library (Xi) not found")
        endif()
        message(STATUS "Create imported target X11::Xi")
        add_library(X11::Xi SHARED IMPORTED)
        set_target_properties(X11::Xi PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${X11_Xi_INCLUDE_PATH})
        set_target_properties(X11::Xi PROPERTIES IMPORTED_LOCATION ${X11_Xi_LIB})
    endif()

    if(NOT TARGET JPEG::JPEG)
        message(STATUS "Create imported target JPEG::JPEG")
        add_library(JPEG::JPEG SHARED IMPORTED)
        set_target_properties(JPEG::JPEG PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${JPEG_INCLUDE_DIR})
        foreach(lib ${JPEG_LIBRARIES})
            set_target_properties(JPEG::JPEG PROPERTIES IMPORTED_LOCATION ${lib})
        endforeach()
    endif()

    # FLTK2 depends on X11
    target_link_libraries(FLTK2
        X11::X11
        X11::Xi)
endif()

# The imported targets are loaded specifically for the platform.
target_link_libraries(FLTK2
    OpenGL::GL
    JPEG::JPEG
    PNG::PNG)

# -----------------------
# Installation and Export
# -----------------------

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS FLTK2 EXPORT FLTK2Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install FLTK2 header files
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT FLTK2Targets NAMESPACE FLTK2:: DESTINATION lib/cmake/FLTK2)
install(FILES FLTK2Config.cmake DESTINATION lib/cmake/FLTK2)

# This makes the project importable from the build directory
export(TARGETS FLTK2 NAMESPACE FLTK2:: FILE FLTK2Targets.cmake)
