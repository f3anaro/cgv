project(rect_pack LANGUAGES CXX)

# Load required imported targets
find_package(cgv_config REQUIRED)

# RectangleBinPack is the underlying library on which rect_pack is built.
set(RectangleBinPack_SOURCES
	src/RectangleBinPack/GuillotineBinPack.cpp
	src/RectangleBinPack/MaxRectsBinPack.cpp
	src/RectangleBinPack/Readme.txt
	src/RectangleBinPack/Rect.cpp
	src/RectangleBinPack/ShelfBinPack.cpp
	src/RectangleBinPack/ShelfNextFitBinPack.cpp
	src/RectangleBinPack/SkylineBinPack.cpp
	src/RectangleBinPack/GuillotineBinPack.h
	src/RectangleBinPack/MaxRectsBinPack.h
	src/RectangleBinPack/Rect.h
	src/RectangleBinPack/ShelfBinPack.h
	src/RectangleBinPack/ShelfNextFitBinPack.h
	src/RectangleBinPack/SkylineBinPack.h)

add_library(rect_pack
	# Source files
	src/rect_pack.cxx

	# Public headers (Visual Studio only)
	include/rect_pack/lib_begin.h
	include/rect_pack/rect_pack.h

	# Underlying RectangleBinPack library
	${RectangleBinPack_SOURCES})

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::rect_pack ALIAS rect_pack)

set_target_properties(rect_pack PROPERTIES
	# Set name of the preprocessor symbol defined when compiling as shared
	# library. This will be used for the dllexport/dllimport declarations.
	DEFINE_SYMBOL "RECT_PACK_EXPORT"

	# Set folder for Visual Studio
	FOLDER "Additional Libraries")

# Move RectangleBinPack library files into their own folder in Visual Studio.
source_group("RectangleBinPack" FILES ${RectangleBinPack_SOURCES})

# Build library in directories matching the installation layout. If
# multi-config generators are used, build targets in a config-specific
# subdirectory.
if(CMAKE_CONFIGURATION_TYPES)
	set_target_properties(rect_pack PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
	set_target_properties(rect_pack PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

target_include_directories(rect_pack
	PUBLIC
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
		$<INSTALL_INTERFACE:include>)

# CGV uses C++11 standard
target_compile_features(rect_pack PUBLIC cxx_std_11)

# Dependencies on other components and libraries
target_link_libraries(rect_pack
	PUBLIC
		cgv::config)

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS rect_pack EXPORT rect_packTargets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT rect_packTargets NAMESPACE cgv:: DESTINATION cmake/rect_pack)
install(FILES rect_packConfig.cmake DESTINATION cmake/rect_pack)

# This makes the project importable from the build directory
export(TARGETS rect_pack NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/rect_packTargets.cmake)
file(COPY rect_packConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
