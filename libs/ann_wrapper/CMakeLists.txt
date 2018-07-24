project(ann_wrapper LANGUAGES CXX)

# Load required imported targets
find_package(ANN REQUIRED)
find_package(cgv_math REQUIRED)

add_library(ann_wrapper
	src/ann_wrapper.cxx

	# Public headers
	include/ann_wrapper/ann.h
	include/ann_wrapper/lib_begin.h)

# CGV uses C++11 standard
target_compile_features(ann_wrapper PUBLIC cxx_std_11)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::ann_wrapper ALIAS ann_wrapper)

target_include_directories(ann_wrapper
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

set_target_properties(ann_wrapper PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "ANN_WRAPPER_EXPORT"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Dependencies on other components and libraries
target_link_libraries(ann_wrapper
	ANN::ANN
	cgv::math)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(ann_wrapper PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(ann_wrapper PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ann_wrapper EXPORT ann_wrapperTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT ann_wrapperTargets NAMESPACE cgv:: DESTINATION cmake/ann_wrapper)
install(FILES ann_wrapperConfig.cmake DESTINATION cmake/ann_wrapper)

# This makes the project importable from the build directory
export(TARGETS ann_wrapper NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/ann_wrapperTargets.cmake)
file(COPY ann_wrapperConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
