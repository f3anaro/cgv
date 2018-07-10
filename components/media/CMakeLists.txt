project(cgv_media LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)

add_library(media
    src/color_scale.cxx
    src/riff.cxx
    src/font/font.cxx
    src/font/font_server.cxx
    src/illum/light_source.cxx
    src/image/bmp_reader.cxx
    src/image/bmp_writer.cxx
    src/image/image_reader.cxx
    src/image/image_writer.cxx
    src/mesh/obj_loader.cxx
    src/mesh/obj_reader.cxx
    src/mesh/marching_cubes.cxx
    src/video/video_reader.cxx
    src/video/video_writer.cxx)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::media ALIAS media)

# Append "cgv_" prefix to the library filename.
set_target_properties(media PROPERTIES OUTPUT_NAME "cgv_media")

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(media
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(media
    cgv::utils
    cgv::type
    cgv::math
    cgv::data
    cgv::base)

# CGV uses C++11 standard
target_compile_features(media PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(media
        PUBLIC
            CGV_MEDIA_EXPORTS
            CGV_MEDIA_FONT_EXPORTS
            CGV_MEDIA_ILLUM_EXPORTS
            CGV_MEDIA_IMAGE_EXPORTS
            CGV_MEDIA_VIDEO_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS media EXPORT cgv_mediaTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_mediaTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_media)
install(FILES cgv_mediaConfig.cmake DESTINATION lib/cmake/cgv_media)

# This makes the project importable from the build directory
export(TARGETS media NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cgv_mediaTargets.cmake)
file(COPY cgv_mediaConfig.cmake DESTINATION ${CMAKE_BINARY_DIR})