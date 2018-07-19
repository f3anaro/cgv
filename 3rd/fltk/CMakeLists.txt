cmake_minimum_required(VERSION 3.8)
project(FLTK2 VERSION 2.0)

# Load required imported targets
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)
find_package(JPEG REQUIRED)
find_package(PNG REQUIRED)

# Define CMake imported targets for packages that does not support
# imported targets yet.
if(NOT TARGET JPEG::JPEG)
    message(STATUS "Create imported target JPEG::JPEG")
    add_library(JPEG::JPEG SHARED IMPORTED)
    set_target_properties(JPEG::JPEG PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${JPEG_INCLUDE_DIR})
    foreach(lib ${JPEG_LIBRARIES})
        set_target_properties(JPEG::JPEG PROPERTIES IMPORTED_LOCATION ${lib})
    endforeach()
endif()

set(PRIVATE_HEADERS
    src/ARRAY.h
    src/colormap.h
    src/fastarrow.h
    src/mediumarrow.h
    src/slowarrow.h
    src/win32/pktdef.h
    src/win32/wintab.h
    src/x11/IFont.h
    src/x11/XColorMap.h)

set(COMPAT_SOURCES
    compat/FL/Enumerations.H
    compat/FL/Fl.H
    compat/FL/Fl_Adjuster.H
    compat/FL/Fl_Box.H
    compat/FL/Fl_Browser.H
    compat/FL/Fl_Button.H
    compat/FL/Fl_Chart.H
    compat/FL/Fl_Check_Button.H
    compat/FL/Fl_Choice.H
    compat/FL/Fl_Clock.H
    compat/FL/Fl_Color_Chooser.H
    compat/FL/Fl_Counter.H
    compat/FL/Fl_Dial.H
    compat/FL/Fl_Double_Window.H
    compat/FL/Fl_File_Chooser.H
    compat/FL/Fl_Gl_Window.H
    compat/FL/Fl_Group.H
    compat/FL/Fl_Hold_Browser.H
    compat/FL/Fl_Hor_Slider.H
    compat/FL/Fl_Hor_Value_Slider.H
    compat/FL/Fl_Input.H
    compat/FL/Fl_Int_Input.H
    compat/FL/Fl_Light_Button.H
    compat/FL/Fl_Menu_.H
    compat/FL/Fl_Menu_Bar.H
    compat/FL/Fl_Menu_Button.H
    compat/FL/Fl_Menu_Item.H
    compat/FL/Fl_Output.H
    compat/FL/Fl_Overlay_Window.H
    compat/FL/Fl_Pack.H
    compat/FL/Fl_Pixmap.H
    compat/FL/Fl_Return_Button.H
    compat/FL/Fl_Roller.H
    compat/FL/Fl_Scroll.H
    compat/FL/Fl_Scrollbar.H
    compat/FL/Fl_Select_Browser.H
    compat/FL/Fl_Shared_Image.H
    compat/FL/Fl_Single_Window.H
    compat/FL/Fl_Slider.H
    compat/FL/Fl_Tabs.H
    compat/FL/Fl_Text_Buffer.H
    compat/FL/Fl_Text_Editor.H
    compat/FL/Fl_Tile.H
    compat/FL/Fl_Toggle_Button.H
    compat/FL/Fl_Toggle_Light_Button.H
    compat/FL/Fl_Valuator.H
    compat/FL/Fl_Value_Input.H
    compat/FL/Fl_Value_Output.H
    compat/FL/Fl_Value_Slider.H
    compat/FL/Fl_Widget.H
    compat/FL/Fl_Window.H
    compat/FL/filename.H
    compat/FL/fl_ask.H
    compat/FL/fl_draw.H
    compat/FL/fl_message.H
    compat/FL/forms.H
    compat/FL/gl.h
    compat/FL/glut.H
    compat/FL/math.h
    compat/FL/menubar.h
    compat/FL/x.H)

set(IMAGES_SOURCES
    images/FileIcon2.cxx
    images/Fl_Guess_Image.cxx
    images/fl_jpeg.cxx
    images/fl_png.cxx
    images/HelpDialog.cxx
    images/HelpDialog.fl
    images/images_core.cxx
    images/Makefile
    images/pnmImage.cxx
    images/xpmFileImage.cxx)

set(OpenGL_SOURCES
    OpenGL/Fl_Gl_Choice.cxx
    OpenGL/Fl_Gl_Overlay.cxx
    OpenGL/Fl_Gl_Window.cxx
    OpenGL/GlChoice.h
    OpenGL/gl_draw.cxx
    OpenGL/gl_start.cxx)

add_library(FLTK2
    # Source Files
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
    src/xpmImage.cxx

    # Public Headers
    include/fltk/Adjuster.h
    include/fltk/AlignGroup.h
    include/fltk/AnsiWidget.h
    include/fltk/BarGroup.h
    include/fltk/Box.h
    include/fltk/Browser.h
    include/fltk/Button.h
    include/fltk/CheckButton.h
    include/fltk/Choice.h
    include/fltk/Clock.h
    include/fltk/Color.h
    include/fltk/ColorChooser.h
    include/fltk/ComboBox.h
    include/fltk/Cursor.h
    include/fltk/CycleButton.h
    include/fltk/Dial.h
    include/fltk/Divider.h
    include/fltk/DoubleBufferWindow.h
    include/fltk/FL_API.h
    include/fltk/FL_VERSION.h
    include/fltk/FileBrowser.h
    include/fltk/FileChooser.h
    include/fltk/FileIcon.h
    include/fltk/FileInput.h
    include/fltk/FillDial.h
    include/fltk/FillSlider.h
    include/fltk/Flags.h
    include/fltk/FloatInput.h
    include/fltk/Font.h
    include/fltk/GlWindow.h
    include/fltk/Group.h
    include/fltk/HelpDialog.h
    include/fltk/HelpView.h
    include/fltk/HighlightButton.h
    include/fltk/Image.h
    include/fltk/Input.h
    include/fltk/InputBrowser.h
    include/fltk/IntInput.h
    include/fltk/InvisibleBox.h
    include/fltk/Item.h
    include/fltk/ItemGroup.h
    include/fltk/LabelType.h
    include/fltk/LightButton.h
    include/fltk/LineDial.h
    include/fltk/Menu.h
    include/fltk/MenuBar.h
    include/fltk/MenuBuild.h
    include/fltk/MenuWindow.h
    include/fltk/Monitor.h
    include/fltk/MultiBrowser.h
    include/fltk/MultiImage.h
    include/fltk/MultiLineInput.h
    include/fltk/MultiLineOutput.h
    include/fltk/NumericInput.h
    include/fltk/Output.h
    include/fltk/PackedGroup.h
    include/fltk/PixelType.h
    include/fltk/PopupMenu.h
    include/fltk/Preferences.h
    include/fltk/ProgressBar.h
    include/fltk/RadioButton.h
    include/fltk/RadioItem.h
    include/fltk/RadioLightButton.h
    include/fltk/Rectangle.h
    include/fltk/RepeatButton.h
    include/fltk/ReturnButton.h
    include/fltk/ScrollGroup.h
    include/fltk/Scrollbar.h
    include/fltk/SecretInput.h
    include/fltk/ShapedWindow.h
    include/fltk/SharedImage.h
    include/fltk/Slider.h
    include/fltk/StatusBarGroup.h
    include/fltk/StringList.h
    include/fltk/Style.h
    include/fltk/StyleSet.h
    include/fltk/Symbol.h
    include/fltk/SystemMenuBar.h
    include/fltk/TabGroup.h
    include/fltk/TextBuffer.h
    include/fltk/TextDisplay.h
    include/fltk/TextEditor.h
    include/fltk/Threads.h
    include/fltk/ThumbWheel.h
    include/fltk/TiledGroup.h
    include/fltk/TiledImage.h
    include/fltk/ToggleButton.h
    include/fltk/ToggleItem.h
    include/fltk/Tooltip.h
    include/fltk/Valuator.h
    include/fltk/ValueInput.h
    include/fltk/ValueOutput.h
    include/fltk/ValueSlider.h
    include/fltk/Widget.h
    include/fltk/WidgetAssociation.h
    include/fltk/Window.h
    include/fltk/WizardGroup.h
    include/fltk/WordwrapInput.h
    include/fltk/WordwrapOutput.h
    include/fltk/ask.h
    include/fltk/damage.h
    include/fltk/dirent.h
    include/fltk/draw.h
    include/fltk/error.h
    include/fltk/events.h
    include/fltk/file_chooser.h
    include/fltk/filename.h
    include/fltk/fltk_cairo.h
    include/fltk/forms.h
    include/fltk/gl.h
    include/fltk/gl2opengl.h
    include/fltk/glut.h
    include/fltk/layout.h
    include/fltk/load_plugin.h
    include/fltk/math.h
    include/fltk/osx.h
    include/fltk/pnmImage.h
    include/fltk/rgbImage.h
    include/fltk/run.h
    include/fltk/show_colormap.h
    include/fltk/string.h
    include/fltk/utf.h
    include/fltk/visual.h
    include/fltk/win32.h
    include/fltk/x.h
    include/fltk/x11.h
    include/fltk/xbmImage.h
    include/fltk/xpmImage.h

    # Private Headers
    ${PRIVATE_HEADERS}
    ${COMPAT_SOURCES}
    ${IMAGES_SOURCES}
    ${OpenGL_SOURCES})

# Add an alias target for the FLTK2:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(FLTK2::FLTK2 ALIAS FLTK2)

set_target_properties(FLTK2 PROPERTIES
    # Library filename is in lowercase and uses version information.
    OUTPUT_NAME "fltk"
    VERSION "2.0"

    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    #
    # Note:
    #    FLTK2 uses multiple export/import declarations based on different
    #    pre-processor definitions. Hence, we have use a list of definitions
    #    here.
    #
    DEFINE_SYMBOL "FL_LIBRARY;FL_GL_LIBRARY;FL_GLUT_LIBRARY;FL_IMAGES_LIBRARY"

    # Set folder for Visual Studio
    FOLDER "3rd-Party Libraries")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(FLTK2
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        compat
        visualc)

# Ignore narrowing on Unix platforms
if(UNIX)
    target_compile_options(FLTK2 PRIVATE -Wno-narrowing)
endif()

# Add common compiler definitions
target_compile_definitions(FLTK2
    PUBLIC
        USE_GLEW)

# Compiler definitions for shared library
if(${BUILD_SHARED_LIBS})
    target_compile_definitions(FLTK2
        PUBLIC
            FL_SHARED)
endif()

# Build library in directories matching the installation layout.
if(WIN32)
    set_target_properties(FLTK2 PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(FLTK2 PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Move private headers into "Source Files" folder and create extra folder for
# "Compat", Images" and "OpenGL" in Visual Studio.
source_group("Source Files" FILES ${PRIVATE_HEADERS})
source_group("Compat" FILES ${COMPAT_SOURCES})
source_group("Images" FILES ${IMAGES_SOURCES})
source_group("OpenGL" FILES ${OpenGL_SOURCES})

# ------------
# Dependencies
# ------------

# The imported targets are loaded specifically for the platform.
target_link_libraries(FLTK2
    PUBLIC
        OpenGL::GL
        GLEW::GLEW
        JPEG::JPEG
        PNG::PNG)

if (WIN32)
    # Compiler definitions for Windows builds
    target_compile_definitions(FLTK2
        PUBLIC
            _WIN32
            WIN32_LEAN_AND_MEAN
            VC_EXTRA_LEAN
            WIN32_EXTRA_LEAN)

    # Required Windows libraries
    target_link_libraries(FLTK2
        PUBLIC
            ws2_32
        INTERFACE
            user32
            gdi32
            msimg32)
else()
    # Use X11 on Unix systems
    find_package(X11 REQUIRED)

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

    # FLTK2 depends on X11
    target_link_libraries(FLTK2
        PUBLIC
            X11::X11
            X11::Xi)
endif()

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
install(EXPORT FLTK2Targets NAMESPACE FLTK2:: DESTINATION cmake/FLTK2)
install(FILES FLTK2Config.cmake DESTINATION cmake/FLTK2)

# This makes the project importable from the build directory
export(TARGETS FLTK2 NAMESPACE FLTK2:: FILE ${CMAKE_BINARY_DIR}/cmake/FLTK2Targets.cmake)
file(COPY FLTK2Config.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
