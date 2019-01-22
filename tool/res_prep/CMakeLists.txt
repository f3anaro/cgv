project(res_prep LANGUAGES CXX)

# Load required imported targets
find_package(cgv_utils REQUIRED)

# Define res_prep executable
add_executable(res_prep
	src/res_prep.cxx

	# We want to create an executable without any 
	../../components/utils/src/scan.cxx
	../../components/utils/src/dir.cxx
	../../components/utils/src/file.cxx)

# CGV uses C++11 standard
target_compile_features(res_prep PUBLIC cxx_std_11)

# We do not need the exports because we statically linking against libppp
target_compile_definitions(res_prep PUBLIC CGV_FORCE_STATIC)

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

# Dependencies on other components and libraries
target_link_libraries(res_prep
	# We need headers from the utils component
	PRIVATE
		cgv::utils)

# Set folder for Visual Studio
set_target_properties(res_prep PROPERTIES FOLDER "Core Tools")

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS res_prep EXPORT cgv_res_prepTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory. Put config file
# in per-project dir (name MUST match). An executable has no build dependencies.
# Hence, there is no need to create an extra cgv_resp_prepConfig.cmake file to
# resolve the dependencies. We just use the target defintion file.
install(EXPORT cgv_res_prepTargets FILE cgv_res_prepConfig.cmake DESTINATION cmake/cgv_res_prep)

# Install Python script for generating string resources from arbitrary files.
install(PROGRAMS strres_prep.py DESTINATION ${CMAKE_INSTALL_BINDIR})

# This makes the project importable from the build directory
export(TARGETS res_prep FILE cmake/cgv_res_prepConfig.cmake)
