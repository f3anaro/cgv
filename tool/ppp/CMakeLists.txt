# Statically linked Pre-Preprocessor used in the CGV project.
project(ppp LANGUAGES CXX)

# Load required imported targets
find_package(libppp REQUIRED)

# Define ppp executable
add_executable(ppp
	src/ppp.cxx)

# We do not need the exports because we statically linking against libppp
target_compile_definitions(ppp PUBLIC CGV_FORCE_STATIC)
# target_compile_definitions(ppp PUBLIC CGV_PPP_EXPORTS)

# CGV uses C++11 standard
target_compile_features(ppp PUBLIC cxx_std_11)

# Write executables in bin/ directory inside build directory matching the
# installation layout. If multi-config generators are used, build targets in a
# config-specific subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(ppp PROPERTIES
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(ppp PROPERTIES
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Always link against a static version of libppp. If the target "libppp_static"
# exists this means that there is a shared and a static version of the library.
# Otherwise "libppp" is already a static library.
if(TARGET cgv::libppp_static)
	target_link_libraries(ppp
		cgv::libppp_static)
else()    
	target_link_libraries(ppp
		cgv::libppp)
endif()

# Set folder for Visual Studio
set_target_properties(ppp PROPERTIES FOLDER "Core Tools")

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ppp EXPORT cgv_pppTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory. Put config file
# in per-project dir (name MUST match). An executable has no build dependencies.
# Hence, there is no need to create an extra cgv_pppConfig.cmake file to
# resolve the dependencies. We just use the target defintion file.
install(EXPORT cgv_pppTargets FILE cgv_pppConfig.cmake DESTINATION cmake/cgv_ppp)

# This makes the project importable from the build directory
export(TARGETS ppp FILE cmake/cgv_pppConfig.cmake)
