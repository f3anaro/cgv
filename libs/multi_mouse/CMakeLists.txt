project(multi_mouse LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)
find_package(cgv_gui REQUIRED)
find_package(FLTK2 REQUIRED)

add_library(multi_mouse 
	# Source files
	src/multi_mouse.cxx
	src/multi_mouse_win32.cxx

	# Public headers (Visual Studio only)
	include/multi_mouse/lib_begin.h
	include/multi_mouse/multi_mouse.h
	include/multi_mouse/multi_mouse_detail.h
	include/multi_mouse/multi_mouse_win32.h)

add_library(multi_mouse_fltk
	# Source files
	src/multi_mouse_fltk.cxx

	# Public headers (Visual Studio only)
	include/multi_mouse/lib_begin_fltk.h
	include/multi_mouse/multi_mouse_fltk.h)

# Add executable that will be used as CTest test case
add_executable(multi_mouse_test
	test/sample_application.h
	test/sample_application.cxx
	test/multi_mouse_fltk_test.cxx)

add_test(NAME multi_mouse_test
	COMMAND multi_mouse_test)

# CGV uses C++11 standard
target_compile_features(multi_mouse PUBLIC cxx_std_11)
target_compile_features(multi_mouse_fltk PUBLIC cxx_std_11)
target_compile_features(multi_mouse_test PUBLIC cxx_std_11)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::multi_mouse ALIAS multi_mouse)
add_library(cgv::multi_mouse_fltk ALIAS multi_mouse_fltk)

target_include_directories(multi_mouse
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

target_include_directories(multi_mouse_fltk
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

set_target_properties(multi_mouse PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "MULTI_MOUSE_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

set_target_properties(multi_mouse_fltk PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "MULTI_MOUSE_FLTK_EXPORTS"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Dependencies on other components and libraries
target_link_libraries(multi_mouse
	cgv::utils
	cgv::gui)

target_link_libraries(multi_mouse_fltk
	multi_mouse
	FLTK2::FLTK2)

target_link_libraries(multi_mouse_test
	multi_mouse_fltk)

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(multi_mouse PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})

	set_target_properties(multi_mouse_fltk PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(multi_mouse PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

	set_target_properties(multi_mouse_fltk PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS multi_mouse multi_mouse_fltk EXPORT multi_mouseTargets
	ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT multi_mouseTargets NAMESPACE cgv:: DESTINATION cmake/multi_mouse)
install(FILES multi_mouseConfig.cmake DESTINATION cmake/multi_mouse)

# This makes the project importable from the build directory
export(TARGETS multi_mouse multi_mouse_fltk NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/multi_mouseTargets.cmake)
file(COPY multi_mouseConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
