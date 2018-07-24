project(plot LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_data REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_os REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_gl REQUIRED)

set(SHADERS
	shader/plot1d.glfs
	shader/plot1d.glpr
	shader/plot1d.glvs
	shader/plot1d_bar.glgs
	shader/plot1d_bar.glpr
	shader/plot1d_bar_outline.glgs
	shader/plot1d_bar_outline.glpr
	shader/plot1d_empty.glvs
	shader/plot1d_lib.glsl
	shader/plot1d_stick.glgs
	shader/plot1d_stick.glpr
	shader/plot2d_face.glfs
	shader/plot2d_face.glgs
	shader/plot2d_face.glpr
	shader/plot2d_face.glvs
	shader/plot2d_line.glfs
	shader/plot2d_line.glgs
	shader/plot2d_line.glpr
	shader/plot2d_line.glvs
	shader/plot2d_point.glfs
	shader/plot2d_point.glpr
	shader/plot2d_point.glvs)

add_library(plot
	# Sources
	src/plot1d.cxx
	src/plot2d.cxx
	src/plot_base.cxx

	# Public headers
	include/plot/lib_begin.h
	include/plot/plot1d.h
	include/plot/plot2d.h
	include/plot/plot_base.h

	# Shader files
	${SHADERS})

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::plot ALIAS plot)

set_target_properties(plot PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "PLOT_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Build library in directories matching the installation layout.
if(WIN32)
	set_target_properties(plot PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(plot PROPERTIES
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
	target_sources(plot PRIVATE ${RESOURCES})
else()
	# Get the output directory for executables. By using the property of the
	# target, we do not need to distinguish different platforms.
	get_target_property(RUNTIME_OUTPUT plot RUNTIME_OUTPUT_DIRECTORY)

	# Just copy all shader files after successful build into shader/ next to
	# bin/ directory.
	foreach(shader IN LISTS SHADERS)
		add_custom_command(TARGET plot POST_BUILD
			COMMAND ${CMAKE_COMMAND} -E copy_if_different
				${CMAKE_CURRENT_SOURCE_DIR}/${shader}
				${RUNTIME_OUTPUT}/../${shader})
	endforeach()
endif()

target_include_directories(plot
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# FIXME: For unicode support the definitions _UNICODE and UNICODE have to be
#     set. Can we do this better?
target_compile_definitions(plot
	PUBLIC
		UNICODE
		_UNICODE)

# Dependencies on other components and libraries
target_link_libraries(plot
	cgv::utils
	cgv::type
	cgv::reflect
	cgv::data
	cgv::base
	cgv::media
	cgv::os
	cgv::gui
	cgv::render
	cgv::gl)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS plot EXPORT plotTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install shader files
install(DIRECTORY shader/ DESTINATION ${CMAKE_INSTALL_BINDIR}/../shader)

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT plotTargets NAMESPACE cgv:: DESTINATION cmake/plot)
install(FILES plotConfig.cmake DESTINATION cmake/plot)

# This makes the project importable from the build directory
export(TARGETS plot NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/plotTargets.cmake)
file(COPY plotConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
