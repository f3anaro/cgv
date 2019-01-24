project(cgv_examples LANGUAGES CXX)

# Load required imported targets
find_package(cgv_base REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_gl REQUIRED)
find_package(cgv_reflect_types REQUIRED)
find_package(delaunay REQUIRED)

set(IMAGES
	resources/alhambra.png
	resources/cartuja.png
	resources/testimg.jpg)

set(SHADERS
	shader/bump_mapper.glfs
	shader/bump_mapper.glpr
	shader/bump_mapper.glvs
	shader/gpu_test.glfs
	shader/gpu_test.glpr
	shader/gpu_test.glvs
	shader/my_support_functions.glsl
	shader/ping_pong.glfs
	shader/ping_pong.glpr
	shader/ping_pong.glvs
	shader/shader_test.glfs
	shader/shader_test.glpr
	shader/shader_test.glvs)

add_library(cgv_examples
	# Source files
	src/base_provider_test.cxx
	src/browser_test.cxx
	src/buffer_test.cxx
	src/bump_mapper.cxx
	src/cube_demo.cxx
	src/depth_peeler_test.cxx
	src/ear_cutting.cxx
	src/gl_delaunay_mesh_draw.cxx
	src/gpu_test.cxx
	src/gui_test.cxx
	src/image_view.cxx
	src/infinite_grid.cxx
	src/mouse_tracker.cxx
	src/n_rook_estimator.cxx
	src/picker.cxx
	src/ping_pong.cxx
	src/random_sampler.cxx
	src/renderer_tests.cxx
	src/shader_test.cxx
	src/shape.cxx
	src/simple_cube.cxx
	src/snell.cxx
	src/textured_shape.cxx
	src/video_creator.cxx
	src/video_drawable.cxx
	src/webserver_test.cxx

	# Public headers (Visual Studio only)
	include/bump_mapper.h
	include/gl_delaunay_mesh_draw.h
	include/mouse_tracker.h
	include/picker.h
	include/shape.h

	# Shader files
	${SHADERS})

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
	target_sources(cgv_examples PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${image}.cxx)
endforeach()

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cgv_examples ALIAS cgv_examples)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(cgv_examples PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(cgv_examples PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# ---------------
# Shader handling
# ---------------
#
# For shared builds, the shader files are copied into the build directory in
# shader/ next to the runtime directory (bin/). If we are building a static
# library or the option "REGISTER_SHADERS" is set to TRUE, the resources are
# compiled into the library and registered as string resource.

if(REGISTER_SHADERS OR NOT ${BUILD_SHARED_LIBS})
	# The shader resource generator is a simply Python script.
	find_package(PythonInterp 3 REQUIRED)

	# Tell CMake how to generate inline shader resources
	set(RESOURCES)
	foreach(shader IN LISTS SHADERS)
		add_custom_command(
			OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${shader}.cxx
			COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tool/res_prep/strres_prep.py
				${CMAKE_CURRENT_SOURCE_DIR}/${shader}
				${CMAKE_CURRENT_BINARY_DIR}/${shader}.cxx
			MAIN_DEPENDENCY ${shader}
			DEPENDS ${CMAKE_SOURCE_DIR}/tool/res_prep/strres_prep.py)

		list(APPEND RESOURCES ${CMAKE_CURRENT_BINARY_DIR}/${shader}.cxx)
	endforeach()

	# Add generated shader resources to library target.
	target_sources(cgv_examples PRIVATE ${RESOURCES})
else()
	# Get the output directory for executables. By using the property of the
	# target, we do not need to distinguish different platforms.
	get_target_property(RUNTIME_OUTPUT cgv_examples RUNTIME_OUTPUT_DIRECTORY)

	# Just copy all shader files after successful build into shader/ next to
	# bin/ directory.
	foreach(shader IN LISTS SHADERS)
		add_custom_command(TARGET cgv_examples POST_BUILD
			COMMAND ${CMAKE_COMMAND} -E copy_if_different
				${CMAKE_CURRENT_SOURCE_DIR}/${shader}
				${RUNTIME_OUTPUT}/../${shader})
	endforeach()
endif()

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(cgv_examples
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

set_target_properties(cgv_examples PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "CGV_EXAMPLES_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Standard Plugins")

# Move shader files into "Shaders" folder in Visual Studio.
source_group("Shaders" FILES ${SHADERS})

# Dependencies on other components, plugins and libraries.
target_link_libraries(cgv_examples
	PUBLIC
		cgv::base
		cgv::gui
		cgv::render
		cgv::math
		cgv::cgv_gl
		cgv::reflect_types
		cgv::delaunay)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cgv_examples EXPORT cgv_examplesTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_examplesTargets NAMESPACE cgv:: DESTINATION cmake/cgv_examples)
install(FILES cgv_examplesConfig.cmake DESTINATION cmake/cgv_examples)

# This makes the project importable from the build directory
export(TARGETS cgv_examples NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_examplesTargets.cmake)
file(COPY cgv_examplesConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
