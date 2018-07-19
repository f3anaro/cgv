# Pre-preprocessor library used in as code-generator in the CGV project.
project(libppp LANGUAGES CXX)

set(SOURCES
    # Source files
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
    ../../components/utils/src/date_time.cxx

    # Public headers
    include/cgv/ppp/command_token.h
    include/cgv/ppp/expression_processor.h
    include/cgv/ppp/lib_begin.h
    include/cgv/ppp/operators.h
    include/cgv/ppp/ph_processor.h
    include/cgv/ppp/variables.h
    include/cgv/ppp/variant.h)

add_library(libppp ${SOURCES})

# Add an alias target for the cgv:: namespace such that other components can use
# this target like other imported targets with namespace prefixes.
add_library(cgv::libppp ALIAS libppp)

set_target_properties(libppp PROPERTIES
    # Remove the redundant "lib" prefix from the output name. Otherwise the
    # CMake target "libppp" would produce a library called "liblibppp".
    OUTPUT_NAME "ppp"

    # Set name of the preprocessor symbol defined when compiling as shared
    # library. This will be used for the dllexport/dllimport declarations.
    # 
    # Note:
    #
    #    libppp uses source files from other components. The definitions of
    #    these components have to be propagated to the respective header files
    #    and are used to define the dllexport/dllimport declarations for libppp
    #    itself. There is no specific export definition for libppp.
    #
    DEFINE_SYMBOL "CGV_MEDIA_TEXT_PPP_EXPORTS;CGV_UTILS_EXPORTS"

    # Set folder for Visual Studio
    FOLDER "Additional Libraries")

# Build library in directories matching the installation layout.
if(WIN32)
    set_target_properties(libppp PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
else()
    set_target_properties(libppp PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
endif()

if(${BUILD_SHARED_LIBS})
    # Explicit static version of libppp that is used to produce a statically linked
    # ppp executable.
    add_library(libppp_static STATIC ${SOURCES})

    # Add an namespace alias
    add_library(cgv::libppp_static ALIAS libppp_static)

    # Make library static
    target_compile_definitions(libppp_static
        PUBLIC
            CGV_UTILS_FORCE_STATIC
            CGV_RENDER_FORCE_STATIC
            CGV_MEDIA_TEXT_FORCE_STATIC
            CGV_MEDIA_TEXT_PPP_FORCE_STATIC)

    set_target_properties(libppp_static PROPERTIES
        # Remove "lib" prefix from filename and "_static" suffix.
        OUTPUT_NAME "ppp"
        
        # Set folder for Visual Studio
        FOLDER "Additional Libraries")

    # Build library in directories matching the installation layout.
    if(WIN32)
        set_target_properties(libppp_static PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_LIBDIR}
            RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>/${CMAKE_INSTALL_BINDIR})
    else()
        set_target_properties(libppp_static PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
            RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
    endif()
else()
    target_compile_definitions(libppp
        PUBLIC
            CGV_UTILS_FORCE_STATIC
            CGV_RENDER_FORCE_STATIC
            CGV_MEDIA_TEXT_FORCE_STATIC
            CGV_MEDIA_TEXT_PPP_FORCE_STATIC)
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
install(TARGETS ${exported_targets} EXPORT libpppTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

# Install header files of library.
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# This makes the project importable from the install directory
# Put config file in per-project dir (name MUST match), can also
# just go into 'cmake'.
install(EXPORT libpppTargets NAMESPACE cgv:: DESTINATION cmake/libppp)
install(FILES libpppConfig.cmake DESTINATION cmake/libppp)

# This makes the project importable from the build directory
export(TARGETS ${exported_targets} NAMESPACE cgv:: FILE ${CMAKE_BINARY_DIR}/cmake/libpppTargets.cmake)
file(COPY libpppConfig.cmake DESTINATION ${CMAKE_BINARY_DIR}/cmake)
