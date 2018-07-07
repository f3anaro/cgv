# Only include file once
if (CGV_PPP_CMAKE_INCLUDED)
    return()
endif()
set(CGV_PPP_CMAKE_INCLUDED TRUE)

include(CMakeParseArguments)

function(ppp_generate_headers generated)
    
    cmake_parse_arguments(
        ARGS # prefix of output variables
        "" # list of names of the boolean arguments (only defined ones will be true)
        "" # list of names of mono-valued arguments
        "TEMPLATES" # list of names of multi-valued arguments (output variables are lists)
        ${ARGN} # arguments of the function to parse, here we take the all original ones
    )

    set(_generated "")

    foreach(template ${ARGS_TEMPLATES})
        # Get directory path relative to the current source directory
        get_filename_component(dir ${template} DIRECTORY)
        string(REPLACE ${CMAKE_CURRENT_SOURCE_DIR}/ "" relative_path ${dir})

        # Get stem of the template path (directory and suffix removed)
        get_filename_component(stem ${template} NAME_WE)

        set(output_dir ${CMAKE_CURRENT_BINARY_DIR}/${relative_path})
        set(output ${output_dir}/${stem}.h)

        # Create output directory for header files generated from .ph templates
        file(MAKE_DIRECTORY ${output_dir})
        message(STATUS "Configure ppp for \"${relative_path}/${stem}.h\"")

        add_custom_command(
            OUTPUT ${output}
            COMMAND ppp
                -CGV_DIR=${CMAKE_SOURCE_DIR}
                ${template}
                ${output}
            MAIN_DEPENDENCY ${template}
            DEPENDS ppp)

        list(APPEND _generated ${output})
    endforeach()

    # Return list of generated files to the parent scope
    set(${generated} ${_generated} PARENT_SCOPE)
endfunction()
