# Only include file once
if (CGV_COMPONENT_CMAKE_INCLUDED)
    return()
endif()
set(CGV_COMPONENT_CMAKE_INCLUDED TRUE)

include(${CMAKE_SOURCE_DIR}/cmake/ppp.cmake)

function(cgv_add_component name)

    cmake_parse_arguments(
        ARGS # prefix of output variables
        "HEADER_ONLY" # list of names of the boolean arguments (only defined ones will be true)
        "" # list of names of mono-valued arguments
        "DEPENDS" # list of names of multi-valued arguments (output variables are lists)
        ${ARGN} # arguments of the function to parse, here we take the all original ones
    )

    file(GLOB_RECURSE SOURCES "src/*.cxx")
    file(GLOB_RECURSE PPP_SOURCES "include/*.ph")

    # Generate header files from pre-header templates.
    ppp_generate_headers(PPP_HEADERS
        TEMPLATES ${PPP_SOURCES})

    # TODO: Currently we do not support generating headers from pre-header
    #     templates.
    if(${ARGS_HEADER_ONLY})
        add_library(${name} INTERFACE)

        # Define headers for this header-only library.
        target_include_directories(${name}
            INTERFACE
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
                $<INSTALL_INTERFACE:include>)
        
    else()
        add_library(${name} SHARED
            ${SOURCES}
            ${PPP_SOURCES})

        # TODO: Static version of the library

        # Define headers for this library. PUBLIC headers are used for
        # compiling the library, and will be added to consumers' build
        # paths.
        target_include_directories(${name}
            PUBLIC
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
                $<INSTALL_INTERFACE:include>)

        if(PPP_SOURCES)
            target_include_directories(${name}
                PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>)
        endif()
    endif()

    # Dependencies on a other components
    if(ARGS_DEPENDS)
        target_link_libraries(${name} ${ARGS_DEPENDS})
    endif()

    # 'make install' to the correct locations (provided by GNUInstallDirs).
    install(TARGETS ${name} EXPORT ${name}Config
        ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR})  # This is for Windows

    # Install header files of component
    install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h")

    # Install generated headers
    if(PPP_SOURCES)
        install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include
            DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
    endif()

    # This makes the project importable from the install directory
    # Put config file in per-project dir (name MUST match)
    install(EXPORT ${name}Config DESTINATION cmake)

    # This makes the project importable from the build directory
    export(TARGETS ${name} FILE ${name}Config.cmake)

    # # Every library has unit tests, of course
    # add_executable(testlib
    #     test/testlib.cpp)

    # target_link_libraries(testlib
    #     ${name})

    # add_test(testlib testlib)

endfunction()