project(cgv_media LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)

add_library(media
	# Source files
	src/colored_model.cxx
	src/color_scale.cxx
	src/color_storage.cxx
	src/font/font.cxx
	src/font/font_server.cxx
	src/illum/light_source.cxx
	src/illum/phong_material.cxx
	src/illum/surface_material.cxx
	src/illum/textured_surface_material.cxx
	src/image/bmp_reader.cxx
	src/image/bmp_writer.cxx
	src/image/image_reader.cxx
	src/image/image_writer.cxx
	src/mesh/marching_cubes.cxx
	src/mesh/obj_loader.cxx
	src/mesh/obj_reader.cxx
	src/mesh/simple_mesh.cxx
	src/riff.cxx
	src/video/video_reader.cxx
	src/video/video_writer.cxx

	# Public headers (Visual Studio only)
	include/cgv/media/axis_aligned_box.h
	include/cgv/media/colored_model.h
	include/cgv/media/color.h
	include/cgv/media/color_scale.h
	include/cgv/media/color_storage.h
	include/cgv/media/font/font.h
	include/cgv/media/font/font_server.h
	include/cgv/media/font/lib_begin.h
	include/cgv/media/illum/lib_begin.h
	include/cgv/media/illum/surface_material.h
	include/cgv/media/illum/textured_surface_material.h
	include/cgv/media/image/bmp_reader.h
	include/cgv/media/image/bmp_writer.h
	include/cgv/media/image/image.h
	include/cgv/media/image/image_proc.h
	include/cgv/media/image/image_reader.h
	include/cgv/media/image/image_writer.h
	include/cgv/media/image/lib_begin.h
	include/cgv/media/lib_begin.h
	include/cgv/media/mesh/cuberille.h
	include/cgv/media/mesh/dual_contouring.h
	include/cgv/media/mesh/marching_cubes.h
	include/cgv/media/mesh/obj_loader.h
	include/cgv/media/mesh/obj_reader.h
	include/cgv/media/mesh/simple_mesh.h
	include/cgv/media/mesh/streaming_mesh.h
	include/cgv/media/plane.h
	include/cgv/media/ray.h
	include/cgv/media/riff.h
	include/cgv/media/sphere.h
	include/cgv/media/text/advanced_scan.h
	include/cgv/media/text/callback_stream.h
	include/cgv/media/text/convert.h
	include/cgv/media/text/convert_string.h
	include/cgv/media/text/scan.h
	include/cgv/media/text/token.h
	include/cgv/media/text/tokenizer.h
	include/cgv/media/video/lib_begin.h
	include/cgv/media/video/video_reader.h
	include/cgv/media/video/video_writer.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::media ALIAS media)

set_target_properties(media PROPERTIES
	# Append "cgv_" prefix to the library filename.
	OUTPUT_NAME "cgv_media"

	# Set folder for Visual Studio
	FOLDER "CGV-Framework")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(media PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(media PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

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
install(EXPORT cgv_mediaTargets NAMESPACE cgv:: DESTINATION cmake/cgv_media)
install(FILES cgv_mediaConfig.cmake DESTINATION cmake/cgv_media)

# This makes the project importable from the build directory
export(TARGETS media NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_mediaTargets.cmake)
file(COPY cgv_mediaConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
