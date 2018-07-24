project(cgv_gl LANGUAGES CXX)

# Load required imported targets
find_package(cgv_render REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_os REQUIRED)
find_package(cgv_reflect_types REQUIRED)
find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)

# OpenGL Utility Library (GLU) is required
if (NOT TARGET OpenGL::GLU)
	message(FATAL_ERROR "GLU (OpenGL Utility Library) was not found")
endif()

# Generate header files from pre-header templates. Ensure that the output
# directory exists.
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl)

add_custom_command(
	OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl/gl_context_switch.h
	COMMAND ppp
		-CGV_DIR=${CMAKE_SOURCE_DIR}
		${CMAKE_CURRENT_SOURCE_DIR}/include/cgv_gl/gl/gl_context_switch.ph
		${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl/gl_context_switch.h
	MAIN_DEPENDENCY include/cgv_gl/gl/gl_context_switch.ph)

set(SHADERS
	shader/box.glfs
	shader/box.glgs
	shader/box.glpr
	shader/box.glvs
	shader/box_wire.glfs
	shader/box_wire.glgs
	shader/box_wire.glpr
	shader/box_wire.glvs
	shader/bump_map.glfs
	shader/ellipsoid.glfs
	shader/ellipsoid.glvs
	shader/ellipsoid_base.glfs
	shader/ellipsoid_base.glgs
	shader/group.glsl
	shader/lighting.glsl
	shader/normal.glfs
	shader/normal.glgs
	shader/normal.glpr
	shader/normal.glvs
	shader/point.glfs
	shader/point.glgs
	shader/point.glpr
	shader/point.glvs
	shader/side.glsl
	shader/sphere.glfs
	shader/sphere.glpr
	shader/sphere.glvs
	shader/sphere.pglfs
	shader/sphere.pglvs
	shader/sphere_base.glfs
	shader/sphere_base.glgs
	shader/textured_material.glfs
	shader/textured_material.glpr
	shader/textured_material.glvs)

add_library(cgv_gl
	# Source Files
	src/box_renderer.cxx
	src/box_wire_renderer.cxx
	src/group_renderer.cxx
	src/line_renderer.cxx
	src/normal_renderer.cxx
	src/point_renderer.cxx
	src/renderer.cxx
	src/surface_renderer.cxx

	src/gl/gl.cxx
	src/gl/gl_context_unix.cxx
	src/gl/gl_context_win32.cxx
	src/gl/gl_cursor.cxx
	src/gl/gl_depth_peeler.cxx
	src/gl/gl_implicit_surface_drawable_base.cxx
	src/gl/gl_mesh_drawable_base.cxx
	src/gl/gl_performance_monitor.cxx
	src/gl/gl_texture_tools.cxx
	src/gl/gl_tools.cxx
	src/gl/gl_transparent_renderer.cxx
	src/gl/gl_view.cxx
	src/gl/gl_context.cxx
	src/gl/gl_image_drawable_base.cxx

	# Public Headers
	include/cgv_gl/box_renderer.h
	include/cgv_gl/box_wire_renderer.h
	include/cgv_gl/gl/gl.h
	include/cgv_gl/gl/gl_context.h
	include/cgv_gl/gl/gl_cursor.h
	include/cgv_gl/gl/gl_depth_peeler.h
	include/cgv_gl/gl/gl_image_drawable_base.h
	include/cgv_gl/gl/gl_implicit_surface_drawable_base.h
	include/cgv_gl/gl/gl_mesh_drawable_base.h
	include/cgv_gl/gl/gl_performance_monitor.h
	include/cgv_gl/gl/gl_tools.h
	include/cgv_gl/gl/gl_transparent_renderer.h
	include/cgv_gl/gl/gl_view.h
	include/cgv_gl/gl/lib_begin.h
	include/cgv_gl/gl/wgl.h
	include/cgv_gl/group_renderer.h
	include/cgv_gl/line_renderer.h
	include/cgv_gl/normal_renderer.h
	include/cgv_gl/point_renderer.h
	include/cgv_gl/renderer.h
	include/cgv_gl/surface_renderer.h

	# Generated headers
	${CMAKE_CURRENT_BINARY_DIR}/include/cgv_gl/gl/gl_context_switch.h

	# Shader files
	${SHADERS})

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::cgv_gl ALIAS cgv_gl)

set_target_properties(cgv_gl PROPERTIES
	# Append "cgv_" prefix to the library filename.
	OUTPUT_NAME "cgv_gl"

	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "CGV_RENDER_GL_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(cgv_gl PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(cgv_gl PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Move shader files into "Shaders" folder in Visual Studio.
source_group("Shaders" FILES ${SHADERS})

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
	target_sources(cgv_gl PRIVATE ${RESOURCES})
else()
	# Get the output directory for executables. By using the property of the
	# target, we do not need to distinguish different platforms.
	get_target_property(RUNTIME_OUTPUT cgv_gl RUNTIME_OUTPUT_DIRECTORY)

	# Just copy all shader files after successful build into shader/ next to
	# bin/ directory.
	foreach(shader IN LISTS SHADERS)
		add_custom_command(TARGET cgv_gl POST_BUILD
			COMMAND ${CMAKE_COMMAND} -E copy_if_different
				${CMAKE_CURRENT_SOURCE_DIR}/${shader}
				${RUNTIME_OUTPUT}/../${shader})
	endforeach()
endif()

target_include_directories(cgv_gl
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		# Adding the build directory for generated header files
		$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# FIXME: For unicode support the definitions _UNICODE and UNICODE have to be
#     set. Can we do this better?
target_compile_definitions(cgv_gl
	PUBLIC
		UNICODE
		_UNICODE)

if(${BUILD_SHARED_LIBS})
	# Compiler definitions for shared library
	target_compile_definitions(cgv_gl PUBLIC CGV_RENDER_GL_EXPORTS)
else()
	# Compiler definitions for static library
	target_compile_definitions(cgv_gl PUBLIC CGV_RENDER_GL_FORCE_STATIC)
endif()

# CGV uses C++11 standard
target_compile_features(cgv_gl PUBLIC cxx_std_11)

# Dependencies on other components and libraries
target_link_libraries(cgv_gl
	PUBLIC
		cgv::render
		cgv::gui
		cgv::os
		GLEW::GLEW
		OpenGL::GLU
		cgv::reflect_types)

if(WIN32)
	# Link required Windows libraries
	target_link_libraries(cgv_gl INTERFACE user32 gdi32)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cgv_gl EXPORT cgv_glTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install shader files
install(DIRECTORY shader/ DESTINATION ${CMAKE_INSTALL_BINDIR}/../shader)

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT cgv_glTargets NAMESPACE cgv:: DESTINATION cmake/cgv_gl)
install(FILES cgv_glConfig.cmake DESTINATION cmake/cgv_gl)

# This makes the project importable from the build directory
export(TARGETS cgv_gl NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_glTargets.cmake)
file(COPY cgv_glConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
