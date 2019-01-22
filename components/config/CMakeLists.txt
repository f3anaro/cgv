project(cgv_config LANGUAGES CXX)

# Define header-only (interface) library
add_library(config INTERFACE)

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::config ALIAS config)

# Define headers for this header-only library.
target_include_directories(config
	INTERFACE
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# CGV uses C++11 standard
target_compile_features(config INTERFACE cxx_std_11)

# HACK: Currently, CMake does not generate any IDE project for interface
#   libraries. We use a custom target to create a pseudo-target called
#   "config_ide".
if (MSVC)
	add_custom_target(config_ide SOURCES
		include/cgv/config/cpp_version.h
		include/cgv/config/lib_begin.h
		include/cgv/config/lib_end.h)

	set_target_properties(config_ide PROPERTIES
		# Set name of the target in an Visual Studio
		PROJECT_LABEL "config"

		# Set folder for Visual Studio
		FOLDER "CGV-Framework")
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS config EXPORT cgv_configTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of component
install(DIRECTORY include/
	DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory.
# Put config file in per-project dir (name MUST match).
install(EXPORT cgv_configTargets NAMESPACE cgv:: DESTINATION cmake/cgv_config)
install(FILES cgv_configConfig.cmake DESTINATION cmake/cgv_config)

# This makes the project importable from the build directory
export(TARGETS config NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/cgv_configTargets.cmake)
file(COPY cgv_configConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
