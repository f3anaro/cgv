# Pre-preprocessor library used in as code-generator in the CGV project.
project(libppp LANGUAGES CXX)

set(SOURCES
    src/command_token.cxx
    src/expression_processor.cxx
    src/operators.cxx
    src/ph_processor.cxx
    src/ppp_variant.cxx
    src/variables.cxx
    ../../components/utils/src/scan.cxx
    ../../components/utils/src/advanced_scan.cxx
    ../../components/utils/src/tokenizer.cxx
    ../../components/utils/src/token.cxx
    ../../components/utils/src/file.cxx
    ../../components/utils/src/dir.cxx
    ../../components/utils/src/date_time.cxx)

add_library(libppp ${SOURCES})

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::libppp ALIAS libppp)

# Remove the redundant "lib" prefix from the output name. Otherwise the CMake
# target "libppp" would produce a library called "liblibppp".
set_target_properties(libppp PROPERTIES OUTPUT_NAME "ppp")

if(${BUILD_SHARED_LIBS})
    # Explicit static version of libppp that is used to produce a statically linked
    # ppp executable.
    add_library(libppp_static STATIC ${SOURCES})

    # Add an namespace alias
    add_library(cgv::libppp_static ALIAS libppp_static)

    # Remove "lib" prefix from filename and "_static" suffix
    set_target_properties(libppp_static PROPERTIES OUTPUT_NAME "ppp")
endif()

if(${BUILD_SHARED_LIBS})
    # Compiler definitions for shared library
    target_compile_definitions(libppp
        PUBLIC
            CGV_MEDIA_TEXT_PPP_EXPORTS
            CGV_UTILS_EXPORTS)
endif()

foreach(lib libppp libppp_static)
    # The target "libppp_static" does not always exist
    if(TARGET ${lib})
        # Define headers for this library. PUBLIC headers are used forf compiling
        # the library, and will be added to consumers' build paths.
        target_include_directories(${lib}
            PUBLIC
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
                $<INSTALL_INTERFACE:include>
                # TODO: libppp requires header files from other CGV components but
                #     we cannot depend on them because this would create circular
                #     dependencies between the components and libppp.
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../components/config/include>
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../components/math/include>
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../../components/utils/include>)
    endif()
endforeach()

# The target "libppp_static" is only built if shared libraries are enabled
if (TARGET libppp_static)
    set(exported_targets libppp libppp_static)
else()
    set(exported_targets libppp)
endif()

# 'make install' to the correct locations (provided by GNUInstallDirs).
install(TARGETS ${exported_targets} EXPORT cgv_libpppTargets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library.
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT cgv_libpppTargets NAMESPACE cgv:: DESTINATION lib/cmake/cgv_libppp)
install(FILES cgv_libpppConfig.cmake DESTINATION lib/cmake/cgv_libppp)

# This makes the project importable from the build directory
export(TARGETS ${exported_targets} NAMESPACE cgv:: FILE cgv_libpppTargets.cmake)
