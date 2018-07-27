project(cg_ext LANGUAGES CXX)

# Load required imported targets
find_package(cgv_gui REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_utils REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cg_icons REQUIRED)

add_library(cg_ext
    # Source Files
	src/axis_aligned_box_gui.cxx
	src/bit_field_controler.cxx
	src/file_name_gui.cxx
	src/fmat_gui.cxx
	src/fvec_gui.cxx
	src/light_source_gui.cxx
	src/material_gui.cxx

    # Public Headers
	include/cg_ext/bit_field_controler.h
	include/cg_ext/lib_begin.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cg_ext ALIAS cg_ext)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(cg_ext
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

set_target_properties(cg_ext PROPERTIES
    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    DEFINE_SYMBOL "CGV_GUI_EXT_EXPORTS"

    # Set folder for Visual Studio
    FOLDER "Standard Plugins")

# Dependencies on other components, plugins and libraries.
target_link_libraries(cg_ext
    PUBLIC
		cgv::gui
		cgv::base
		cgv::type
		cgv::math
		cgv::utils
		cgv::media
        cgv::cg_icons)

if(WIN32 AND NOT ${BUILD_SHARED_LIBS})
	# Add additional dependencies for static Windows builds
	target_link_libraries(cg_fltk INTERFACE Comdlg32)
endif()

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
    set_target_properties(cg_ext PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(cg_ext PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cg_ext EXPORT cg_extTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cg_extTargets NAMESPACE cgv:: DESTINATION cmake/cg_ext)
install(FILES cg_extConfig.cmake DESTINATION cmake/cg_ext)

# This makes the project importable from the build directory
export(TARGETS cg_ext NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cg_extTargets.cmake)
file(COPY cg_extConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
