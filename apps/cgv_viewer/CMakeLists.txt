project(cgv_viewer LANGUAGES CXX)

find_package(cgv_signal REQUIRED)
find_package(cgv_base REQUIRED)
find_package(cgv_gui REQUIRED)

set(IMAGES
    resources/cgv_logo.png)

# Define cgv_viewer executable
add_executable(cgv_viewer
    src/main.cxx)

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

    # Add generated inline resource to executable
    target_sources(cgv_viewer PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${image}.cxx)
endforeach()

# Move resources into "Resources" folder in Visual Studio.
source_group("Resources" FILES ${IMAGES})

# CGV uses C++11 standard
target_compile_features(cgv_viewer PUBLIC cxx_std_11)

# Write executables in bin/ directory inside build directory matching the
# installation layout
if(CMAKE_CONFIGURATION_TYPES)
    set_target_properties(cgv_viewer PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(cgv_viewer PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

# Define the libraries this project depends upon
target_link_libraries(cgv_viewer
    cgv::signal
    cgv::base
    cgv::gui)

# Set folder for Visual Studio
set_target_properties(cgv_viewer PROPERTIES FOLDER "Applications")

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS cgv_viewer EXPORT cgv_viewerTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# This makes the project importable from the install directory. Put config file
# in per-project dir (name MUST match). An executable has no build dependencies.
# Hence, there is no need to create an extra cgv_viewerConfig.cmake file to
# resolve the dependencies. We just use the target defintion file.
install(EXPORT cgv_viewerTargets FILE cgv_viewerConfig.cmake DESTINATION cmake/cgv_viewer)

# This makes the project importable from the build directory
export(TARGETS cgv_viewer FILE cmake/cgv_viewerConfig.cmake)
