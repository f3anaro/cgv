project(cgv_math LANGUAGES CXX)

# Load required imported targets
find_package(cgv_data REQUIRED)

add_library(math
	# Source files
	src/functions.cxx
	src/normal_estimation.cxx
	src/solve_polynom.cxx
	src/sparse_les.cxx

	# Public headers (Visual Studio only)
	include/cgv/math/adjacency_list.h
	include/cgv/math/align.h
	include/cgv/math/bi_polynomial.h
	include/cgv/math/bucket_sort.h
	include/cgv/math/chol.h
	include/cgv/math/color_operations.h
	include/cgv/math/constants.h
	include/cgv/math/det.h
	include/cgv/math/diag_mat.h
	include/cgv/math/distance_transform.h
	include/cgv/math/eig.h
	include/cgv/math/fibo_heap.h
	include/cgv/math/fmat.h
	include/cgv/math/ftransform.h
	include/cgv/math/functions.h
	include/cgv/math/fvec.h
	include/cgv/math/gaussj.h
	include/cgv/math/geom.h
	include/cgv/math/intersections.h
	include/cgv/math/interval.h
	include/cgv/math/inv.h
	include/cgv/math/lib_begin.h
	include/cgv/math/lin_solve.h
	include/cgv/math/low_tri_mat.h
	include/cgv/math/lu.h
	include/cgv/math/mat.h
	include/cgv/math/mfunc.h
	include/cgv/math/model_comp.h
	include/cgv/math/mst.h
	include/cgv/math/normal_estimation.h
	include/cgv/math/perm_mat.h
	include/cgv/math/permute.h
	include/cgv/math/plane.h
	include/cgv/math/point_operations.h
	include/cgv/math/polar.h
	include/cgv/math/polynomial.h
	include/cgv/math/qem.h
	include/cgv/math/qr.h
	include/cgv/math/quaternion.h
	include/cgv/math/quat.h
	include/cgv/math/random.h
	include/cgv/math/ransac.h
	include/cgv/math/rigid_transform.h
	include/cgv/math/solve_polynom.h
	include/cgv/math/sparse_les.h
	include/cgv/math/sparse_mat.h
	include/cgv/math/sphere.h
	include/cgv/math/statistics.h
	include/cgv/math/svd.h
	include/cgv/math/thin_plate_spline.h
	include/cgv/math/transformations.h
	include/cgv/math/tri_diag_mat.h
	include/cgv/math/union_find.h
	include/cgv/math/up_tri_mat.h
	include/cgv/math/vec.h)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::math ALIAS math)

set_target_properties(math PROPERTIES
	# Append "cgv_" prefix to the library filename.
	OUTPUT_NAME "cgv_math"
	
	# Set folder for Visual Studio
	FOLDER "CGV-Framework")

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(math PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(math PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Define headers for this library. PUBLIC headers are used for
# compiling the library, and will be added to consumers' build
# paths.
target_include_directories(math
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# Dependencies on other components
target_link_libraries(math
	cgv::data)

# CGV uses C++11 standard
target_compile_features(math PUBLIC cxx_std_11)

if(${BUILD_SHARED_LIBS})
	# Compiler definitions for shared library
	target_compile_definitions(math PUBLIC CGV_MATH_EXPORTS)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS math EXPORT cgv_mathTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_mathTargets NAMESPACE cgv:: DESTINATION cmake/cgv_math)
install(FILES cgv_mathConfig.cmake DESTINATION cmake/cgv_math)

# This makes the project importable from the build directory
export(TARGETS math NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_mathTargets.cmake)
file(COPY cgv_mathConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
