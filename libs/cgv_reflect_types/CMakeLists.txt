project(cgv_reflect_types LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_type REQUIRED)
find_package(cgv_reflect REQUIRED)
find_package(cgv_media REQUIRED)
find_package(cgv_math REQUIRED)
find_package(cgv_render REQUIRED)
find_package(cgv_gui REQUIRED)

add_library(reflect_types
	# Source files
	src/gui/shortcut.cxx
	src/math/perm_mat.cxx
	src/media/color.cxx
	src/media/illum/light_source.cxx
	src/media/illum/obj_material.cxx
	src/media/illum/phong_material.cxx
	src/media/illum/surface_material.cxx
	src/media/illum/textured_surface_material.cxx
	src/render/context.cxx
	src/render/view.cxx

	# Public headers (Visual Studio only)
	include/cgv_reflect_types/gui/shortcut.h
	include/cgv_reflect_types/lib_begin.h
	include/cgv_reflect_types/math/diag_mat.h
	include/cgv_reflect_types/math/fmat.h
	include/cgv_reflect_types/math/fvec.h
	include/cgv_reflect_types/math/interval.h
	include/cgv_reflect_types/math/low_tri_mat.h
	include/cgv_reflect_types/math/mat.h
	include/cgv_reflect_types/math/perm_mat.h
	include/cgv_reflect_types/math/qem.h
	include/cgv_reflect_types/math/quaternion.h
	include/cgv_reflect_types/math/thin_plate_spline.h
	include/cgv_reflect_types/math/tri_diag_mat.h
	include/cgv_reflect_types/math/up_tri_mat.h
	include/cgv_reflect_types/math/vec.h
	include/cgv_reflect_types/media/axis_aligned_box.h
	include/cgv_reflect_types/media/color.h
	include/cgv_reflect_types/media/illum/light_source.h
	include/cgv_reflect_types/media/illum/obj_material.h
	include/cgv_reflect_types/media/illum/phong_material.h
	include/cgv_reflect_types/media/illum/surface_material.h
	include/cgv_reflect_types/media/illum/textured_surface_material.h
	include/cgv_reflect_types/media/plane.h
	include/cgv_reflect_types/media/ray.h
	include/cgv_reflect_types/media/sphere.h
	include/cgv_reflect_types/render/context.h
	include/cgv_reflect_types/render/view.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::reflect_types ALIAS reflect_types)

set_target_properties(reflect_types PROPERTIES
	# Set full qualified name for the library filename
	OUTPUT_NAME "cgv_reflect_types"

	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "CGV_REFLECT_TYPES_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(reflect_types PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(reflect_types PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

target_include_directories(reflect_types
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# FIXME: For unicode support the definitions _UNICODE and UNICODE have to be
#     set. Can we do this better?
target_compile_definitions(reflect_types
	PUBLIC
		UNICODE
		_UNICODE)

# Dependencies on other components and libraries
target_link_libraries(reflect_types
	cgv::utils
	cgv::type
	cgv::reflect
	cgv::media
	cgv::math
	cgv::render
	cgv::gui)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS reflect_types EXPORT cgv_reflect_typesTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT cgv_reflect_typesTargets NAMESPACE cgv:: DESTINATION cmake/reflect_types)
install(FILES cgv_reflect_typesConfig.cmake DESTINATION cmake/reflect_types)

# This makes the project importable from the build directory
export(TARGETS reflect_types NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_reflect_typesTargets.cmake)
file(COPY cgv_reflect_typesConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
