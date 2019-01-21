project(cmv_avi LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_media REQUIRED)

add_library(cmv_avi
    # Source Files
	src/avi_video_reader.cxx
	src/avi_video_writer.cxx

    # Public Headers
	include/cmv_avi/avi_video_reader.h
	include/cmv_avi/avi_video_writer.h
	include/cmv_avi/lib_begin.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cmv_avi ALIAS cmv_avi)

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(cmv_avi
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

set_target_properties(cmv_avi PROPERTIES
    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    DEFINE_SYMBOL "CGV_MEDIA_VIDEO_WIN_EXPORTS"

    # Set folder for Visual Studio
    FOLDER "Standard Plugins")

if(WIN32 AND NOT ${BUILD_SHARED_LIBS})
    # Add additional dependencies for static Windows builds
    target_link_libraries(cmv_avi PUBLIC Vfw32)
endif()

# Dependencies on other components, plugins and libraries.
target_link_libraries(cmv_avi
    PUBLIC
		cgv::utils
		cgv::type
		cgv::media)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
    set_target_properties(cmv_avi PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(cmv_avi PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cmv_avi EXPORT cmv_aviTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component.
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cmv_aviTargets NAMESPACE cgv:: DESTINATION cmake/cmv_avi)
install(FILES cmv_aviConfig.cmake DESTINATION cmake/cmv_avi)

# This makes the project importable from the build directory
export(TARGETS cmv_avi NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cmv_aviTargets.cmake)
file(COPY cmv_aviConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
